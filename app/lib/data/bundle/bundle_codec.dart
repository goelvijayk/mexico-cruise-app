import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:path/path.dart' as p;

class BundleManifest {
  BundleManifest({
    required this.version,
    required this.exportedAt,
    required this.tripId,
    required this.counts,
  });

  final int version;
  final String exportedAt;
  final String tripId;
  final Map<String, int> counts;

  Map<String, dynamic> toJson() => {
        'version': version,
        'exported_at': exportedAt,
        'trip_id': tripId,
        'counts': counts,
      };

  factory BundleManifest.fromJson(Map<String, dynamic> json) {
    return BundleManifest(
      version: json['version'] as int? ?? 1,
      exportedAt: json['exported_at'] as String,
      tripId: json['trip_id'] as String,
      counts: Map<String, int>.from(
        (json['counts'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      ),
    );
  }
}

class BundleExportResult {
  BundleExportResult({
    required this.file,
    required this.manifest,
  });

  final File file;
  final BundleManifest manifest;
}

class BundleImportResult {
  BundleImportResult({
    required this.eventsMerged,
    required this.attachmentsMerged,
    required this.emailsMerged,
    required this.revisionsMerged,
    required this.documentsCopied,
  });

  final int eventsMerged;
  final int attachmentsMerged;
  final int emailsMerged;
  final int revisionsMerged;
  final int documentsCopied;

  String get summary =>
      '$eventsMerged events, $attachmentsMerged documents, '
      '$emailsMerged emails, $revisionsMerged revisions merged';
}

List<int> encodeBundleArchive(Map<String, dynamic> files) {
  final archive = Archive();
  files.forEach((name, content) {
    if (content is List<int>) {
      archive.addFile(ArchiveFile(name, content.length, content));
    } else if (content is String) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }
  });
  return ZipEncoder().encode(archive);
}

Map<String, List<int>> decodeBundleArchive(List<int> zipBytes) {
  final archive = ZipDecoder().decodeBytes(zipBytes);
  final out = <String, List<int>>{};
  for (final file in archive.files) {
    if (file.isFile) {
      out[file.name] = file.content as List<int>;
    }
  }
  return out;
}

String jsonString(Object value) =>
    const JsonEncoder.withIndent('  ').convert(value);

Map<String, dynamic> eventToMap(Event e) => {
      'id': e.id,
      'trip_id': e.tripId,
      'type': e.type,
      'status': e.status,
      'title': e.title,
      'start_local': e.startLocal.toIso8601String(),
      'start_tz': e.startTz,
      'end_local': e.endLocal?.toIso8601String(),
      'end_tz': e.endTz,
      'all_day': e.allDay,
      'location': e.locationJson == null ? null : jsonDecode(e.locationJson!),
      'provider': e.provider,
      'booking_ref': e.bookingRef,
      'details': e.detailsJson == null ? null : jsonDecode(e.detailsJson!),
      'travelers':
          e.travelersJson == null ? null : jsonDecode(e.travelersJson!),
      'cost': e.costJson == null ? null : jsonDecode(e.costJson!),
      'notes': e.notes,
      'source': jsonDecode(e.sourceJson),
      'review_state': e.reviewState,
      'edited_fields': jsonDecode(e.editedFieldsJson),
      'field_meta': jsonDecode(e.fieldMetaJson),
      'created_at': e.createdAt.toUtc().toIso8601String(),
      'created_by': e.createdBy,
      'updated_at': e.updatedAt.toUtc().toIso8601String(),
      'updated_by': e.updatedBy,
      'deleted_at': e.deletedAt?.toUtc().toIso8601String(),
    };

Map<String, dynamic> attachmentToMap(Attachment a) => {
      'id': a.id,
      'trip_id': a.tripId,
      'event_id': a.eventId,
      'kind': a.kind,
      'file_name': a.fileName,
      'mime_type': a.mimeType,
      'size_bytes': a.sizeBytes,
      'sha256': a.sha256,
      'storage_path': a.storagePath,
      'page_count': a.pageCount,
      'source': jsonDecode(a.sourceJson),
      'created_at': a.createdAt.toUtc().toIso8601String(),
      'created_by': a.createdBy,
      'updated_at': a.updatedAt.toUtc().toIso8601String(),
      'updated_by': a.updatedBy,
      'deleted_at': a.deletedAt?.toUtc().toIso8601String(),
      'bundle_doc_path': a.localPath == null
          ? null
          : 'docs/${a.sha256}.${p.extension(a.fileName).replaceFirst('.', '')}',
    };

Map<String, dynamic> ingestedEmailToMap(IngestedEmail e) => {
      'gmail_message_id': e.gmailMessageId,
      'trip_id': e.tripId,
      'thread_id': e.threadId,
      'from_addr': e.fromAddr,
      'subject': e.subject,
      'received_at': e.receivedAt.toUtc().toIso8601String(),
      'snippet': e.snippet,
      'body_text': e.bodyText,
      'gmail_link': e.gmailLink,
      'status': e.status,
      'failure_reason': e.failureReason,
      'event_ids': jsonDecode(e.eventIdsJson),
      'attachment_count': e.attachmentCount,
      'reparse_requested': e.reparseRequested,
      'reparse_note': e.reparseNote,
      'handled_by': e.handledBy,
      'handled_at': e.handledAt?.toUtc().toIso8601String(),
      'updated_at': e.updatedAt.toUtc().toIso8601String(),
      'deleted_at': e.deletedAt?.toUtc().toIso8601String(),
    };

Map<String, dynamic> revisionToMap(RevisionRequest r) => {
      'id': r.id,
      'event_id': r.eventId,
      'note': r.note,
      'requested_by': r.requestedBy,
      'requested_at': r.requestedAt.toUtc().toIso8601String(),
      'status': r.status,
      'result_note': r.resultNote,
      'diff': r.diffJson == null ? null : jsonDecode(r.diffJson!),
      'applied_at': r.appliedAt?.toUtc().toIso8601String(),
      'updated_at': r.updatedAt.toUtc().toIso8601String(),
    };

Map<String, dynamic> tripToMap(TripTableData t) => {
      'id': t.id,
      'name': t.name,
      'start_date': t.startDate.toIso8601String().split('T').first,
      'end_date': t.endDate.toIso8601String().split('T').first,
      'ship_time_zone': t.shipTimeZone,
      'home_time_zone': t.homeTimeZone,
      'default_currency': t.defaultCurrency,
      'updated_at': t.updatedAt.toUtc().toIso8601String(),
    };
