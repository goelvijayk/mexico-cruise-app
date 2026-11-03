# Mexico Cruise (Flutter)

Android itinerary app: drift SQLite offline, manual Refresh to Supabase.

See repo root `README.md` and `../supabase/README.md`.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Debug APK (set `ANDROID_HOME` to your SDK, e.g. `/workspace/android-sdk` in Cloud Agent):

```bash
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk
```

`.cruisebundle` share/import is covered by `test/bundle_service_test.dart` and `test/bundle_merge_test.dart` (no device required).
