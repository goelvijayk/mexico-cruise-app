import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mexico_cruise/data/bundle/bundle_codec.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/sync/attachment_downloader.dart';
import 'package:mexico_cruise/domain/merge/bundle_merge.dart';
import 'package:path/path.dart' as p;

class BundleService {
  BundleService({
    required AppDatabase db,
    required Directory docsDirectory,
    required Directory exportDirectory,
  })  : _db = db,
        _docsDirectory = docsDirectory,
        _exportDirectory = exportDirectory;

  final AppDatabase _db;
  final Directory _docsDirectory;
  final Directory _exportDirectory;

  Future<BundleExportResult> exportBundle({
    bool includeDocuments = true,
  }) async {
    await _exportDirectory.create(recursive: true);

    final trip = await _db.select(_db.tripTable).getSingleOrNull();
    final tripId = trip?.id ?? 'mex-2026-12';
    final events = await _db.select(_db.events).get();
    final attachments = await (_db.select(_db.attachments)
          ..where((a) => a.deletedAt.isNull()))
        .get();
    final emails = await (_db.select(_db.ingestedEmails)
          ..where((e) => e.deletedAt.isNull()))
        .get();
    final revisions = await _db.select(_db.revisionRequests).get();

    final files = <String, dynamic>{};
    final docCount = <String, List<int>>{};

    if (includeDocuments) {
      for (final att in attachments) {
        if (att.downloadState != 'done' ||
            att.localPath == null ||
            att.localPath!.isEmpty) {
          continue;
        }
        final local = File(att.localPath!);
        if (!local.existsSync()) continue;
        final ext = AttachmentDownloader.extensionFor(
          att.fileName,
          att.storagePath,
        );
        final zipPath = 'docs/${att.sha256}.$ext';
        docCount[zipPath] = await local.readAsBytes();
      }
    }

    files.addAll(docCount);
    files['manifest.json'] = jsonString(
      BundleManifest(
        version: 1,
        exportedAt: DateTime.now().toUtc().toIso8601String(),
        tripId: tripId,
        counts: {
          'events': events.where((e) => e.deletedAt == null).length,
          'attachments': attachments.length,
          'ingested_emails': emails.length,
          'revision_requests': revisions.length,
          'docs': docCount.length,
        },
      ).toJson(),
    );
    if (trip != null) {
      files['trip.json'] = jsonString(tripToMap(trip));
    }
    files['events.json'] = jsonString(events.map(eventToMap).toList());
    files['attachments.json'] =
        jsonString(attachments.map(attachmentToMap).toList());
    files['ingested_emails.json'] =
        jsonString(emails.map(ingestedEmailToMap).toList());
    files['revision_requests.json'] =
        jsonString(revisions.map(revisionToMap).toList());

    final zipBytes = encodeBundleArchive(files);
    final dateLabel =
        trip?.startDate.toIso8601String().split('T').first ??
            DateTime.now().toIso8601String().split('T').first;
    final outFile = File(
      p.join(_exportDirectory.path, 'trip-$dateLabel.cruisebundle'),
    );
    await outFile.writeAsBytes(zipBytes, flush: true);

    return BundleExportResult(
      file: outFile,
      manifest: BundleManifest.fromJson(
        jsonDecode(files['manifest.json'] as String) as Map<String, dynamic>,
      ),
    );
  }

  Future<BundleImportResult> importBundleBytes(List<int> zipBytes) async {
    final files = decodeBundleArchive(zipBytes);
    final manifest = BundleManifest.fromJson(
      jsonDecode(utf8.decode(files['manifest.json']!)) as Map<String, dynamic>,
    );
    if (manifest.version != 1) {
      throw FormatException('Unsupported bundle version ${manifest.version}');
    }

    var eventsMerged = 0;
    var attachmentsMerged = 0;
    var emailsMerged = 0;
    var revisionsMerged = 0;
    var documentsCopied = 0;

    if (files.containsKey('trip.json')) {
      final tripMap =
          jsonDecode(utf8.decode(files['trip.json']!)) as Map<String, dynamic>;
      await _db.into(_db.tripTable).insertOnConflictUpdate(
            TripTableCompanion.insert(
              id: tripMap['id'] as String,
              name: tripMap['name'] as String,
              startDate: DateTime.parse(tripMap['start_date'] as String),
              endDate: DateTime.parse(tripMap['end_date'] as String),
              shipTimeZone: tripMap['ship_time_zone'] as String,
              homeTimeZone: tripMap['home_time_zone'] as String,
              defaultCurrency: Value(
                (tripMap['default_currency'] as String?) ?? 'USD',
              ),
              updatedAt: DateTime.parse(tripMap['updated_at'] as String),
            ),
          );
    }

    final events =
        (jsonDecode(utf8.decode(files['events.json']!)) as List<dynamic>)
            .cast<Map<String, dynamic>>();
    for (final map in events) {
      if (await _mergeEvent(map)) eventsMerged++;
    }

    final attachments = files.containsKey('attachments.json')
        ? (jsonDecode(utf8.decode(files['attachments.json']!)) as List<dynamic>)
            .cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    for (final map in attachments) {
      if (await _mergeAttachment(map)) attachmentsMerged++;
    }

    if (files.containsKey('ingested_emails.json')) {
      final rows =
          (jsonDecode(utf8.decode(files['ingested_emails.json']!)) as List)
              .cast<Map<String, dynamic>>();
      for (final map in rows) {
        if (await _mergeIngestedEmail(map)) emailsMerged++;
      }
    }

    if (files.containsKey('revision_requests.json')) {
      final rows =
          (jsonDecode(utf8.decode(files['revision_requests.json']!)) as List)
              .cast<Map<String, dynamic>>();
      for (final map in rows) {
        if (await _mergeRevision(map)) revisionsMerged++;
      }
    }

    await _docsDirectory.create(recursive: true);
    for (final entry in files.entries) {
      if (!entry.key.startsWith('docs/')) continue;
      final shaFile = p.basename(entry.key);
      final dest = File(p.join(_docsDirectory.path, shaFile));
      await dest.writeAsBytes(entry.value, flush: true);
      documentsCopied++;

      final sha = shaFile.split('.').first;
      await (_db.update(_db.attachments)..where((a) => a.sha256.equals(sha)))
          .write(
        AttachmentsCompanion(
          localPath: Value(dest.path),
          downloadState: const Value('done'),
          downloadError: const Value(null),
          dirty: const Value(false),
        ),
      );
    }

    return BundleImportResult(
      eventsMerged: eventsMerged,
      attachmentsMerged: attachmentsMerged,
      emailsMerged: emailsMerged,
      revisionsMerged: revisionsMerged,
      documentsCopied: documentsCopied,
    );
  }

  Future<BundleImportResult> importBundleFile(File file) async {
    return importBundleBytes(await file.readAsBytes());
  }

  Future<bool> _mergeEvent(Map<String, dynamic> map) async {
    final id = map['id'] as String;
    final remoteUpdated = DateTime.parse(map['updated_at'] as String);
    final local = await (_db.select(_db.events)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    if (local != null &&
        !shouldApplyRemoteBundleRow(
          remoteUpdatedAt: remoteUpdated,
          localUpdatedAt: local.updatedAt,
          localDirty: local.dirty,
        )) {
      return false;
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
            locationJson: Value(
                map['location'] == null ? null : jsonEncode(map['location'])),
            provider: Value(map['provider'] as String?),
            bookingRef: Value(map['booking_ref'] as String?),
            detailsJson: Value(
                map['details'] == null ? null : jsonEncode(map['details'])),
            travelersJson: Value(map['travelers'] == null
                ? null
                : jsonEncode(map['travelers'])),
            costJson:
                Value(map['cost'] == null ? null : jsonEncode(map['cost'])),
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
    return true;
  }

  Future<bool> _mergeAttachment(Map<String, dynamic> map) async {
    final id = map['id'] as String;
    final remoteUpdated = DateTime.parse(map['updated_at'] as String);
    final local =
        await (_db.select(_db.attachments)..where((a) => a.id.equals(id)))
            .getSingleOrNull();
    if (local != null &&
        !shouldApplyRemoteBundleRow(
          remoteUpdatedAt: remoteUpdated,
          localUpdatedAt: local.updatedAt,
          localDirty: local.dirty,
        )) {
      return false;
    }

    await _db.into(_db.attachments).insertOnConflictUpdate(
          AttachmentsCompanion.insert(
            id: id,
            tripId: map['trip_id'] as String,
            eventId: Value(map['event_id'] as String?),
            kind: Value(map['kind'] as String? ?? 'document'),
            fileName: map['file_name'] as String,
            mimeType: map['mime_type'] as String,
            sizeBytes: (map['size_bytes'] as num).toInt(),
            sha256: map['sha256'] as String,
            storagePath: map['storage_path'] as String,
            pageCount: Value(map['page_count'] as int?),
            sourceJson: jsonEncode(map['source'] ?? {}),
            createdAt: DateTime.parse(map['created_at'] as String),
            createdBy: map['created_by'] as String,
            updatedAt: remoteUpdated,
            updatedBy: map['updated_by'] as String,
            deletedAt: Value(map['deleted_at'] == null
                ? null
                : DateTime.parse(map['deleted_at'] as String)),
            downloadState: const Value('none'),
            dirty: const Value(false),
          ),
        );
    return true;
  }

  Future<bool> _mergeIngestedEmail(Map<String, dynamic> map) async {
    final id = map['gmail_message_id'] as String;
    final remoteUpdated = DateTime.parse(map['updated_at'] as String);
    final local = await (_db.select(_db.ingestedEmails)
          ..where((e) => e.gmailMessageId.equals(id)))
        .getSingleOrNull();
    if (local != null &&
        !shouldApplyRemoteBundleRow(
          remoteUpdatedAt: remoteUpdated,
          localUpdatedAt: local.updatedAt,
          localDirty: local.dirty,
        )) {
      return false;
    }

    await _db.into(_db.ingestedEmails).insertOnConflictUpdate(
          IngestedEmailsCompanion.insert(
            gmailMessageId: id,
            tripId: map['trip_id'] as String,
            threadId: map['thread_id'] as String,
            fromAddr: map['from_addr'] as String,
            subject: map['subject'] as String,
            receivedAt: DateTime.parse(map['received_at'] as String),
            snippet: map['snippet'] as String,
            bodyText: map['body_text'] as String,
            gmailLink: map['gmail_link'] as String,
            status: map['status'] as String,
            failureReason: Value(map['failure_reason'] as String?),
            eventIdsJson: Value(jsonEncode(map['event_ids'] ?? [])),
            attachmentCount: Value((map['attachment_count'] as num?)?.toInt() ?? 0),
            reparseRequested: Value(map['reparse_requested'] as bool? ?? false),
            reparseNote: Value(map['reparse_note'] as String?),
            handledBy: Value(map['handled_by'] as String?),
            handledAt: Value(map['handled_at'] == null
                ? null
                : DateTime.parse(map['handled_at'] as String)),
            updatedAt: remoteUpdated,
            deletedAt: Value(map['deleted_at'] == null
                ? null
                : DateTime.parse(map['deleted_at'] as String)),
            dirty: const Value(false),
          ),
        );
    return true;
  }

  Future<bool> _mergeRevision(Map<String, dynamic> map) async {
    final id = map['id'] as String;
    final remoteUpdated = DateTime.parse(map['updated_at'] as String);
    final local = await (_db.select(_db.revisionRequests)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    if (local != null &&
        !shouldApplyRemoteBundleRow(
          remoteUpdatedAt: remoteUpdated,
          localUpdatedAt: local.updatedAt,
          localDirty: local.dirty,
        )) {
      return false;
    }

    await _db.into(_db.revisionRequests).insertOnConflictUpdate(
          RevisionRequestsCompanion.insert(
            id: id,
            eventId: map['event_id'] as String,
            note: map['note'] as String,
            requestedBy: map['requested_by'] as String,
            requestedAt: DateTime.parse(map['requested_at'] as String),
            status: Value(map['status'] as String? ?? 'open'),
            resultNote: Value(map['result_note'] as String?),
            diffJson: Value(
                map['diff'] == null ? null : jsonEncode(map['diff'])),
            appliedAt: Value(map['applied_at'] == null
                ? null
                : DateTime.parse(map['applied_at'] as String)),
            updatedAt: remoteUpdated,
            dirty: const Value(false),
          ),
        );
    return true;
  }
}
