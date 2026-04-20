import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/string_constant.dart';
import '../model/city_model.dart';

part 'search_city_state.dart';

class SearchCityCubit extends Cubit<SearchCityState> {
  SearchCityCubit() : super(SearchCityInitial());

  Future<void> loadAllCities() async {
    emit(SearchCityLoading());
    try {
      print('🚀 [SearchCity] GET /sholat/kabkota/semua ...');
      final url = Uri.parse("${StringConstant.baseUrl}/sholat/kabkota/semua");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'] ?? [];

        final List<CityModel> cities = data
            .map((json) => CityModel.fromJson(json))
            .toList();

        print("✅ [SearchCity] Daftar kota berhasil dimuat: ${cities.length}");
        print("✅ [SearchCity] Daftar kota berhasil dimuat: ${response.body}");

        emit(SearchCityLoaded(allCities: cities, filteredCities: cities));
      } else {
        emit(SearchCityError("Gagal memuat daftar kota."));
      }
    } catch (e) {
      print('❌ [SearchCity Error] $e');
      emit(SearchCityError("Terjadi kesalahan koneksi."));
    }
  }

  void searchCity(String keyword) {
    if (state is SearchCityLoaded) {
      final currentState = state as SearchCityLoaded;

      final filteredList = currentState.allCities.where((city) {
        return city.location.toLowerCase().contains(keyword.toLowerCase());
      }).toList();

      emit(
        SearchCityLoaded(
          allCities: currentState.allCities,
          filteredCities: filteredList,
        ),
      );
    }
  }
}
