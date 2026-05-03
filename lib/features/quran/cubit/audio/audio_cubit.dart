import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int? _currentSurahNumber;

  AudioCubit() : super(AudioInitial()) {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (processingState == ProcessingState.completed) {
        _currentSurahNumber = null;
        emit(AudioStopped());
      } else if (!isPlaying && processingState != ProcessingState.idle) {
        if (_currentSurahNumber != null) {
          emit(AudioPaused(_currentSurahNumber!));
        }
      }
    });
  }

  Future<void> playAudio(
    int surahNumber,
    String audioUrl, {
    bool isDownloaded = false,
  }) async {
    try {
      if (_currentSurahNumber == surahNumber && _audioPlayer.playing) {
        await _audioPlayer.pause();
        emit(AudioPaused(surahNumber));
        return;
      }

      if (_currentSurahNumber == surahNumber && !_audioPlayer.playing) {
        _audioPlayer.play();
        emit(AudioPlaying(surahNumber));
        return;
      }

      emit(AudioLoading(surahNumber));

      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      _currentSurahNumber = surahNumber;

      if (isDownloaded) {
        final dir = await getApplicationDocumentsDirectory();
        final localPath = '${dir.path}/surah_$surahNumber.mp3';
        await _audioPlayer.setFilePath(localPath);
        print("🎧 Play OFFLINE dari: $localPath");
      } else {
        await _audioPlayer.setUrl(audioUrl);
        print("📡 Play ONLINE (Streaming) dari: $audioUrl");
      }

      _audioPlayer.play();
      emit(AudioPlaying(surahNumber));
    } catch (e) {
      print("❌ [AudioCubit Error] $e");
      emit(
        AudioError("Gagal memutar audio. Pastikan koneksi internet stabil."),
      );
      _currentSurahNumber = null;
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
