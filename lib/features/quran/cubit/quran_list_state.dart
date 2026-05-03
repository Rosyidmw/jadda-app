part of 'quran_list_cubit.dart';

abstract class QuranListState {}

class QuranListInitial extends QuranListState {}

class QuranListLoading extends QuranListState {}

class QuranListLoaded extends QuranListState {
  final List<SurahModel> surahs;
  QuranListLoaded(this.surahs);
}

class QuranListError extends QuranListState {
  final String message;
  QuranListError(this.message);
}
