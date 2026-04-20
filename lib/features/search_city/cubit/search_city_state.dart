part of 'search_city_cubit.dart';

abstract class SearchCityState {}

class SearchCityInitial extends SearchCityState {}

class SearchCityLoading extends SearchCityState {}

class SearchCityLoaded extends SearchCityState {
  final List<CityModel> allCities;
  final List<CityModel> filteredCities;

  SearchCityLoaded({required this.allCities, required this.filteredCities});
}

class SearchCityError extends SearchCityState {
  final String message;
  SearchCityError(this.message);
}
