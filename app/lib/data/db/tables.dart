import 'dart:convert';

import 'package:drift/drift.dart';

class TripTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime().named('start_date')();
  DateTimeColumn get endDate => dateTime().named('end_date')();
  TextColumn get shipTimeZone => text().named('ship_time_zone')();
  TextColumn get homeTimeZone => text().named('home_time_zone')();
  TextColumn get defaultCurrency =>
      text().named('default_currency').withDefault(const Constant('USD'))();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Events extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().named('trip_id')();
  TextColumn get type => text()();
  TextColumn get status => text().withDefault(const Constant('confirmed'))();
  TextColumn get title => text()();
  DateTimeColumn get startLocal => dateTime().named('start_local')();
  TextColumn get startTz => text().named('start_tz')();
  DateTimeColumn get endLocal => dateTime().nullable().named('end_local')();
  TextColumn get endTz => text().nullable().named('end_tz')();
  BoolColumn get allDay =>
      boolean().named('all_day').withDefault(const Constant(false))();
  TextColumn get locationJson => text().nullable().named('location')();
  TextColumn get provider => text().nullable()();
  TextColumn get bookingRef => text().nullable().named('booking_ref')();
  TextColumn get detailsJson => text().nullable().named('details')();
  TextColumn get travelersJson => text().nullable().named('travelers')();
  TextColumn get costJson => text().nullable().named('cost')();
  TextColumn get notes => text().nullable()();
  TextColumn get sourceJson => text().named('source')();
  TextColumn get reviewState =>
      text().named('review_state').withDefault(const Constant('none'))();
  TextColumn get editedFieldsJson =>
      text().named('edited_fields').withDefault(const Constant('[]'))();
  TextColumn get fieldMetaJson =>
      text().named('field_meta').withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  TextColumn get updatedBy => text().named('updated_by')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().named('trip_id')();
  TextColumn get eventId => text().nullable().named('event_id')();
  TextColumn get kind =>
      text().withDefault(const Constant('document'))();
  TextColumn get fileName => text().named('file_name')();
  TextColumn get mimeType => text().named('mime_type')();
  IntColumn get sizeBytes => integer().named('size_bytes')();
  TextColumn get sha256 => text()();
  TextColumn get storagePath => text().named('storage_path')();
  IntColumn get pageCount => integer().nullable().named('page_count')();
  TextColumn get sourceJson => text().named('source')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  TextColumn get updatedBy => text().named('updated_by')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  TextColumn get localPath => text().nullable().named('local_path')();
  TextColumn get downloadState => text()
      .named('download_state')
      .withDefault(const Constant('none'))();
  TextColumn get downloadError =>
      text().nullable().named('download_error')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class IngestedEmails extends Table {
  TextColumn get gmailMessageId =>
      text().named('gmail_message_id')();
  TextColumn get tripId => text().named('trip_id')();
  TextColumn get threadId => text().named('thread_id')();
  TextColumn get fromAddr => text().named('from_addr')();
  TextColumn get subject => text()();
  DateTimeColumn get receivedAt => dateTime().named('received_at')();
  TextColumn get snippet => text()();
  TextColumn get bodyText => text().named('body_text')();
  TextColumn get gmailLink => text().named('gmail_link')();
  TextColumn get status => text()();
  TextColumn get failureReason =>
      text().nullable().named('failure_reason')();
  TextColumn get eventIdsJson =>
      text().named('event_ids').withDefault(const Constant('[]'))();
  IntColumn get attachmentCount =>
      integer().named('attachment_count').withDefault(const Constant(0))();
  BoolColumn get reparseRequested =>
      boolean().named('reparse_requested').withDefault(const Constant(false))();
  TextColumn get reparseNote => text().nullable().named('reparse_note')();
  TextColumn get handledBy => text().nullable().named('handled_by')();
  DateTimeColumn get handledAt => dateTime().nullable().named('handled_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {gmailMessageId};
}

class RevisionRequests extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().named('event_id')();
  TextColumn get note => text()();
  TextColumn get requestedBy => text().named('requested_by')();
  DateTimeColumn get requestedAt => dateTime().named('requested_at')();
  TextColumn get status =>
      text().withDefault(const Constant('open'))();
  TextColumn get resultNote => text().nullable().named('result_note')();
  TextColumn get diffJson => text().nullable().named('diff')();
  DateTimeColumn get appliedAt => dateTime().nullable().named('applied_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SyncState extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class SyncOutbox extends Table {
  TextColumn get patchId => text().named('patch_id')();
  TextColumn get rowId => text().named('row_id')();
  TextColumn get field => text()();
  TextColumn get valueJson => text().named('value_json')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  TextColumn get updatedBy => text().named('updated_by')();
  TextColumn get tripId => text().nullable().named('trip_id')();
  TextColumn get bootstrapJson => text().nullable().named('bootstrap_json')();

  @override
  Set<Column<Object>> get primaryKey => {patchId};
}

List<String> decodeStringList(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw);
  if (decoded is List) {
    return decoded.map((e) => e.toString()).toList();
  }
  return [];
}

Map<String, dynamic> decodeMap(String? raw) {
  if (raw == null || raw.isEmpty) return {};
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) return decoded;
  if (decoded is Map) return Map<String, dynamic>.from(decoded);
  return {};
}

DateTime? startDay(DateTime startLocal) =>
    DateTime(startLocal.year, startLocal.month, startLocal.day);

DateTime endDay(DateTime startLocal, DateTime? endLocal) {
  final end = endLocal ?? startLocal;
  return DateTime(end.year, end.month, end.day);
}

bool eventSpansDay({
  required DateTime startLocal,
  required DateTime? endLocal,
  required DateTime day,
}) {
  final start = startDay(startLocal)!;
  final end = endDay(startLocal, endLocal);
  final d = DateTime(day.year, day.month, day.day);
  return !d.isBefore(start) && !d.isAfter(end);
}
