import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:path/path.dart' as p;

typedef StorageBytesFetcher = Future<List<int>> Function(String storagePath);

class AttachmentDownloadResult {
  AttachmentDownloadResult({
    required this.downloaded,
    required this.failed,
    required this.bytesDownloaded,
  });

  final int downloaded;
  final int failed;
  final int bytesDownloaded;
}

class AttachmentDownloader {
  AttachmentDownloader({
    required AppDatabase db,
    required StorageBytesFetcher fetchBytes,
    required Directory docsDirectory,
    this.maxRetries = 3,
  })  : _db = db,
        _fetchBytes = fetchBytes,
        _docsDirectory = docsDirectory;

  final AppDatabase _db;
  final StorageBytesFetcher _fetchBytes;
  final Directory _docsDirectory;
  final int maxRetries;

  static String extensionFor(String fileName, String storagePath) {
    final fromName = p.extension(fileName);
    if (fromName.isNotEmpty) return fromName.replaceFirst('.', '');
    final fromPath = p.extension(storagePath);
    if (fromPath.isNotEmpty) return fromPath.replaceFirst('.', '');
    return 'bin';
  }

  static String sha256Hex(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }

  Future<File> localFileFor(String sha256, String ext) async {
    await _docsDirectory.create(recursive: true);
    return File(p.join(_docsDirectory.path, '$sha256.$ext'));
  }

  Future<AttachmentDownloadResult> downloadPending({
    void Function(int index, int total, int bytesSoFar)? onProgress,
  }) async {
    final pending = await (_db.select(_db.attachments)
          ..where(
            (a) =>
                a.deletedAt.isNull() &
                a.downloadState.isNotIn(['done', 'downloading']),
          )
          ..orderBy([(a) => OrderingTerm.asc(a.updatedAt)]))
        .get();

    var downloaded = 0;
    var failed = 0;
    var totalBytes = 0;

    for (var i = 0; i < pending.length; i++) {
      final att = pending[i];
      onProgress?.call(i + 1, pending.length, totalBytes);

      await (_db.update(_db.attachments)..where((a) => a.id.equals(att.id)))
          .write(
        const AttachmentsCompanion(
          downloadState: Value('downloading'),
          downloadError: Value(null),
        ),
      );

      List<int>? bytes;
      Object? lastError;
      for (var attempt = 0; attempt < maxRetries; attempt++) {
        try {
          bytes = await _fetchBytes(att.storagePath);
          break;
        } catch (e) {
          lastError = e;
          await Future<void>.delayed(Duration(milliseconds: 400 * (attempt + 1)));
        }
      }

      if (bytes == null) {
        failed++;
        await (_db.update(_db.attachments)..where((a) => a.id.equals(att.id)))
            .write(
          AttachmentsCompanion(
            downloadState: const Value('error'),
            downloadError: Value(lastError.toString()),
          ),
        );
        continue;
      }

      final digest = sha256Hex(bytes);
      if (digest != att.sha256) {
        failed++;
        await (_db.update(_db.attachments)..where((a) => a.id.equals(att.id)))
            .write(
          const AttachmentsCompanion(
            downloadState: Value('error'),
            downloadError: Value('sha256 mismatch'),
          ),
        );
        continue;
      }

      final ext = extensionFor(att.fileName, att.storagePath);
      final file = await localFileFor(att.sha256, ext);
      await file.writeAsBytes(bytes, flush: true);
      totalBytes += bytes.length;
      downloaded++;

      await (_db.update(_db.attachments)..where((a) => a.id.equals(att.id)))
          .write(
        AttachmentsCompanion(
          localPath: Value(file.path),
          downloadState: const Value('done'),
          downloadError: const Value(null),
        ),
      );
    }

    return AttachmentDownloadResult(
      downloaded: downloaded,
      failed: failed,
      bytesDownloaded: totalBytes,
    );
  }

  Future<void> upsertFromRemoteRow(Map<String, dynamic> map) async {
    final id = map['id'] as String;
    final local = await (_db.select(_db.attachments)
          ..where((a) => a.id.equals(id)))
        .getSingleOrNull();
    final remoteUpdated =
        DateTime.parse(map['updated_at'] as String).toUtc();
    if (local != null &&
        local.dirty &&
        local.updatedAt.toUtc().isAfter(remoteUpdated)) {
      return;
    }
    final existingPath =
        local?.downloadState == 'done' && local?.sha256 == map['sha256']
            ? local?.localPath
            : null;
    final downloadState = existingPath != null
        ? 'done'
        : (local?.sha256 == map['sha256'] ? (local?.downloadState ?? 'none') : 'none');
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
            deletedAt: Value(
              map['deleted_at'] == null
                  ? null
                  : DateTime.parse(map['deleted_at'] as String),
            ),
            localPath: Value(existingPath),
            downloadState: Value(downloadState),
            downloadError: Value(local?.downloadError),
            dirty: const Value(false),
          ),
        );
  }
}
