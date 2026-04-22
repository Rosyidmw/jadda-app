part of 'qibla_cubit.dart';

abstract class QiblaState {}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {
  final String message;
  QiblaLoading(this.message);
}

class QiblaLoaded extends QiblaState {
  final QiblaModel qiblaData;
  QiblaLoaded(this.qiblaData);
}

class QiblaError extends QiblaState {
  final String message;
  QiblaError(this.message);
}
