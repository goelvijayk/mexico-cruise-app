/** Event types aligned with Postgres check constraint on events.type */
export const EVENT_TYPES = [
  "flight",
  "hotel",
  "cruise_embark",
  "cruise_disembark",
  "port_call",
  "sea_day",
  "excursion",
  "transfer",
  "dining",
  "meetup",
  "other",
] as const;

export type EventType = (typeof EVENT_TYPES)[number];

export type EventStatus = "confirmed" | "tentative" | "cancelled";
export type IngestedEmailStatus = "parsed" | "failed" | "ignored" | "manual_done";
export type ReviewState = "none" | "flagged" | "revised" | "needs_human";

export interface TripContext {
  id: string;
  name: string;
  start_date: string;
  end_date: string;
  ship_time_zone: string;
  home_time_zone: string;
}

export interface IngestionConfig {
  supabaseUrl: string;
  supabaseServiceKey: string;
  geminiApiKey: string;
  tripId: string;
  gmailLabel: string;
  processedLabel: string;
  alertEmail: string;
  webappSecret: string;
  /** Storage upload cap (bytes); PRD default 50 MB */
  maxStorageUploadBytes: number;
  /** Gemini inline PDF cap (bytes); PRD default 20 MB */
  maxGeminiInlineBytes: number;
  maxEmailsPerRun: number;
  bodyTextMaxBytes: number;
  geminiModel: string;
}

export interface EmailAttachmentMeta {
  name: string;
  mimeType: string;
  sizeBytes: number;
  /** Gmail attachment id for fetching bytes */
  gmailAttachmentId: string;
  bytes?: Uint8Array;
}

export interface ParsedEmail {
  gmailMessageId: string;
  threadId: string;
  fromAddr: string;
  subject: string;
  receivedAt: string;
  snippet: string;
  bodyText: string;
  gmailLink: string;
  attachments: EmailAttachmentMeta[];
}

export interface GeminiEvent {
  type: EventType;
  status?: EventStatus;
  title: string;
  start_local: string;
  start_tz: string;
  end_local?: string | null;
  end_tz?: string | null;
  all_day?: boolean;
  location?: Record<string, unknown> | null;
  provider?: string | null;
  booking_ref?: string | null;
  details?: Record<string, unknown> | null;
  travelers?: string[];
  cost?: Record<string, unknown> | null;
  attachment_indexes?: number[];
  confidence: number;
}

export interface GeminiExtraction {
  is_travel_related: boolean;
  summary: string;
  events: GeminiEvent[];
  supersedes_booking_refs?: string[];
}

export interface StoredAttachment {
  id: string;
  trip_id: string;
  event_id: string | null;
  kind: string;
  file_name: string;
  mime_type: string;
  size_bytes: number;
  sha256: string;
  storage_path: string;
  source: Record<string, unknown>;
  created_by: string;
  updated_by: string;
}

export interface StoredEvent {
  id: string;
  trip_id: string;
  type: EventType;
  status: EventStatus;
  title: string;
  start_local: string;
  start_tz: string;
  end_local: string | null;
  end_tz: string | null;
  all_day: boolean;
  location: Record<string, unknown> | null;
  provider: string | null;
  booking_ref: string | null;
  details: Record<string, unknown> | null;
  travelers: string[];
  cost: Record<string, unknown> | null;
  notes: string | null;
  source: Record<string, unknown>;
  review_state: ReviewState;
  edited_fields: string[];
  created_by: string;
  updated_by: string;
  updated_at: string;
  deleted_at: string | null;
}

export interface IngestedEmailRow {
  gmail_message_id: string;
  trip_id: string;
  thread_id: string;
  from_addr: string;
  subject: string;
  received_at: string;
  snippet: string;
  body_text: string;
  gmail_link: string;
  status: IngestedEmailStatus;
  failure_reason: string | null;
  event_ids: string[];
  attachment_count: number;
  reparse_requested: boolean;
  reparse_note: string | null;
  updated_at: string;
}

export interface RevisionRequestRow {
  id: string;
  event_id: string;
  note: string;
  requested_by: string;
  requested_at: string;
  status: "open" | "applied" | "needs_human" | "failed";
  result_note: string | null;
  diff: Record<string, unknown> | null;
  applied_at: string | null;
  updated_at: string;
}

export interface LogEntry {
  level: "info" | "warn" | "error";
  message: string;
  context?: Record<string, unknown>;
  ts: string;
}

export interface Logger {
  info(message: string, context?: Record<string, unknown>): void;
  warn(message: string, context?: Record<string, unknown>): void;
  error(message: string, context?: Record<string, unknown>): void;
  flush(): LogEntry[];
}

export interface SupabaseClient {
  getTrip(tripId: string): Promise<TripContext | null>;
  getIngestedEmail(gmailMessageId: string): Promise<IngestedEmailRow | null>;
  upsertIngestedEmail(row: Partial<IngestedEmailRow> & { gmail_message_id: string; trip_id: string }): Promise<void>;
  listReparseRequested(): Promise<IngestedEmailRow[]>;
  listOpenRevisionRequests(): Promise<RevisionRequestRow[]>;
  getEvent(id: string): Promise<StoredEvent | null>;
  getEventsByBookingRefs(refs: string[]): Promise<StoredEvent[]>;
  applyEventChanges(rows: Record<string, unknown>[]): Promise<{ accepted: string[]; rejected: string[] }>;
  patchEvent(id: string, patch: Record<string, unknown>): Promise<void>;
  upsertAttachment(row: Record<string, unknown>): Promise<void>;
  getAttachmentBySha256(tripId: string, sha256: string): Promise<StoredAttachment | null>;
  patchAttachment(id: string, patch: Record<string, unknown>): Promise<void>;
  patchRevisionRequest(id: string, patch: Record<string, unknown>): Promise<void>;
  uploadStorageObject(storagePath: string, bytes: Uint8Array, mimeType: string): Promise<void>;
  nowIso(): string;
}

export interface GeminiClient {
  extractFromEmail(input: {
    trip: TripContext;
    email: ParsedEmail;
    attachmentParts: { mimeType: string; base64: string; fileName: string }[];
    reparseNote?: string;
    revisionContext?: { note: string; currentEvent: StoredEvent };
  }): Promise<GeminiExtraction>;
}

export interface GmailClient {
  searchUnprocessed(query: string, maxResults: number): Promise<ParsedEmail[]>;
  markProcessed(messageId: string, processedLabel: string): void;
  getMessageById(messageId: string): Promise<ParsedEmail | null>;
}

export interface LockHandle {
  release(): void;
}

export interface RuntimeDeps {
  config: IngestionConfig;
  log: Logger;
  supabase: SupabaseClient;
  gemini: GeminiClient;
  gmail: GmailClient;
  sha256(bytes: Uint8Array): string;
  tryAcquireLock(name: string, waitMs: number): LockHandle | null;
  sendAlert(subject: string, body: string): void;
  lastAlertAt?: () => number | null;
  setLastAlertAt?(ms: number): void;
}
