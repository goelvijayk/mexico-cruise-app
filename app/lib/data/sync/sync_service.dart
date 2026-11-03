import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/sync/attachment_downloader.dart';
import 'package:mexico_cruise/data/sync/refresh_progress.dart';
import 'package:mexico_cruise/domain/merge/field_merge.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RefreshSummary {
  RefreshSummary({
    required this.eventsUpdated,
    required this.patchesAccepted,
    required this.patchesRejected,
    required this.attachmentsDownloaded,
    required this.attachmentBytesDownloaded,
    required this.attachmentsFailed,
    required this.message,
  });

  final int eventsUpdated;
  final int patchesAccepted;
  final int patchesRejected;
  final int attachmentsDownloaded;
  final int attachmentBytesDownloaded;
  final int attachmentsFailed;
  final String message;
}

typedef ProgressCallback = void Function(RefreshProgress progress);

class SyncService {
  SyncService({
    required AppDatabase db,
    required AppConfig config,
    SupabaseClient? client,
    AttachmentDownloader Function(Directory docsDir, StorageBytesFetcher fetch)?
        attachmentDownloaderFactory,
  })  : _db = db,
        _config = config,
        _client = client,
        _attachmentDownloaderFactory = attachmentDownloaderFactory;

  final AppDatabase _db;
  final AppConfig _config;
  final SupabaseClient? _client;
  final AttachmentDownloader Function(Directory docsDir, StorageBytesFetcher fetch)?
      _attachmentDownloaderFactory;

  Future<RefreshSummary> refresh({
    required String deviceNickname,
    ProgressCallback? onProgress,
  }) async {
    if (!_config.hasBackend || _client == null) {
      final summary = RefreshSummary(
        eventsUpdated: 0,
        patchesAccepted: 0,
        patchesRejected: 0,
        attachmentsDownloaded: 0,
        attachmentBytesDownloaded: 0,
        attachmentsFailed: 0,
        message: 'Local-only mode (no Supabase configured)',
      );
      await _persistSummary(summary);
      return summary;
    }

    onProgress?.call(const RefreshProgress(phase: 'signing_in'));

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

    onProgress?.call(const RefreshProgress(
      phase: 'pushing',
      detail: 'Sending your changes',
    ));

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

    onProgress?.call(const RefreshProgress(
      phase: 'pulling',
      detail: 'Getting updates',
    ));

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

    final remoteAttachments = await _client
        .from('attachments')
        .select()
        .gt('updated_at', since.toIso8601String());

    final docsDir = await _docsDirectory();
    final client = _client;
    Future<List<int>> fetchBytes(String storagePath) =>
        client.storage.from('trip-docs').download(storagePath);
    final downloader = _attachmentDownloaderFactory?.call(docsDir, fetchBytes) ??
        AttachmentDownloader(
          db: _db,
          fetchBytes: fetchBytes,
          docsDirectory: docsDir,
        );

    for (final row in remoteAttachments as List<dynamic>) {
      await downloader.upsertFromRemoteRow(Map<String, dynamic>.from(row as Map));
    }

    await _db.setSyncValue('last_pulled_at', formatSyncCursor(serverTime));

    onProgress?.call(const RefreshProgress(
      phase: 'downloading',
      detail: 'Downloading documents',
      downloadIndex: 0,
      downloadTotal: 0,
    ));

    var attachmentBytes = 0;
    var attachmentsDownloaded = 0;
    var attachmentsFailed = 0;

    final downloadResult = await downloader.downloadPending(
      onProgress: (index, total, bytesSoFar) {
        attachmentBytes = bytesSoFar;
        onProgress?.call(RefreshProgress(
          phase: 'downloading',
          detail: 'Downloading documents $index/$total',
          downloadIndex: index,
          downloadTotal: total,
          bytesDownloaded: bytesSoFar,
        ));
      },
    );
    attachmentsDownloaded = downloadResult.downloaded;
    attachmentsFailed = downloadResult.failed;
    attachmentBytes = downloadResult.bytesDownloaded;

    final mb = (attachmentBytes / (1024 * 1024)).toStringAsFixed(0);
    final summary = RefreshSummary(
      eventsUpdated: eventsUpdated,
      patchesAccepted: accepted.length,
      patchesRejected: rejected.length,
      attachmentsDownloaded: attachmentsDownloaded,
      attachmentBytesDownloaded: attachmentBytes,
      attachmentsFailed: attachmentsFailed,
      message:
          '$eventsUpdated events · $attachmentsDownloaded docs ($mb MB) · '
          '${accepted.length} patches sent',
    );
    await _persistSummary(summary);
    return summary;
  }

  Future<Directory> _docsDirectory() async {
    final base = await getApplicationDocumentsDirectory();
    return Directory(p.join(base.path, 'docs'));
  }

  Future<void> _persistSummary(RefreshSummary summary) async {
    await _db.setSyncValue(
      'last_refresh_at',
      DateTime.now().toUtc().toIso8601String(),
    );
    await _db.setSyncValue('last_refresh_summary', summary.message);
  }
}
