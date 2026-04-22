import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/string_constant.dart';
import '../../../core/services/location_service.dart';
import '../model/qibla_model.dart';

part 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit() : super(QiblaInitial());

  Future<void> getLocationAndQibla() async {
    if (!isClosed) emit(QiblaLoading("Mencari lokasimu saat ini..."));

    try {
      final position = await LocationService.getCurrentLocation();
      final lat = position.latitude;
      final lng = position.longitude;

      if (!isClosed) emit(QiblaLoading("Menghitung arah Kiblat..."));

      print('🚀 [Qibla] GET /qibla/$lat,$lng ...');
      final url = Uri.parse("${StringConstant.baseUrl}/qibla/$lat,$lng");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        final qiblaModel = QiblaModel.fromJson(data);
        print(
          '✅ [Qibla] Arah kiblat berhasil didapat: ${qiblaModel.direction}°',
        );

        if (!isClosed) emit(QiblaLoaded(qiblaModel));
      } else {
        if (!isClosed)
          emit(QiblaError("Gagal mengambil data dari server MyQuran."));
      }
    } catch (e) {
      print('❌ [Qibla Error] $e');

      final message = e.toString().replaceAll("Exception: ", "");
      if (!isClosed) emit(QiblaError(message));
    }
  }
}
