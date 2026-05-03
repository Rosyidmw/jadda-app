import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jadda/core/constants/string_constant.dart';
import 'package:jadda/features/quran/model/surah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quran_list_state.dart';

class QuranListCubit extends Cubit<QuranListState> {
  QuranListCubit() : super(QuranListInitial());

  final String _quranDataKey = 'quran_list_data';

  Future<void> getSurahList() async {
    if (!isClosed) emit(QuranListLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedDataString = prefs.getString(_quranDataKey);

      if (savedDataString != null) {
        final List<dynamic> jsonData = jsonDecode(savedDataString);
        final List<SurahModel> surahs = jsonData
            .map((e) => SurahModel.fromJson(e))
            .toList();

        print('📖 [Quran List] Memuat 114 Surah dari Local Storage');
        print('${savedDataString.length}');

        if (!isClosed) emit(QuranListLoaded(surahs));
        return;
      }

      print('🚀 [Quran List] Mengambil data Surah dari API...');
      final url = Uri.parse("${StringConstant.baseUrl}/quran");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        final List<SurahModel> surahs = data
            .map((e) => SurahModel.fromJson(e))
            .toList();

        final String dataToSave = jsonEncode(
          surahs.map((e) => e.toJson()).toList(),
        );
        await prefs.setString(_quranDataKey, dataToSave);

        print(
          '✅ [Quran List] Berhasil mendapat dan menyimpan ${surahs.length} Surah!',
        );
        if (!isClosed) emit(QuranListLoaded(surahs));
      } else {
        if (!isClosed) emit(QuranListError("Gagal mengambil daftar surat."));
      }
    } catch (e) {
      print('❌ [Quran List Error] $e');
      if (!isClosed) emit(QuranListError(e.toString()));
    }
  }
}
