# Ingestion ↔ migrations contract

Must stay aligned with `ingestion/SCHEMA_ASSUMPTIONS.md` on branch `feat/gmail-ingestion`.

## Tables (exact names)

`trip`, `events`, `attachments`, **`ingested_emails`** (not `unprocessed_emails`), `revision_requests`.

## `ingested_emails`

- PK: `gmail_message_id` (text)
- `status` ∈ `parsed` | `failed` | `ignored` | `manual_done`
- Ingestion upserts via PostgREST (`Prefer: resolution=merge-duplicates`), not `apply_changes`.

## `events` (ingestion)

- Upsert via **`apply_changes('events', rows)`** with **service role**
- Deterministic id: **UUID v5**, namespace `6ba7b810-9dad-11d1-80b4-00c04fd430c8`, name `${gmail_message_id}:${index}` (computed in ingestion script)
- On conflict: **`notes` is never overwritten**; columns in **`edited_fields`** are not overwritten
- `created_by` / `updated_by`: `'ingestion'`

## Storage

- Bucket: **`trip-docs`** (private), **50 MB** object limit
- Object key / `attachments.storage_path`: `<trip_id>/<sha256>.<ext>` (no bucket prefix in the column)

## RPC

```sql
apply_changes(tbl text, rows jsonb) returns jsonb
-- { "accepted": uuid[], "rejected": uuid[] }
```

Supported `tbl` values: `events`, `attachments`, `revision_requests`.

Phone field merge uses separate **`apply_field_patches`** (authenticated only); ingestion does not call it.
