part of 'audio_cubit.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {
  final int surahNumber;
  AudioLoading(this.surahNumber);
}

class AudioPlaying extends AudioState {
  final int surahNumber;
  AudioPlaying(this.surahNumber);
}

class AudioPaused extends AudioState {
  final int surahNumber;
  AudioPaused(this.surahNumber);
}

class AudioStopped extends AudioState {}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
