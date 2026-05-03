part of 'daily_hadith_cubit.dart';

abstract class DailyHadithState {}

class DailyHadithInitial extends DailyHadithState {}

class DailyHadithLoading extends DailyHadithState {}

class DailyHadithLoaded extends DailyHadithState {
  final HadithModel hadith;
  DailyHadithLoaded(this.hadith);
}

class DailyHadithError extends DailyHadithState {
  final String message;
  DailyHadithError(this.message);
}
