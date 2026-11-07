# Schema assumptions (ingestion ↔ `supabase/`)

The ingestion script targets the Postgres schema in `docs/prd-final.md` §4.1. The sibling `supabase/` migrations should match these names and semantics.

## Table name: `ingested_emails` (not `unprocessed_emails`)

Early drafts used `unprocessed_emails`; the buildable PRD and app Inbox use **`ingested_emails`** with primary key `gmail_message_id`. The ingestion pipeline writes only to `ingested_emails`.

## Tables and columns the script writes

### `ingested_emails`

- Upsert by `gmail_message_id` (PostgREST `Prefer: resolution=merge-duplicates`).
- Sets `status` ∈ `parsed` | `failed` | `ignored` during processing; stores `failure_reason`, `body_text` (≤ 200 KB), `event_ids`, `attachment_count`, `gmail_link`.
- Reads `reparse_requested=true` rows for manual retry; clears flag after processing.

### `events`

- New rows via RPC **`apply_changes('events', rows)`** with service role.
- Expects RPC to respect existing **`edited_fields`** on conflict (never overwrite listed columns or `notes`). If RPC is not yet deployed, ingestion still sends full rows for new inserts; revision patches use direct PATCH with client-side `edited_fields` filtering.
- Deterministic **`id`**: UUID v5 with namespace `6ba7b810-9dad-11d1-80b4-00c04fd430c8` and name `${gmail_message_id}:${eventIndex}`.
- **`source`**: `{ kind:'email', gmail_message_id, thread_id, subject, received_at, model, confidence, … }`.
- **`created_by` / `updated_by`**: `'ingestion'`.

### `attachments`

- Insert/upsert metadata; **`storage_path`**: `<trip_id>/<sha256>.<ext>` (bucket **`trip-docs`**).
- Unique dedupe on `(trip_id, sha256)` where `deleted_at is null`.
- **`source`**: `{ gmail_message_id, gmail_attachment_id }`.

### `revision_requests`

- PATCH `status`, `result_note`, `diff`, `applied_at` when applying traveler feedback.

### `trip`

- Read-only: `id`, `name`, dates, `ship_time_zone`, `home_time_zone` for Gemini context.

## Storage

- Bucket: **`trip-docs`** (private).
- Upload: `POST /storage/v1/object/trip-docs/{storage_path}` with service role, `x-upsert: true`.
- Max upload size assumed **50 MB** (Supabase project file limit). Files over limit are not uploaded; `ingested_emails.failure_reason` may note oversize; **`gmail_link`** remains for manual fetch.

## Auth

- Script uses **`SUPABASE_SERVICE_KEY`** (service role) only in Script Properties.
- No anon key in the script.

## Gemini

- Model default: **`gemini-2.0-flash`** (override with `GEMINI_MODEL` Script Property).
- Structured JSON schema in `lib/gemini-schema.ts`; inline PDF limit **20 MB** per attachment.

## Assumed RPC signature

```sql
apply_changes(tbl text, rows jsonb) returns jsonb
-- returns { "accepted": uuid[], "rejected": uuid[] }
```

## Indexes / constraints expected

- `events.type` check enum matches PRD §4.1.
- `ingested_emails.status` check includes `parsed`, `failed`, `ignored`, `manual_done`.
- `revision_requests.status` includes `open`, `applied`, `needs_human`, `failed`.

If migrations differ, update this file and the PostgREST paths in `lib/supabase-client.ts` together.
