import { eventIdForMessage } from "./uuid-v5.js";
import { computeEventDiff, mergeExtractionIntoEvent } from "./event-merge.js";
import { validateExtraction, validateGeminiEvent } from "./validation.js";
import type { RevisionRequestRow, RuntimeDeps, StoredEvent } from "./types.js";

const MAX_REVISION_ATTEMPTS = 3;

export async function applyRevisionRequest(
  deps: RuntimeDeps,
  request: RevisionRequestRow,
  trip: import("./types.js").TripContext
): Promise<void> {
  const { supabase, log, gmail } = deps;
  const event = await supabase.getEvent(request.event_id);
  if (!event) {
    await closeRevision(deps, request.id, "failed", "Event not found");
    return;
  }

  const source = event.source as { kind?: string; gmail_message_id?: string };
  if (source.kind !== "email" || !source.gmail_message_id) {
    await closeRevision(deps, request.id, "needs_human", "No source email; please edit manually");
    return;
  }

  const email = await gmail.getMessageById(source.gmail_message_id);
  if (!email) {
    await closeRevision(deps, request.id, "needs_human", "No source email; please edit manually");
    return;
  }

  let extraction;
  try {
    extraction = await deps.gemini.extractFromEmail({
      trip,
      email,
      attachmentParts: [],
      revisionContext: { note: request.note, currentEvent: event },
    });
  } catch (e) {
    const failCount = parseFailCount(request.result_note);
    if (failCount + 1 >= MAX_REVISION_ATTEMPTS) {
      await closeRevision(
        deps,
        request.id,
        "needs_human",
        `Gemini failed: ${e instanceof Error ? e.message : String(e)}`
      );
    } else {
      await closeRevision(
        deps,
        request.id,
        "failed",
        `attempt:${failCount + 1} ${e instanceof Error ? e.message : String(e)}`
      );
    }
    return;
  }

  const validationErr = validateExtraction(extraction);
  if (validationErr) {
    await closeRevision(deps, request.id, "failed", validationErr);
    return;
  }

  const corrected = pickMatchingEvent(extraction.events, event, source.gmail_message_id);
  if (!corrected) {
    await closeRevision(deps, request.id, "needs_human", "Re-read the email and found no change; please edit manually");
    return;
  }

  const evErr = validateGeminiEvent(corrected, 0);
  if (evErr) {
    await closeRevision(deps, request.id, "failed", evErr);
    return;
  }

  const extractedRow = buildExtractedPatch(deps, event, corrected, email);
  const diff = computeEventDiff(event, extractedRow, event.edited_fields);
  if (Object.keys(diff).length === 0) {
    await closeRevision(
      deps,
      request.id,
      "needs_human",
      "Re-read the email and found no change; please edit manually"
    );
    return;
  }

  const patch = mergeExtractionIntoEvent(event, extractedRow, {
    updated_at: supabase.nowIso(),
    updated_by: "ingestion",
    review_state: "revised",
  });
  patch.review_state = "revised";

  await supabase.patchEvent(event.id, patch);
  await closeRevision(deps, request.id, "applied", extraction.summary, diff);
  log.info("Revision applied", { requestId: request.id, eventId: event.id });
}

function pickMatchingEvent(
  events: import("./types.js").GeminiEvent[],
  existing: StoredEvent,
  gmailMessageId: string
) {
  const byIdIndex = (existing.source as { event_index?: number }).event_index;
  if (typeof byIdIndex === "number") {
    const id = eventIdForMessage(gmailMessageId, byIdIndex);
    if (existing.id === id && events[0]) return events[0];
  }
  if (existing.booking_ref) {
    const match = events.find((e) => e.booking_ref === existing.booking_ref);
    if (match) return match;
  }
  return events[0] ?? null;
}

function buildExtractedPatch(
  deps: RuntimeDeps,
  event: StoredEvent,
  ev: import("./types.js").GeminiEvent,
  email: import("./types.js").ParsedEmail
): Record<string, unknown> {
  return {
    type: ev.type,
    status: ev.status ?? event.status,
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
    source: {
      ...(event.source as Record<string, unknown>),
      model: deps.config.geminiModel,
      confidence: ev.confidence,
      revision_applied_at: deps.supabase.nowIso(),
      subject: email.subject,
    },
  };
}

async function closeRevision(
  deps: RuntimeDeps,
  id: string,
  status: RevisionRequestRow["status"],
  resultNote: string,
  diff?: Record<string, { before: unknown; after: unknown }>
): Promise<void> {
  const now = deps.supabase.nowIso();
  await deps.supabase.patchRevisionRequest(id, {
    status,
    result_note: resultNote,
    diff: diff ?? null,
    applied_at: status === "applied" ? now : null,
    updated_at: now,
  });
}

function parseFailCount(resultNote: string | null): number {
  if (!resultNote?.startsWith("attempt:")) return 0;
  const n = parseInt(resultNote.split(" ")[0]!.replace("attempt:", ""), 10);
  return Number.isFinite(n) ? n : 0;
}