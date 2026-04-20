import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jadda/core/constants/string_constant.dart';
import 'package:jadda/features/home/services/time_service.dart';
import '../model/daily_schedule_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  String currentCityId = "85d8ce590ad8981ca2c8286f79f59954";
  Timer? _timer;

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

        _startTimer(todayStr);
      } else {
        emit(HomeError("Gagal mengambil data jadwal salat."));
      }
    } catch (e) {
      print('❌ [Home Error] $e');
      emit(HomeError("Terjadi kesalahan koneksi. Coba lagi nanti."));
    }
  }

  void _startTimer(String todayStr) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final schedule = currentState.currentSchedule;

        // Hanya jalankan timer jika data ada dan tanggal yang dipilih adalah HARI INI
        if (schedule != null && currentState.selectedDate == todayStr) {
          final timeData = TimeService.getCurrentAndNextPrayer(schedule);

          emit(
            HomeLoaded(
              hijriDate: currentState.hijriDate,
              cityName: currentState.cityName,
              monthlySchedule: currentState.monthlySchedule,
              selectedDate: currentState.selectedDate,
              // Masukkan data realtime-nya
              activePrayer: timeData["activePrayer"]!,
              activePrayerTime: timeData["activePrayerTime"]!,
              countdown: timeData["countdown"]!,
            ),
          );
        }
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
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
