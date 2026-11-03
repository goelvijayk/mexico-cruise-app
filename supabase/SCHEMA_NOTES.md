# Schema notes — deviations from `docs/prd-final.md`

| Item | PRD | This repo |
|------|-----|-----------|
| Event merge on phones | Row LWW via `apply_changes` | **Field-level** merge via `apply_field_patches` + `events.field_meta` (see `supabase/README.md`) |
| `apply_changes` | Generic upsert | `events`, `attachments`, `revision_requests` only; **`ingested_emails` uses PostgREST upsert** (ingestion contract) |
| New column | — | `events.field_meta jsonb` for per-field LWW timestamps |

Ingestion alignment: `supabase/INGESTION_CONTRACT.md` (mirrors `ingestion/SCHEMA_ASSUMPTIONS.md`).

All table/column names match PRD §4.1 and the ingestion PR.
