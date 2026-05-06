import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jadda/core/constants/string_constant.dart';
import 'package:jadda/features/quran/model/ayah_model.dart';

part 'quran_detail_state.dart';

class QuranDetailCubit extends Cubit<QuranDetailState> {
  QuranDetailCubit() : super(QuranDetailInitial());

  int _currentPage = 1;
  final List<AyahModel> _currentAyahs = [];
  bool _isLastPage = false;
  int _currentSurahNumber = 0;
  bool _isFetchingAPI = false;

  Future<void> getSurahDetail(
    int surahNumber, {
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (_isLastPage || _isFetchingAPI) return;

      _isFetchingAPI = true;
      _currentPage++;

      if (state is QuranDetailLoaded) {
        emit((state as QuranDetailLoaded).copyWith(isFetchingMore: true));
      }
    } else {
      _isFetchingAPI = true;
      _currentPage = 1;
      _currentAyahs.clear();
      _isLastPage = false;
      _currentSurahNumber = surahNumber;
      if (!isClosed) emit(QuranDetailLoading());
    }

    try {
      final url = Uri.parse(
        "${StringConstant.baseUrl}/quran/$_currentSurahNumber?page=$_currentPage",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final surahName = body['data']['name_latin'];
        final translation = body['data']['translation'];
        final totalData = body['pagination']['total'];

        final List<dynamic> ayahsData = body['data']['ayahs'];
        final List<AyahModel> newAyahs = ayahsData
            .map((e) => AyahModel.fromJson(e))
            .toList();

        _currentAyahs.addAll(newAyahs);

        if (_currentPage >= totalData) {
          _isLastPage = true;
        }

        _isFetchingAPI = false;

        if (!isClosed) {
          emit(
            QuranDetailLoaded(
              surahName: surahName,
              translation: translation,
              ayahs: List.from(_currentAyahs),
              isLastPage: _isLastPage,
            ),
          );
        }
      } else {
        _isFetchingAPI = false;
        if (!isClosed && !isLoadMore)
          emit(QuranDetailError("Gagal mengambil detail surat."));
      }
    } catch (e) {
      _isFetchingAPI = false;
      if (!isClosed && !isLoadMore) emit(QuranDetailError(e.toString()));
    }
  }

  Future<void> loadUpToAyah(int surahNumber, int targetAyah) async {
    _isFetchingAPI = true;
    _currentSurahNumber = surahNumber;
    _currentAyahs.clear();
    _isLastPage = false;
    emit(QuranDetailLoading());

    int targetPage = ((targetAyah - 1) ~/ 10) + 1;

    try {
      String surahName = '';
      String translation = '';

      for (int i = 1; i <= targetPage; i++) {
        final url = Uri.parse(
          "${StringConstant.baseUrl}/quran/$_currentSurahNumber?page=$i",
        );
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          surahName = body['data']['name_latin'];
          translation = body['data']['translation'];
          final totalData = body['pagination']['total'];

          final List<dynamic> ayahsData = body['data']['ayahs'];
          final List<AyahModel> newAyahs = ayahsData
              .map((e) => AyahModel.fromJson(e))
              .toList();

          _currentAyahs.addAll(newAyahs);
          _currentPage = i;

          if (i >= totalData) {
            _isLastPage = true;
            break;
          }
        } else {
          throw Exception("Gagal memuat halaman $i");
        }
      }

      _isFetchingAPI = false;

      if (!isClosed) {
        emit(
          QuranDetailLoaded(
            surahName: surahName,
            translation: translation,
            ayahs: List.from(_currentAyahs),
            isLastPage: _isLastPage,
          ),
        );
      }
    } catch (e) {
      _isFetchingAPI = false;
      if (!isClosed) emit(QuranDetailError(e.toString()));
    }
  }
}
