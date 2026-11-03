import 'package:mexico_cruise/domain/merge/field_merge.dart';

/// PRD §5.1: bundle row wins if newer; local dirty + newer updated_at survives.
bool shouldApplyRemoteBundleRow({
  required DateTime remoteUpdatedAt,
  required DateTime? localUpdatedAt,
  required bool localDirty,
}) {
  final local = localUpdatedAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  if (shouldKeepLocalOnPull(
    localDirty: localDirty,
    localUpdatedAt: local.toUtc(),
    remoteUpdatedAt: remoteUpdatedAt.toUtc(),
  )) {
    return false;
  }
  return remoteUpdatedAt.toUtc().isAfter(local.toUtc());
}
