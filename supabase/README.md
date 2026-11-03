# Supabase backend — Mexico Cruise

Postgres schema, RLS, merge RPCs, Storage bucket `trip-docs`, and seed data for the Flutter app.

## Merge design (field-level)

Phone edits are pushed as an **outbox of field patches** and applied by the `apply_field_patches(patches jsonb)` RPC in **client `updated_at` order**.

Each patch: `{ patch_id, row_id, field, value, updated_at, updated_by, ...bootstrap fields for new rows }`.

Per field, the server stores last-write metadata in `events.field_meta` → `{ "<field>": { "updated_at", "updated_by" } }`. A patch applies iff `patch.updated_at >= field_meta[field].updated_at` (same-field conflicts: **last writer wins**). Different fields on the same event merge independently.

Row `updated_at` is bumped to the latest applied patch time for pull-by-cursor. **Soft deletes** set `deleted_at` via a patch on field `deleted_at`.

Ingestion uses `apply_changes('events', …)` (never overwrites `notes` or columns in `edited_fields` on conflict). Email rows upsert to `ingested_emails` via PostgREST. See `INGESTION_CONTRACT.md` and `ingestion/SCHEMA_ASSUMPTIONS.md`.

## Windows PC runbook

1. Install [Supabase CLI](https://supabase.com/docs/guides/cli) and [Docker Desktop](https://www.docker.com/products/docker-desktop/) (WSL2 backend on Windows 11).
2. Clone the repo; open PowerShell in the repo root.
3. `supabase login` (browser).
4. Create a hosted project (or local):
   - **Hosted:** link with `supabase link --project-ref <ref>`, then `supabase db push`, then run `seed.sql` in the SQL Editor.
   - **Local:** `supabase start`, then `supabase db reset` (applies migrations + optional seed if configured).
5. Dashboard → **Storage** → confirm bucket `trip-docs` (50 MB file limit).
6. **Auth** → Email provider → disable sign-ups → create user `trip@yourdomain` with the group password.
7. Copy **Project URL** and **anon key** into the app (`app/.env` from `.env.example` or `--dart-define`).
8. Keep **service_role** in Apps Script only (ingestion, not in the app).

Smoke test: Table Editor → `events` → edit a row → Refresh on a phone.

## Migrations layout

| File | Purpose |
|------|---------|
| `20251103000001_schema.sql` | Tables + `field_meta` |
| `20251103000002_rls.sql` | Authenticated policies |
| `20251103000003_functions.sql` | `server_time`, `apply_changes`, `apply_field_patches` |
| `20251103000004_storage.sql` | `trip-docs` bucket policies |

Validate SQL without Docker: review migrations manually; `apply_field_patches` uses a fixed column whitelist.
