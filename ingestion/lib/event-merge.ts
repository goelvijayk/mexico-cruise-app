import type { StoredEvent } from "./types.js";

/** Columns the ingestion script may write (never overwrites notes). */
export const EXTRACTABLE_EVENT_COLUMNS = [
  "type",
  "status",
  "title",
  "start_local",
  "start_tz",
  "end_local",
  "end_tz",
  "all_day",
  "location",
  "provider",
  "booking_ref",
  "details",
  "travelers",
  "cost",
  "source",
  "review_state",
] as const;

export type ExtractableColumn = (typeof EXTRACTABLE_EVENT_COLUMNS)[number];

export function computeEventDiff(
  before: StoredEvent,
  after: Record<string, unknown>,
  protectedFields: readonly string[] = before.edited_fields
): Record<string, { before: unknown; after: unknown }> {
  const diff: Record<string, { before: unknown; after: unknown }> = {};
  for (const col of EXTRACTABLE_EVENT_COLUMNS) {
    if (protectedFields.includes(col)) continue;
    const b = (before as unknown as Record<string, unknown>)[col];
    const a = after[col];
    if (!jsonEqual(b, a)) {
      diff[col] = { before: b, after: a };
    }
  }
  return diff;
}

export function buildPatchFromDiff(
  diff: Record<string, { before: unknown; after: unknown }>
): Record<string, unknown> {
  const patch: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(diff)) {
    patch[k] = v.after;
  }
  return patch;
}

export function mergeExtractionIntoEvent(
  existing: StoredEvent,
  extracted: Record<string, unknown>,
  meta: { updated_at: string; updated_by: string; review_state?: string }
): Record<string, unknown> {
  const patch: Record<string, unknown> = {
    updated_at: meta.updated_at,
    updated_by: meta.updated_by,
  };
  if (meta.review_state) patch.review_state = meta.review_state;
  for (const col of EXTRACTABLE_EVENT_COLUMNS) {
    if (existing.edited_fields.includes(col)) continue;
    if (col in extracted) patch[col] = extracted[col];
  }
  return patch;
}

function jsonEqual(a: unknown, b: unknown): boolean {
  return JSON.stringify(a) === JSON.stringify(b);
}
