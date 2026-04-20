part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final String message;
  HomeLoading(this.message);
}

class HomeLoaded extends HomeState {
  final String hijriDate;
  final String cityName;

  final Map<String, DailyScheduleModel> monthlySchedule;
  final String selectedDate;

  HomeLoaded({
    required this.hijriDate,
    required this.cityName,
    required this.monthlySchedule,
    required this.selectedDate,
  });

  DailyScheduleModel? get currentSchedule => monthlySchedule[selectedDate];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
