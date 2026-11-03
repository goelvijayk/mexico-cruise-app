class RefreshProgress {
  const RefreshProgress({
    required this.phase,
    this.detail,
    this.downloadIndex,
    this.downloadTotal,
    this.bytesDownloaded,
  });

  final String phase;
  final String? detail;
  final int? downloadIndex;
  final int? downloadTotal;
  final int? bytesDownloaded;
}
