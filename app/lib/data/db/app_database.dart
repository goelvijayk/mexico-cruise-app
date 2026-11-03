import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  TripTable,
  Events,
  Attachments,
  IngestedEmails,
  RevisionRequests,
  SyncState,
  SyncOutbox,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.inMemory() : super(NativeDatabase.memory());

  static Future<AppDatabase> openDefault() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'mexico_cruise.sqlite'));
    return AppDatabase(NativeDatabase(file));
  }

  @override
  int get schemaVersion => 1;

  Future<String?> syncValue(String key) async {
    final row =
        await (select(syncState)..where((t) => t.key.equals(key)))
            .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSyncValue(String key, String value) async {
    await into(syncState).insertOnConflictUpdate(
      SyncStateCompanion.insert(key: key, value: value),
    );
  }

  Stream<List<Event>> watchActiveEvents() {
    return (select(events)
          ..where((e) => e.deletedAt.isNull())
          ..orderBy([
            (e) => OrderingTerm.asc(e.startLocal),
          ]))
        .watch();
  }

  Stream<List<Event>> watchEventsForDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return watchActiveEvents().map(
      (rows) => rows
          .where(
            (e) => eventSpansDay(
              startLocal: e.startLocal,
              endLocal: e.endLocal,
              day: d,
            ),
          )
          .toList()
        ..sort((a, b) {
          if (a.allDay != b.allDay) {
            return a.allDay ? -1 : 1;
          }
          return a.startLocal.compareTo(b.startLocal);
        }),
    );
  }

  Future<int> dirtyOutboxCount() async {
    final outbox = await select(syncOutbox).get();
    final dirtyEvents =
        await (select(events)..where((e) => e.dirty.equals(true))).get();
    final dirtyAttachments = await (select(attachments)
          ..where((a) => a.dirty.equals(true)))
        .get();
    final dirtyRevisions = await (select(revisionRequests)
          ..where((r) => r.dirty.equals(true)))
        .get();
    return outbox.length +
        dirtyEvents.length +
        dirtyAttachments.length +
        dirtyRevisions.length;
  }

  Future<bool> hasOpenRevisionForEvent(String eventId) async {
    final rows = await (select(revisionRequests)
          ..where((r) =>
              r.eventId.equals(eventId) &
              r.status.isIn(['open', 'needs_human', 'failed'])))
        .get();
    return rows.isNotEmpty;
  }
}
