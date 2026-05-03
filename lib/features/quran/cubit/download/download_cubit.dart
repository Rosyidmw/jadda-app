import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final Dio _dio = Dio();

  DownloadCubit()
    : super(DownloadState(downloadedSurahs: [], downloadingProgress: {}));

  Future<void> checkDownloadedFiles(int totalSurah) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      List<int> downloaded = [];

      for (int i = 1; i <= totalSurah; i++) {
        final file = File('${dir.path}/surah_$i.mp3');
        if (await file.exists()) {
          downloaded.add(i);
        }
      }

      emit(
        DownloadState(
          downloadedSurahs: downloaded,
          downloadingProgress: state.downloadingProgress,
        ),
      );
    } catch (e) {
      print("❌ Gagal mengecek file lokal: $e");
    }
  }

  Future<void> downloadSurah(int surahNumber, String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/surah_$surahNumber.mp3';

      final newProgress = Map<int, double>.from(state.downloadingProgress);
      newProgress[surahNumber] = 0.0;
      emit(
        DownloadState(
          downloadedSurahs: state.downloadedSurahs,
          downloadingProgress: newProgress,
        ),
      );

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;

            final updatedProgress = Map<int, double>.from(
              state.downloadingProgress,
            );
            updatedProgress[surahNumber] = progress;
            emit(
              DownloadState(
                downloadedSurahs: state.downloadedSurahs,
                downloadingProgress: updatedProgress,
              ),
            );
          }
        },
      );

      final finalProgress = Map<int, double>.from(state.downloadingProgress);
      finalProgress.remove(surahNumber);

      final finalDownloaded = List<int>.from(state.downloadedSurahs);
      if (!finalDownloaded.contains(surahNumber)) {
        finalDownloaded.add(surahNumber);
      }

      emit(
        DownloadState(
          downloadedSurahs: finalDownloaded,
          downloadingProgress: finalProgress,
        ),
      );
      print("✅ Download Selesai: Surat $surahNumber tersimpan di $savePath");
    } catch (e) {
      print("❌ Download Error: $e");

      final errorProgress = Map<int, double>.from(state.downloadingProgress);
      errorProgress.remove(surahNumber);
      emit(
        DownloadState(
          downloadedSurahs: state.downloadedSurahs,
          downloadingProgress: errorProgress,
        ),
      );
    }
  }
}
