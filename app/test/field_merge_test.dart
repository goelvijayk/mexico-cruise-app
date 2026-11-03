import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/domain/merge/field_merge.dart';

void main() {
  group('field merge / outbox', () {
    test('accepts patch when field has no prior meta', () {
      expect(
        shouldApplyPatch(
          meta: {},
          field: 'notes',
          patchUpdatedAt: DateTime.utc(2026, 1, 2),
        ),
        PatchApplyResult.accepted,
      );
    });

    test('rejects older patch on same field', () {
      final meta = {
        'notes': FieldMetaEntry(
          updatedAt: DateTime.utc(2026, 1, 3),
          updatedBy: 'A',
        ),
      };
      expect(
        shouldApplyPatch(
          meta: meta,
          field: 'notes',
          patchUpdatedAt: DateTime.utc(2026, 1, 2),
        ),
        PatchApplyResult.rejected,
      );
    });

    test('merges different fields from two offline editors', () {
      final merged = mergeEventFields(
        base: {'notes': 'a', 'booking_ref': 'X'},
        baseMeta: {},
        patches: [
          FieldPatch(
            patchId: '1',
            rowId: 'e1',
            field: 'notes',
            value: 'from A',
            updatedAt: DateTime.utc(2026, 1, 1, 10),
            updatedBy: 'A',
          ),
          FieldPatch(
            patchId: '2',
            rowId: 'e1',
            field: 'booking_ref',
            value: 'Y',
            updatedAt: DateTime.utc(2026, 1, 1, 11),
            updatedBy: 'B',
          ),
        ],
      );
      expect(merged['notes'], 'from A');
      expect(merged['booking_ref'], 'Y');
    });

    test('same-field conflict is last-writer-wins', () {
      final merged = mergeEventFields(
        base: {'notes': 'old'},
        baseMeta: {
          'notes': FieldMetaEntry(
            updatedAt: DateTime.utc(2026, 1, 1, 9),
            updatedBy: 'A',
          ),
        },
        patches: [
          FieldPatch(
            patchId: '1',
            rowId: 'e1',
            field: 'notes',
            value: 'winner',
            updatedAt: DateTime.utc(2026, 1, 1, 12),
            updatedBy: 'B',
          ),
          FieldPatch(
            patchId: '2',
            rowId: 'e1',
            field: 'notes',
            value: 'loser',
            updatedAt: DateTime.utc(2026, 1, 1, 11),
            updatedBy: 'A',
          ),
        ],
      );
      expect(merged['notes'], 'winner');
    });
  });
}
