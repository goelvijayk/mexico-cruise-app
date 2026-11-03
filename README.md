# Mexico Cruise

Offline-first family trip itinerary for the Mexico cruise: Flutter on Android (Pixel), Supabase for shared sync and documents, optional Gmail ingestion (separate `ingestion/` PR).

## Layout

| Path | Purpose |
|------|---------|
| `app/` | Flutter + Riverpod + drift + supabase_flutter |
| `supabase/` | Postgres migrations, RLS, `apply_changes` / `apply_field_patches`, seed, runbooks |
| `ingestion/` | Gmail → Gemini → Supabase (Apps Script); see ingestion PR |

Product spec: Project docs `prd-final.md` (in Cursor Project Context).

## Quick start (local demo, no backend)

```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Without `app/.env`, the app seeds sample events and skips sign-in.

## Configure Supabase

Copy `app/.env.example` → `app/.env` (gitignored) or use:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY \
  --dart-define=SUPABASE_EMAIL=trip@example.com
```

## Windows PC setup (admin)

See **`supabase/README.md`**: Supabase CLI + Docker, `supabase db push`, Auth user, bucket `trip-docs`, then build APK with the dart-defines above. Ingestion: **`ingestion/SCHEMA_ASSUMPTIONS.md`**.

## Sync model

- **Refresh**: push outbox patches → `apply_field_patches`; pull rows with `updated_at > last_pulled_at`; download attachments (when online).
- **Field merge**: per-column LWW using `events.field_meta` (see `supabase/README.md`).
- **Ingestion**: row upsert via `apply_changes('events', …)`; never overwrites `notes` or `edited_fields` on conflict (`supabase/INGESTION_CONTRACT.md`).

## Verify

```bash
cd app && flutter analyze && flutter test
```

Build debug APK (requires Android SDK):

```bash
cd app && flutter build apk --debug
```
