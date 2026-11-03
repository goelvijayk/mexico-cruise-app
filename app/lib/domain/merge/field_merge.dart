import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Pure merge helpers for field-level sync (mirrors server `apply_field_patches`).
class FieldPatch extends Equatable {
  const FieldPatch({
    required this.patchId,
    required this.rowId,
    required this.field,
    required this.value,
    required this.updatedAt,
    required this.updatedBy,
  });

  final String patchId;
  final String rowId;
  final String field;
  final Object? value;
  final DateTime updatedAt;
  final String updatedBy;

  Map<String, dynamic> toRpcJson() => {
        'patch_id': patchId,
        'row_id': rowId,
        'field': field,
        'value': _encodeValue(value),
        'updated_at': updatedAt.toUtc().toIso8601String(),
        'updated_by': updatedBy,
      };

  static Object? _encodeValue(Object? value) {
    if (value == null) return null;
    if (value is Map || value is List) return value;
    if (value is DateTime) return value.toIso8601String();
    if (value is bool || value is num) return value;
    return value.toString();
  }

  @override
  List<Object?> get props =>
      [patchId, rowId, field, value, updatedAt, updatedBy];
}

class FieldMetaEntry extends Equatable {
  const FieldMetaEntry({required this.updatedAt, required this.updatedBy});

  final DateTime updatedAt;
  final String updatedBy;

  factory FieldMetaEntry.fromJson(Map<String, dynamic> json) {
    return FieldMetaEntry(
      updatedAt: DateTime.parse(json['updated_at'] as String),
      updatedBy: json['updated_by'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'updated_at': updatedAt.toUtc().toIso8601String(),
        'updated_by': updatedBy,
      };

  @override
  List<Object?> get props => [updatedAt, updatedBy];
}

typedef FieldMetaMap = Map<String, FieldMetaEntry>;

FieldMetaMap parseFieldMeta(String? raw) {
  if (raw == null || raw.isEmpty) return {};
  final decoded = jsonDecode(raw);
  if (decoded is! Map) return {};
  final out = <String, FieldMetaEntry>{};
  decoded.forEach((key, value) {
    if (value is Map) {
      out[key.toString()] =
          FieldMetaEntry.fromJson(Map<String, dynamic>.from(value));
    }
  });
  return out;
}

String encodeFieldMeta(FieldMetaMap meta) {
  return jsonEncode(
    meta.map((k, v) => MapEntry(k, v.toJson())),
  );
}

enum PatchApplyResult { accepted, rejected }

PatchApplyResult shouldApplyPatch({
  required FieldMetaMap meta,
  required String field,
  required DateTime patchUpdatedAt,
}) {
  final existing = meta[field];
  if (existing == null) return PatchApplyResult.accepted;
  if (patchUpdatedAt.isBefore(existing.updatedAt)) {
    return PatchApplyResult.rejected;
  }
  return PatchApplyResult.accepted;
}

FieldMetaMap applyPatchToMeta({
  required FieldMetaMap meta,
  required FieldPatch patch,
}) {
  final next = Map<String, FieldMetaEntry>.from(meta);
  next[patch.field] = FieldMetaEntry(
    updatedAt: patch.updatedAt,
    updatedBy: patch.updatedBy,
  );
  return next;
}

/// Apply ordered patches to a flat string map of column values.
Map<String, String?> mergeEventFields({
  required Map<String, String?> base,
  required FieldMetaMap baseMeta,
  required List<FieldPatch> patches,
}) {
  var values = Map<String, String?>.from(base);
  var meta = Map<String, FieldMetaEntry>.from(baseMeta);

  final sorted = [...patches]
    ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

  for (final patch in sorted) {
    if (shouldApplyPatch(
          meta: meta,
          field: patch.field,
          patchUpdatedAt: patch.updatedAt,
        ) ==
        PatchApplyResult.rejected) {
      continue;
    }
    values[patch.field] = _stringifyPatchValue(patch.value);
    meta = applyPatchToMeta(meta: meta, patch: patch);
  }

  return values;
}

String? _stringifyPatchValue(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map || value is List) return jsonEncode(value);
  if (value is DateTime) return value.toIso8601String();
  return value.toString();
}

/// Pull merge: remote row wins unless local is dirty and newer (sync cursor rule).
bool shouldKeepLocalOnPull({
  required bool localDirty,
  required DateTime localUpdatedAt,
  required DateTime remoteUpdatedAt,
}) {
  if (localDirty && localUpdatedAt.isAfter(remoteUpdatedAt)) {
    return true;
  }
  return false;
}

DateTime? parseSyncCursor(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

String formatSyncCursor(DateTime t) => t.toUtc().toIso8601String();
