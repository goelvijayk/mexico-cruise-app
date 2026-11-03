import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/domain/merge/field_merge.dart';

void main() {
  test('sync cursor round-trip', () {
    final t = DateTime.utc(2026, 12, 1, 8, 30);
    expect(parseSyncCursor(formatSyncCursor(t)), t);
  });

  test('dirty local row wins pull when newer', () {
    expect(
      shouldKeepLocalOnPull(
        localDirty: true,
        localUpdatedAt: DateTime.utc(2026, 1, 2),
        remoteUpdatedAt: DateTime.utc(2026, 1, 1),
      ),
      isTrue,
    );
    expect(
      shouldKeepLocalOnPull(
        localDirty: true,
        localUpdatedAt: DateTime.utc(2026, 1, 1),
        remoteUpdatedAt: DateTime.utc(2026, 1, 2),
      ),
      isFalse,
    );
  });
}
