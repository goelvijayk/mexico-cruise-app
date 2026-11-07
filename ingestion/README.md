# Gmail ingestion (`ingestion/`)

Google Apps Script (clasp-managed) that runs every 10 minutes in the trip Gmail account, extracts booking events with Gemini structured JSON, and writes to Supabase PostgREST + Storage using the **service role** key from Script Properties only.

## Prerequisites (Windows PC)

- Node.js 20+ and npm
- A Google account that receives trip booking email
- Supabase project with schema from `supabase/` (sibling branch): tables `trip`, `events`, `attachments`, `ingested_emails`, `revision_requests`, RPC `apply_changes`, Storage bucket `trip-docs`
- Gemini API key from Google AI Studio
- `@google/clasp` logged in: `npx clasp login`

## One-time setup

1. **Gmail labels** (or let `setup()` create them): `Trip-Mexico` and nested `Trip-Mexico/processed`. Filter booking senders to the trip label.
2. **Clone this repo** and open a terminal in `ingestion/`.
3. **Install**: `npm install`
4. **Create the Apps Script project** at [script.google.com](https://script.google.com) → New project. Copy the Script ID from Project Settings.
5. **Link clasp**: edit `clasp.json` and replace `REPLACE_WITH_YOUR_SCRIPT_ID` with your Script ID.
6. **Build and push**: `npm run build` then `npx clasp push`
7. **Script Properties** (Project Settings → Script properties):

   | Property | Example |
   |---|---|
   | `SUPABASE_URL` | `https://xxxx.supabase.co` |
   | `SUPABASE_SERVICE_KEY` | service role JWT (never commit) |
   | `GEMINI_API_KEY` | AI Studio key |
   | `TRIP_ID` | `mex-2026-12` |
   | `GMAIL_LABEL` | `Trip-Mexico` (optional) |
   | `PROCESSED_LABEL` | `Trip-Mexico/processed` (optional) |
   | `ALERT_EMAIL` | your email for hourly error alerts (optional) |
   | `WEBAPP_SECRET` | random string for optional “check email now” web app |

8. **Authorize**: In the script editor, run **`setup()`** once and approve Gmail + external HTTP scopes.
9. **Trigger**: Run **`installTrigger()`** once (or Triggers UI → `run` → time-driven → every 10 minutes).
10. **Smoke test**: Label a real booking email `Trip-Mexico`, wait up to 10 minutes (or deploy web app and call `doGet?key=…`), then confirm rows in Supabase `ingested_emails` / `events`.

## Optional web app (“Check email now”)

Deploy → New deployment → Web app → Execute as **Me**, access **Anyone with link**. URL: `https://script.google.com/.../exec?key=<WEBAPP_SECRET>`.

## Local development

```bash
npm run typecheck
npm test          # offline; Gemini + Supabase mocked
npm run build     # dist/Code.js for clasp
```

Synthetic emails live under `test/fixtures/`. Do **not** call the live Gemini API from tests.

## Teardown

1. Run **`removeTrigger()`** in the script editor (or delete triggers in the UI).
2. Undeploy web app deployments.
3. Delete the Apps Script project.
4. Google Account → Security → Third-party access → remove script access.
5. Rotate/delete the Gemini key and Supabase service role if desired.

## Architecture notes

- **Idempotency**: Gmail message id + `Trip-Mexico/processed` label + deterministic event UUIDs (`uuid_v5(messageId:index)`).
- **Failures**: Rows in `ingested_emails` with `status='failed'` and `failure_reason`; raw body preserved (truncated to 200 KB).
- **Revisions**: Open `revision_requests` re-run Gemini with the user note; patches skip columns listed in `edited_fields` and never touch `notes`.
- **Attachments**: PDF/image/pkpass/ics uploaded to `trip-docs/<trip_id>/<sha256>.<ext>` when ≤ 50 MB; larger files skipped (use `gmail_link`); PDFs > 20 MB stored but not sent inline to Gemini.

See `SCHEMA_ASSUMPTIONS.md` for Postgres contract details that must match `supabase/` migrations.
