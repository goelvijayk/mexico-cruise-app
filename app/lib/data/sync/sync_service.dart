import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/domain/merge/field_merge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RefreshSummary {
  RefreshSummary({
    required this.eventsUpdated,
    required this.patchesAccepted,
    required this.patchesRejected,
    required this.attachmentsDownloaded,
    required this.message,
  });

  final int eventsUpdated;
  final int patchesAccepted;
  final int patchesRejected;
  final int attachmentsDownloaded;
  final String message;
}

class SyncService {
  SyncService({
    required AppDatabase db,
    required AppConfig config,
    SupabaseClient? client,
  })  : _db = db,
        _config = config,
        _client = client;

  final AppDatabase _db;
  final AppConfig _config;
  final SupabaseClient? _client;

  Future<RefreshSummary> refresh({required String deviceNickname}) async {
    if (!_config.hasBackend || _client == null) {
      final summary = RefreshSummary(
        eventsUpdated: 0,
        patchesAccepted: 0,
        patchesRejected: 0,
        attachmentsDownloaded: 0,
        message: 'Local-only mode (no Supabase configured)',
      );
      await _persistSummary(summary);
      return summary;
    }

    try {
      await _client.auth.refreshSession();
    } catch (_) {
      throw Exception("You're offline");
    }

    final serverNow = await _client.rpc('server_time');
    final serverTime = DateTime.parse(serverNow as String);
    final skew = serverTime.difference(DateTime.now().toUtc()).abs();
    if (skew > const Duration(minutes: 5)) {
      await _db.setSyncValue('clock_skew_warning', 'true');
    } else {
      await _db.setSyncValue('clock_skew_warning', 'false');
    }

    final pullCursor = parseSyncCursor(await _db.syncValue('last_pulled_at'));

    final patches = await _db.select(_db.syncOutbox).get();
    patches.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    final payload = patches
        .map(
          (p) => {
            'patch_id': p.patchId,
            'row_id': p.rowId,
            'field': p.field,
            'value': jsonDecode(p.valueJson),
            'updated_at': p.updatedAt.toUtc().toIso8601String(),
            'updated_by': p.updatedBy,
            if (p.tripId != null) 'trip_id': p.tripId,
            if (p.bootstrapJson != null)
              ...jsonDecode(p.bootstrapJson!) as Map<String, dynamic>,
          },
        )
        .toList();

    var accepted = <String>[];
    var rejected = <String>[];
    if (payload.isNotEmpty) {
      final result = await _client.rpc(
        'apply_field_patches',
        params: {'patches': payload},
      ) as Map<String, dynamic>;
      accepted = (result['accepted'] as List?)?.cast<String>() ?? [];
      rejected = (result['rejected'] as List?)?.cast<String>() ?? [];
      for (final id in accepted) {
        await (_db.delete(_db.syncOutbox)
              ..where((o) => o.patchId.equals(id)))
            .go();
      }
    }

    final since =
        (pullCursor ?? DateTime.fromMillisecondsSinceEpoch(0)).toUtc();
    final remoteEvents = await _client
        .from('events')
        .select()
        .gt('updated_at', since.toIso8601String());

    var eventsUpdated = 0;
    for (final row in remoteEvents as List<dynamic>) {
      final map = Map<String, dynamic>.from(row as Map);
      final id = map['id'] as String;
      final local = await (_db.select(_db.events)..where((e) => e.id.equals(id)))
          .getSingleOrNull();
      final remoteUpdated =
          DateTime.parse(map['updated_at'] as String).toUtc();
      if (local != null &&
          shouldKeepLocalOnPull(
            localDirty: local.dirty,
            localUpdatedAt: local.updatedAt.toUtc(),
            remoteUpdatedAt: remoteUpdated,
          )) {
        continue;
      }
      await _db.into(_db.events).insertOnConflictUpdate(
            EventsCompanion.insert(
              id: id,
              tripId: map['trip_id'] as String,
              type: map['type'] as String,
              status: Value(map['status'] as String? ?? 'confirmed'),
              title: map['title'] as String,
              startLocal: DateTime.parse(map['start_local'] as String),
              startTz: map['start_tz'] as String,
              endLocal: Value(map['end_local'] == null
                  ? null
                  : DateTime.parse(map['end_local'] as String)),
              endTz: Value(map['end_tz'] as String?),
              allDay: Value(map['all_day'] as bool? ?? false),
              locationJson: Value(map['location'] == null
                  ? null
                  : jsonEncode(map['location'])),
              provider: Value(map['provider'] as String?),
              bookingRef: Value(map['booking_ref'] as String?),
              detailsJson: Value(
                  map['details'] == null ? null : jsonEncode(map['details'])),
              travelersJson: Value(map['travelers'] == null
                  ? null
                  : jsonEncode(map['travelers'])),
              costJson: Value(
                  map['cost'] == null ? null : jsonEncode(map['cost'])),
              notes: Value(map['notes'] as String?),
              sourceJson: jsonEncode(map['source']),
              reviewState: Value(map['review_state'] as String? ?? 'none'),
              editedFieldsJson: Value(jsonEncode(map['edited_fields'] ?? [])),
              fieldMetaJson: Value(jsonEncode(map['field_meta'] ?? {})),
              createdAt: DateTime.parse(map['created_at'] as String),
              createdBy: map['created_by'] as String,
              updatedAt: remoteUpdated,
              updatedBy: map['updated_by'] as String,
              deletedAt: Value(map['deleted_at'] == null
                  ? null
                  : DateTime.parse(map['deleted_at'] as String)),
              dirty: const Value(false),
            ),
          );
      eventsUpdated++;
    }

    await _db.setSyncValue('last_pulled_at', formatSyncCursor(serverTime));

    final summary = RefreshSummary(
      eventsUpdated: eventsUpdated,
      patchesAccepted: accepted.length,
      patchesRejected: rejected.length,
      attachmentsDownloaded: 0,
      message:
          '$eventsUpdated events updated · ${accepted.length} patches sent · ${rejected.length} rejected',
    );
    await _persistSummary(summary);
    return summary;
  }

  Future<void> _persistSummary(RefreshSummary summary) async {
    await _db.setSyncValue('last_refresh_at', DateTime.now().toUtc().toIso8601String());
    await _db.setSyncValue('last_refresh_summary', summary.message);
  }
}
