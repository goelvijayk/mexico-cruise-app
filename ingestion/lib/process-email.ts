import { eventIdForMessage } from "./uuid-v5.js";
import type {
  EmailAttachmentMeta,
  GeminiEvent,
  ParsedEmail,
  RuntimeDeps,
  StoredAttachment,
  TripContext,
} from "./types.js";
import {
  isUploadableMime,
  normalizeEventStatus,
  truncateUtf8,
  validateExtraction,
  storagePathFor,
} from "./validation.js";

export interface ProcessEmailResult {
  status: "parsed" | "failed" | "ignored";
  eventIds: string[];
  failureReason: string | null;
}

export interface AttachmentUploadResult {
  storedByIndex: (import("./types.js").StoredAttachment | null)[];
  unanalyzedIndexes: number[];
  skippedOversize: string[];
}

export async function processOneEmail(
  deps: RuntimeDeps,
  trip: TripContext,
  email: ParsedEmail,
  options?: { reparseNote?: string; skipProcessedCheck?: boolean }
): Promise<ProcessEmailResult> {
  const { config, log, supabase, gemini } = deps;
  const now = supabase.nowIso();
  const bodyText = truncateUtf8(email.bodyText, config.bodyTextMaxBytes);

  await supabase.upsertIngestedEmail({
    gmail_message_id: email.gmailMessageId,
    trip_id: config.tripId,
    thread_id: email.threadId,
    from_addr: email.fromAddr,
    subject: email.subject,
    received_at: email.receivedAt,
    snippet: email.snippet,
    body_text: bodyText,
    gmail_link: email.gmailLink,
    status: "failed",
    failure_reason: "processing",
    event_ids: [],
    attachment_count: 0,
    reparse_requested: false,
    reparse_note: null,
    updated_at: now,
  });

  let attachmentResult: AttachmentUploadResult;
  try {
    attachmentResult = await uploadAttachments(deps, trip.id, email);
  } catch (e) {
    const reason = e instanceof Error ? e.message : String(e);
    await finalizeIngested(deps, email, "failed", [], 0, reason);
    return { status: "failed", eventIds: [], failureReason: reason };
  }

  const inlineParts = buildGeminiInlineParts(email.attachments, attachmentResult, config.maxGeminiInlineBytes);

  let extraction;
  try {
    extraction = await gemini.extractFromEmail({
      trip,
      email: { ...email, bodyText },
      attachmentParts: inlineParts,
      reparseNote: options?.reparseNote,
    });
  } catch (e) {
    const reason = e instanceof Error ? e.message : String(e);
    log.error("Gemini extraction failed", { gmailMessageId: email.gmailMessageId, reason });
    await finalizeIngested(deps, email, "failed", [], attachmentResult.storedByIndex.filter(Boolean).length, reason);
    return { status: "failed", eventIds: [], failureReason: reason };
  }

  const validationErr = validateExtraction(extraction);
  if (validationErr) {
    await finalizeIngested(deps, email, "failed", [], attachmentResult.storedByIndex.filter(Boolean).length, validationErr);
    return { status: "failed", eventIds: [], failureReason: validationErr };
  }

  if (!extraction.is_travel_related) {
    await finalizeIngested(deps, email, "ignored", [], attachmentResult.storedByIndex.filter(Boolean).length, null);
    return { status: "ignored", eventIds: [], failureReason: null };
  }

  if (!extraction.events.length) {
    await finalizeIngested(deps, email, "failed", [], attachmentResult.storedByIndex.filter(Boolean).length, "no events found");
    return { status: "failed", eventIds: [], failureReason: "no events found" };
  }

  const eventIds: string[] = [];
  const rows: Record<string, unknown>[] = [];

  extraction.events.forEach((ev, index) => {
    const id = eventIdForMessage(email.gmailMessageId, index);
    eventIds.push(id);
    rows.push(buildEventRow(deps, trip, email, ev, id, index, attachmentResult, extraction.summary));
  });

  try {
    await supabase.applyEventChanges(rows);
  } catch (e) {
    const reason = e instanceof Error ? e.message : String(e);
    await finalizeIngested(deps, email, "failed", [], attachmentResult.storedByIndex.filter(Boolean).length, reason);
    return { status: "failed", eventIds: [], failureReason: reason };
  }

  await linkAttachmentsToEvents(deps, attachmentResult.storedByIndex, extraction.events, eventIds);

  if (extraction.supersedes_booking_refs?.length) {
    await handleSupersedes(deps, extraction.supersedes_booking_refs, extraction.events);
  }

  await finalizeIngested(deps, email, "parsed", eventIds, attachmentResult.storedByIndex.filter(Boolean).length, null);
  log.info("Email parsed", { gmailMessageId: email.gmailMessageId, eventIds });
  return { status: "parsed", eventIds, failureReason: null };
}

function buildEventRow(
  deps: RuntimeDeps,
  trip: TripContext,
  email: ParsedEmail,
  ev: GeminiEvent,
  id: string,
  index: number,
  attachmentResult: AttachmentUploadResult,
  summary: string
): Record<string, unknown> {
  const now = deps.supabase.nowIso();
  const unanalyzed = attachmentResult.unanalyzedIndexes.map((i) => email.attachments[i]?.name).filter(Boolean);
  return {
    id,
    trip_id: trip.id,
    type: ev.type,
    status: normalizeEventStatus(ev.status),
    title: ev.title,
    start_local: ev.start_local,
    start_tz: ev.start_tz,
    end_local: ev.end_local ?? null,
    end_tz: ev.end_tz ?? null,
    all_day: ev.all_day ?? false,
    location: ev.location ?? null,
    provider: ev.provider ?? null,
    booking_ref: ev.booking_ref ?? null,
    details: ev.details ?? null,
    travelers: ev.travelers ?? [],
    cost: ev.cost ?? null,
    notes: null,
    source: {
      kind: "email",
      gmail_message_id: email.gmailMessageId,
      thread_id: email.threadId,
      subject: email.subject,
      received_at: email.receivedAt,
      model: deps.config.geminiModel,
      confidence: ev.confidence,
      extraction_summary: summary,
      unanalyzed_attachments: unanalyzed,
      event_index: index,
    },
    review_state: "none",
    edited_fields: [],
    created_at: now,
    created_by: "ingestion",
    updated_at: now,
    updated_by: "ingestion",
    deleted_at: null,
  };
}

async function uploadAttachments(
  deps: RuntimeDeps,
  tripId: string,
  email: ParsedEmail
): Promise<AttachmentUploadResult> {
  const { config, supabase, sha256, log } = deps;
  const storedByIndex: (StoredAttachment | null)[] = email.attachments.map(() => null);
  const unanalyzedIndexes: number[] = [];
  const skippedOversize: string[] = [];

  for (let i = 0; i < email.attachments.length; i++) {
    const att = email.attachments[i]!;
    if (!isUploadableMime(att.mimeType)) continue;

    if (att.sizeBytes > config.maxStorageUploadBytes) {
      skippedOversize.push(att.name);
      log.warn("Attachment over storage limit", { name: att.name, sizeBytes: att.sizeBytes });
      continue;
    }

    const bytes = att.bytes;
    if (!bytes) {
      log.warn("Attachment missing bytes", { name: att.name });
      continue;
    }

    const hash = sha256(bytes);
    const existing = await supabase.getAttachmentBySha256(tripId, hash);
    if (existing) {
      storedByIndex[i] = existing;
      if (bytes.length > config.maxGeminiInlineBytes) unanalyzedIndexes.push(i);
      continue;
    }

    const path = storagePathFor(tripId, hash, att.name);
    await supabase.uploadStorageObject(path, bytes, att.mimeType);
    const now = supabase.nowIso();
    const row = {
      id: cryptoRandomUuid(),
      trip_id: tripId,
      event_id: null,
      kind: guessKind(att.mimeType),
      file_name: att.name,
      mime_type: att.mimeType,
      size_bytes: att.sizeBytes,
      sha256: hash,
      storage_path: path,
      source: {
        gmail_message_id: email.gmailMessageId,
        gmail_attachment_id: att.gmailAttachmentId,
      },
      created_at: now,
      created_by: "ingestion",
      updated_at: now,
      updated_by: "ingestion",
      deleted_at: null,
    };
    await supabase.upsertAttachment(row);
    storedByIndex[i] = row as StoredAttachment;
    if (bytes.length > config.maxGeminiInlineBytes) unanalyzedIndexes.push(i);
  }

  return { storedByIndex, unanalyzedIndexes, skippedOversize };
}

function buildGeminiInlineParts(
  attachments: EmailAttachmentMeta[],
  result: AttachmentUploadResult,
  maxInline: number
): { mimeType: string; base64: string; fileName: string }[] {
  const parts: { mimeType: string; base64: string; fileName: string }[] = [];
  for (let i = 0; i < attachments.length; i++) {
    if (result.unanalyzedIndexes.includes(i)) continue;
    const att = attachments[i]!;
    if (!att.bytes || att.bytes.length > maxInline) continue;
    if (!isUploadableMime(att.mimeType)) continue;
    parts.push({
      fileName: att.name,
      mimeType: att.mimeType,
      base64: bytesToBase64(att.bytes),
    });
  }
  return parts;
}

async function linkAttachmentsToEvents(
  deps: RuntimeDeps,
  storedByIndex: (StoredAttachment | null)[],
  events: GeminiEvent[],
  eventIds: string[]
): Promise<void> {
  for (let e = 0; e < events.length; e++) {
    const indexes = events[e]?.attachment_indexes ?? [];
    const eventId = eventIds[e]!;
    for (const idx of indexes) {
      const attMeta = storedByIndex[idx];
      if (!attMeta) continue;
      await deps.supabase.patchAttachment(attMeta.id, {
        event_id: eventId,
        updated_at: deps.supabase.nowIso(),
        updated_by: "ingestion",
      });
    }
  }
}

async function handleSupersedes(
  deps: RuntimeDeps,
  refs: string[],
  newEvents: GeminiEvent[]
): Promise<void> {
  const existing = await deps.supabase.getEventsByBookingRefs(refs);
  const now = deps.supabase.nowIso();
  const anyCancelled = newEvents.some((e) => e.status === "cancelled");
  for (const ev of existing) {
    if (anyCancelled) {
      await deps.supabase.patchEvent(ev.id, {
        status: "cancelled",
        updated_at: now,
        updated_by: "ingestion",
      });
    }
  }
}

async function finalizeIngested(
  deps: RuntimeDeps,
  email: ParsedEmail,
  status: "parsed" | "failed" | "ignored",
  eventIds: string[],
  attachmentCount: number,
  failureReason: string | null
): Promise<void> {
  await deps.supabase.upsertIngestedEmail({
    gmail_message_id: email.gmailMessageId,
    trip_id: deps.config.tripId,
    thread_id: email.threadId,
    from_addr: email.fromAddr,
    subject: email.subject,
    received_at: email.receivedAt,
    snippet: email.snippet,
    body_text: truncateUtf8(email.bodyText, deps.config.bodyTextMaxBytes),
    gmail_link: email.gmailLink,
    status,
    failure_reason: failureReason,
    event_ids: eventIds,
    attachment_count: attachmentCount,
    reparse_requested: false,
    reparse_note: null,
    updated_at: deps.supabase.nowIso(),
  });
}

function guessKind(mime: string): string {
  if (mime.includes("pdf")) return "confirmation";
  if (mime.includes("pkpass")) return "boarding_pass";
  if (mime.includes("calendar")) return "itinerary";
  return "document";
}

function bytesToBase64(bytes: Uint8Array): string {
  let binary = "";
  const chunk = 8192;
  for (let i = 0; i < bytes.length; i += chunk) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunk));
  }
  if (typeof btoa !== "undefined") return btoa(binary);
  return Buffer.from(bytes).toString("base64");
}

function cryptoRandomUuid(): string {
  if (typeof crypto !== "undefined" && crypto.randomUUID) return crypto.randomUUID();
  return "00000000-0000-4000-8000-" + Math.random().toString(16).slice(2, 14).padEnd(12, "0");
}
