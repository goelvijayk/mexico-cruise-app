import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/data/bundle/bundle_codec.dart';
import 'package:mexico_cruise/data/bundle/bundle_service.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/local/seed_local.dart';
import 'package:mexico_cruise/data/sync/attachment_downloader.dart';

void main() {
  test('cruisebundle export/import round-trip preserves events and docs', () async {
    final dbA = AppDatabase.inMemory();
    final docsA = Directory.systemTemp.createTempSync('bundle_docs_a');
    final exportA = Directory.systemTemp.createTempSync('bundle_export_a');
    final docsB = Directory.systemTemp.createTempSync('bundle_docs_b');
    final exportB = Directory.systemTemp.createTempSync('bundle_export_b');

    addTearDown(() {
      dbA.close();
      docsA.deleteSync(recursive: true);
      exportA.deleteSync(recursive: true);
      docsB.deleteSync(recursive: true);
      exportB.deleteSync(recursive: true);
    });

    await seedLocalSampleData(dbA);
    const attId = 'd1000000-0000-4000-8000-000000000001';
    const payload = 'pdf-bytes-for-bundle-test';
    final bytes = utf8.encode(payload);
    final sha = AttachmentDownloader.sha256Hex(bytes);
    final docFile = File('${docsA.path}/$sha.pdf');
    await docFile.writeAsBytes(bytes);
    final now = DateTime.utc(2026, 11, 2);
    await dbA.into(dbA.attachments).insert(
          AttachmentsCompanion.insert(
            id: attId,
            tripId: 'mex-2026-12',
            eventId: const Value('b1000000-0000-4000-8000-000000000001'),
            fileName: 'ticket.pdf',
            mimeType: 'application/pdf',
            sizeBytes: bytes.length,
            sha256: sha,
            storagePath: 'mex-2026-12/$sha.pdf',
            sourceJson: jsonEncode({'kind': 'manual'}),
            createdAt: now,
            createdBy: 'test',
            updatedAt: now,
            updatedBy: 'test',
            localPath: Value(docFile.path),
            downloadState: const Value('done'),
          ),
        );

    final svcA = BundleService(
      db: dbA,
      docsDirectory: docsA,
      exportDirectory: exportA,
    );
    final exported = await svcA.exportBundle(includeDocuments: true);
    expect(exported.file.path.endsWith('.cruisebundle'), isTrue);

    final dbB = AppDatabase.inMemory();
    addTearDown(dbB.close);
    final svcB = BundleService(
      db: dbB,
      docsDirectory: docsB,
      exportDirectory: exportB,
    );
    final imported = await svcB.importBundleFile(exported.file);

    expect(imported.eventsMerged, greaterThan(0));
    expect(imported.documentsCopied, 1);

    final events = await dbB.select(dbB.events).get();
    expect(events.any((e) => e.title.contains('UA 1234')), isTrue);

    final att = await (dbB.select(dbB.attachments)
          ..where((a) => a.id.equals(attId)))
        .getSingle();
    expect(att.downloadState, 'done');
    expect(att.localPath, isNotNull);
    expect(File(att.localPath!).existsSync(), isTrue);
    expect(
      AttachmentDownloader.sha256Hex(await File(att.localPath!).readAsBytes()),
      sha,
    );
  });

  test('pack/unpack codec preserves manifest and events json', () {
    final zip = encodeBundleArchive({
      'manifest.json': jsonString({
        'version': 1,
        'exported_at': '2026-11-02T00:00:00Z',
        'trip_id': 'mex-2026-12',
        'counts': {'events': 1, 'docs': 0},
      }),
      'events.json': jsonString([
        {'id': 'e1', 'title': 'Test', 'updated_at': '2026-11-02T00:00:00Z'},
      ]),
    });
    final files = decodeBundleArchive(zip);
    expect(files.containsKey('manifest.json'), isTrue);
    expect(files.containsKey('events.json'), isTrue);
    final manifest = BundleManifest.fromJson(
      jsonDecode(utf8.decode(files['manifest.json']!)) as Map<String, dynamic>,
    );
    expect(manifest.tripId, 'mex-2026-12');
  });
}
