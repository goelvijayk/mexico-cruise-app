import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/domain/merge/bundle_merge.dart';
import 'package:mexico_cruise/domain/merge/field_merge.dart';

void main() {
  test('bundle merge keeps dirty newer local row', () {
    expect(
      shouldApplyRemoteBundleRow(
        remoteUpdatedAt: DateTime.utc(2026, 1, 2),
        localUpdatedAt: DateTime.utc(2026, 1, 3),
        localDirty: true,
      ),
      isFalse,
    );
  });

  test('bundle merge applies newer remote when not dirty-local-newer', () {
    expect(
      shouldApplyRemoteBundleRow(
        remoteUpdatedAt: DateTime.utc(2026, 1, 4),
        localUpdatedAt: DateTime.utc(2026, 1, 3),
        localDirty: true,
      ),
      isTrue,
    );
  });

  test('aligns with shouldKeepLocalOnPull', () {
    final remote = DateTime.utc(2026, 1, 2);
    final local = DateTime.utc(2026, 1, 3);
    expect(
      shouldApplyRemoteBundleRow(
        remoteUpdatedAt: remote,
        localUpdatedAt: local,
        localDirty: true,
      ),
      !shouldKeepLocalOnPull(
        localDirty: true,
        localUpdatedAt: local,
        remoteUpdatedAt: remote,
      ),
    );
  });
}
