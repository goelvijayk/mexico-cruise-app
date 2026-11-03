import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/db/tables.dart';
import 'package:mexico_cruise/domain/merge/field_merge.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class EventRepository {
  EventRepository(this._db);

  final AppDatabase _db;

  Future<void> queueFieldPatch({
    required String rowId,
    required String field,
    required Object? value,
    required DateTime updatedAt,
    required String updatedBy,
    String? tripId,
    Map<String, dynamic>? bootstrap,
  }) async {
    final patchId = _uuid.v4();
    await _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            patchId: patchId,
            rowId: rowId,
            field: field,
            valueJson: jsonEncode(
              FieldPatch(
                patchId: patchId,
                rowId: rowId,
                field: field,
                value: value,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
              ).toRpcJson()['value'],
            ),
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            tripId: Value(tripId),
            bootstrapJson: Value(bootstrap == null ? null : jsonEncode(bootstrap)),
          ),
        );
  }

  Future<void> saveEventFields({
    required String eventId,
    required Map<String, Object?> changedFields,
    required String updatedBy,
    required DateTime updatedAt,
    required String tripId,
    Map<String, dynamic>? bootstrap,
  }) async {
    for (final entry in changedFields.entries) {
      await queueFieldPatch(
        rowId: eventId,
        field: entry.key,
        value: entry.value,
        updatedAt: updatedAt,
        updatedBy: updatedBy,
        tripId: tripId,
        bootstrap: bootstrap,
      );
    }

    final existing = await (_db.select(_db.events)
          ..where((e) => e.id.equals(eventId)))
        .getSingleOrNull();

    final edited = existing == null
        ? <String>[]
        : decodeStringList(existing.editedFieldsJson);
    for (final f in changedFields.keys) {
      if (!edited.contains(f)) edited.add(f);
    }

    final companion = EventsCompanion(
      id: Value(eventId),
      tripId: Value(tripId),
      dirty: const Value(true),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      editedFieldsJson: Value(jsonEncode(edited)),
    );

    if (existing == null) {
      await _db.into(_db.events).insert(
            companion.copyWith(
              type: Value(bootstrap?['type'] as String? ?? 'other'),
              status: const Value('confirmed'),
              title: Value(bootstrap?['title'] as String? ?? 'New event'),
              startLocal: Value(
                DateTime.parse(
                  bootstrap?['start_local'] as String? ??
                      updatedAt.toIso8601String(),
                ),
              ),
              startTz: Value(
                bootstrap?['start_tz'] as String? ?? 'America/Los_Angeles',
              ),
              sourceJson: Value(
                jsonEncode(bootstrap?['source'] ?? {'kind': 'manual'}),
              ),
              createdAt: Value(updatedAt),
              createdBy: Value(updatedBy),
              fieldMetaJson: const Value('{}'),
            ),
          );
    } else {
      await (_db.update(_db.events)..where((e) => e.id.equals(eventId))).write(
        companion,
      );
    }

    // Apply locally immediately for responsive UI.
    for (final entry in changedFields.entries) {
      await _applyLocalColumn(eventId, entry.key, entry.value);
    }
  }

  Future<void> softDelete({
    required String eventId,
    required String updatedBy,
  }) async {
    final now = DateTime.now().toUtc();
    await saveEventFields(
      eventId: eventId,
      changedFields: {'deleted_at': now.toIso8601String()},
      updatedBy: updatedBy,
      updatedAt: now,
      tripId: await _tripIdForEvent(eventId),
    );
    await (_db.update(_db.events)..where((e) => e.id.equals(eventId))).write(
      EventsCompanion(deletedAt: Value(now), dirty: const Value(true)),
    );
  }

  Future<String> _tripIdForEvent(String eventId) async {
    final row = await (_db.select(_db.events)
          ..where((e) => e.id.equals(eventId)))
        .getSingleOrNull();
    return row?.tripId ?? 'mex-2026-12';
  }

  Future<void> _applyLocalColumn(
    String eventId,
    String field,
    Object? value,
  ) async {
    switch (field) {
      case 'title':
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(EventsCompanion(title: Value(value as String)));
      case 'notes':
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(EventsCompanion(notes: Value(value as String?)));
      case 'booking_ref':
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(EventsCompanion(bookingRef: Value(value as String?)));
      case 'provider':
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(EventsCompanion(provider: Value(value as String?)));
      case 'location':
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(EventsCompanion(
                locationJson: Value(jsonEncode(value))));
      case 'details':
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(
                EventsCompanion(detailsJson: Value(jsonEncode(value))));
      case 'deleted_at':
        final dt = value == null
            ? null
            : DateTime.tryParse(value.toString());
        await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
            .write(EventsCompanion(deletedAt: Value(dt)));
      default:
        break;
    }
  }
}
