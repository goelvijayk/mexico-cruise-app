import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/local/seed_local.dart';
import 'package:mexico_cruise/data/repositories/event_repository.dart';
import 'package:mexico_cruise/data/sync/refresh_progress.dart';
import 'package:mexico_cruise/data/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('Override appConfigProvider in main()');
});

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});

final supabaseClientProvider = Provider<SupabaseClient?>((ref) => null);

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(databaseProvider));
});

final refreshProgressProvider =
    StateProvider<RefreshProgress?>((ref) => null);

final syncServiceProvider = Provider<SyncService>((ref) {
  final config = ref.watch(appConfigProvider);
  return SyncService(
    db: ref.watch(databaseProvider),
    config: config,
    client: ref.watch(supabaseClientProvider),
  );
});

final bootstrapProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  await seedLocalSampleData(db);
});

final deviceNicknameProvider = StreamProvider<String>((ref) async* {
  final db = ref.watch(databaseProvider);
  while (true) {
    yield await db.syncValue('device_nickname') ?? 'Traveler';
    await Future<void>.delayed(const Duration(seconds: 1));
  }
});

final dirtyOutboxProvider = StreamProvider<int>((ref) async* {
  final db = ref.watch(databaseProvider);
  while (true) {
    yield await db.dirtyOutboxCount();
    await Future<void>.delayed(const Duration(seconds: 2));
  }
});

final refreshSummaryProvider = StreamProvider<String?>((ref) async* {
  final db = ref.watch(databaseProvider);
  while (true) {
    yield await db.syncValue('last_refresh_summary');
    await Future<void>.delayed(const Duration(seconds: 2));
  }
});

final tripProvider = StreamProvider<TripTableData?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.tripTable).watchSingleOrNull();
});

final selectedDayProvider = StateProvider<DateTime?>((ref) => null);

final displayTzModeProvider = StateProvider<String>((ref) => 'event_local');

final eventsForDayProvider =
    StreamProvider.family<List<Event>, DateTime?>((ref, day) {
  final db = ref.watch(databaseProvider);
  if (day == null) return db.watchActiveEvents();
  return db.watchEventsForDay(day);
});

final refreshControllerProvider =
    StateNotifierProvider<RefreshController, AsyncValue<RefreshSummary?>>(
  (ref) => RefreshController(ref),
);

class RefreshController extends StateNotifier<AsyncValue<RefreshSummary?>> {
  RefreshController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    _ref.read(refreshProgressProvider.notifier).state = null;
    try {
      final nickname =
          await _ref.read(databaseProvider).syncValue('device_nickname') ??
              'Traveler';
      final summary = await _ref.read(syncServiceProvider).refresh(
            deviceNickname: nickname,
            onProgress: (p) =>
                _ref.read(refreshProgressProvider.notifier).state = p,
          );
      _ref.read(refreshProgressProvider.notifier).state = null;
      state = AsyncValue.data(summary);
    } catch (e, st) {
      _ref.read(refreshProgressProvider.notifier).state = null;
      state = AsyncValue.error(e, st);
    }
  }
}

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  final v = await db.syncValue('onboarding_complete');
  return v == 'true';
});
