part of 'quran_detail_cubit.dart';

abstract class QuranDetailState {}

class QuranDetailInitial extends QuranDetailState {}

class QuranDetailLoading extends QuranDetailState {}

class QuranDetailLoaded extends QuranDetailState {
  final String surahName;
  final String translation;
  final List<AyahModel> ayahs;
  final bool isLastPage;
  final bool isFetchingMore;

  QuranDetailLoaded({
    required this.surahName,
    required this.translation,
    required this.ayahs,
    required this.isLastPage,
    this.isFetchingMore = false,
  });

  QuranDetailLoaded copyWith({
    String? surahName,
    String? translation,
    List<AyahModel>? ayahs,
    bool? isLastPage,
    bool? isFetchingMore,
  }) {
    return QuranDetailLoaded(
      surahName: surahName ?? this.surahName,
      translation: translation ?? this.translation,
      ayahs: ayahs ?? this.ayahs,
      isLastPage: isLastPage ?? this.isLastPage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class QuranDetailError extends QuranDetailState {
  final String message;

  QuranDetailError(this.message);
}
