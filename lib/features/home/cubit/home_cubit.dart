import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jadda/core/constants/string_constant.dart';
import '../model/daily_schedule_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  String currentCityId = "85d8ce590ad8981ca2c8286f79f59954";

  Future<void> loadHomeData() async {
    emit(HomeLoading("Memuat data hari ini..."));
    try {
      print('🚀 [Home] GET /cal/today ...');
      final calUrl = Uri.parse("${StringConstant.baseUrl}/cal/today");
      final calResponse = await http.get(calUrl);

      String hijriString = "";
      if (calResponse.statusCode == 200) {
        final calBody = jsonDecode(calResponse.body);
        hijriString = calBody['data']['hijr']['today'] ?? "";
        print('✅ [Home] Tanggal Hijriah: $hijriString');
      }

      final now = DateTime.now();

      final period = "${now.year}-${now.month.toString().padLeft(2, '0')}";

      final todayStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      print('🚀 [Home] GET /sholat/jadwal/$currentCityId/$period ...');
      final scheduleUrl = Uri.parse(
        "${StringConstant.baseUrl}/sholat/jadwal/$currentCityId/$period",
      );
      final scheduleResponse = await http.get(scheduleUrl);

      if (scheduleResponse.statusCode == 200) {
        final scheduleBody = jsonDecode(scheduleResponse.body);
        final data = scheduleBody['data'];
        final cityName = data['kabko'] ?? "Lokasi Tidak Diketahui";
        final Map<String, dynamic> jadwalRaw = data['jadwal'];

        Map<String, DailyScheduleModel> monthlySchedule = {};
        jadwalRaw.forEach((key, value) {
          monthlySchedule[key] = DailyScheduleModel.fromJson(value);
        });

        print('✅ [Home] Jadwal bulanan berhasil dimuat untuk $cityName');

        emit(
          HomeLoaded(
            hijriDate: hijriString,
            cityName: cityName,
            monthlySchedule: monthlySchedule,
            selectedDate: todayStr,
          ),
        );
      } else {
        emit(HomeError("Gagal mengambil data jadwal salat."));
      }
    } catch (e) {
      print('❌ [Home Error] $e');
      emit(HomeError("Terjadi kesalahan koneksi. Coba lagi nanti."));
    }
  }

  void changeSelectedDate(String newDateString) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(
        HomeLoaded(
          hijriDate: currentState.hijriDate,
          cityName: currentState.cityName,
          monthlySchedule: currentState.monthlySchedule,
          selectedDate: newDateString,
        ),
      );
    }
  }
}
