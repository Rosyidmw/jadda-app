part of 'download_cubit.dart';

class DownloadState {
  final List<int> downloadedSurahs;
  final Map<int, double> downloadingProgress;

  DownloadState({
    required this.downloadedSurahs,
    required this.downloadingProgress,
  });
}
