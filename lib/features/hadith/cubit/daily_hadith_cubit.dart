import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jadda/core/constants/string_constant.dart';
import 'package:jadda/features/hadith/model/hadith_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> {
  DailyHadithCubit() : super(DailyHadithInitial());

  final String _dateKey = 'daily_hadith_date';
  final String _dataKey = 'daily_hadith_data';

  Future<void> getDailyHadith() async {
    if (!isClosed) emit(DailyHadithLoading());

    try {
      final prefs = await SharedPreferences.getInstance();

      final String todayDate = DateTime.now().toIso8601String().split('T')[0];

      final String? savedDate = prefs.getString(_dateKey);

      if (savedDate == todayDate) {
        final String? savedDataString = prefs.getString(_dataKey);

        if (savedDataString != null) {
          final jsonData = jsonDecode(savedDataString);
          final hadith = HadithModel.fromJson(jsonData);

          print('📚 [Daily Hadith] Memuat dari Local Storage (Tidak hit API)');
          print('✅ Isi Hadis Local: $savedDataString');
          if (!isClosed) emit(DailyHadithLoaded(hadith));
          return;
        }
      }

      print('🚀 [Daily Hadith] Mengambil Hadis Random baru dari API...');
      final url = Uri.parse("${StringConstant.baseUrl}/hadis/enc/random");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        final hadith = HadithModel.fromJson(data);

        await prefs.setString(_dateKey, todayDate);
        await prefs.setString(_dataKey, jsonEncode(hadith.toJson()));

        print(
          '✅ [Daily Hadith] Berhasil mendapatkan dan menyimpan hadis baru!',
        );
        print('✅ ${response.body}');
        if (!isClosed) emit(DailyHadithLoaded(hadith));
      } else {
        if (!isClosed) emit(DailyHadithError("Gagal mengambil hadis harian."));
      }
    } catch (e) {
      print('❌ [Daily Hadith Error] $e');
      if (!isClosed) emit(DailyHadithError(e.toString()));
    }
  }
}
