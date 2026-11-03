import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/sync/attachment_downloader.dart';

void main() {
  test('downloads missing attachment, verifies sha256, marks done', () async {
    final db = AppDatabase.inMemory();
    final docsDir = Directory.systemTemp.createTempSync('mexico_docs_test');
    addTearDown(() {
      docsDir.deleteSync(recursive: true);
      db.close();
    });

    const payload = 'fake pdf payload for cruise ticket';
    final bytes = utf8.encode(payload);
    final digest = AttachmentDownloader.sha256Hex(bytes);

    const attId = 'c1000000-0000-4000-8000-000000000099';
    final now = DateTime.utc(2026, 11, 1);
    await db.into(db.attachments).insert(
          AttachmentsCompanion.insert(
            id: attId,
            tripId: 'mex-2026-12',
            eventId: const Value(null),
            fileName: 'boarding.pdf',
            mimeType: 'application/pdf',
            sizeBytes: bytes.length,
            sha256: digest,
            storagePath: 'mex-2026-12/$digest.pdf',
            sourceJson: jsonEncode({'kind': 'manual'}),
            createdAt: now,
            createdBy: 'test',
            updatedAt: now,
            updatedBy: 'test',
            downloadState: const Value('none'),
          ),
        );

    var fetchCount = 0;
    final downloader = AttachmentDownloader(
      db: db,
      docsDirectory: docsDir,
      fetchBytes: (_) async {
        fetchCount++;
        return bytes;
      },
    );

    final result = await downloader.downloadPending();
    expect(result.downloaded, 1);
    expect(result.failed, 0);
    expect(fetchCount, 1);

    final row = await (db.select(db.attachments)
          ..where((a) => a.id.equals(attId)))
        .getSingle();
    expect(row.downloadState, 'done');
    expect(row.localPath, isNotNull);
    expect(File(row.localPath!).existsSync(), isTrue);
    expect(
      AttachmentDownloader.sha256Hex(await File(row.localPath!).readAsBytes()),
      digest,
    );
  });

  test('marks error when sha256 mismatch', () async {
    final db = AppDatabase.inMemory();
    final docsDir = Directory.systemTemp.createTempSync('mexico_docs_bad');
    addTearDown(() {
      docsDir.deleteSync(recursive: true);
      db.close();
    });

    const attId = 'c1000000-0000-4000-8000-000000000098';
    final now = DateTime.utc(2026, 11, 1);
    await db.into(db.attachments).insert(
          AttachmentsCompanion.insert(
            id: attId,
            tripId: 'mex-2026-12',
            fileName: 'bad.pdf',
            mimeType: 'application/pdf',
            sizeBytes: 10,
            sha256: 'expected_hash_not_matching',
            storagePath: 'mex-2026-12/expected_hash_not_matching.pdf',
            sourceJson: jsonEncode({'kind': 'manual'}),
            createdAt: now,
            createdBy: 'test',
            updatedAt: now,
            updatedBy: 'test',
          ),
        );

    final downloader = AttachmentDownloader(
      db: db,
      docsDirectory: docsDir,
      fetchBytes: (_) async => utf8.encode('wrong bytes'),
      maxRetries: 1,
    );

    final result = await downloader.downloadPending();
    expect(result.downloaded, 0);
    expect(result.failed, 1);

    final row = await (db.select(db.attachments)
          ..where((a) => a.id.equals(attId)))
        .getSingle();
    expect(row.downloadState, 'error');
    expect(row.downloadError, contains('sha256'));
  });
}
