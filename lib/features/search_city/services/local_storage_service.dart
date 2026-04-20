import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _cityIdKey = 'CITY_ID';
  static const String _cityNameKey = 'CITY_NAME';

  static Future<void> saveCity(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityIdKey, id);
    await prefs.setString(_cityNameKey, name);
    print('💾 [Local Storage] Berhasil menyimpan kota: $name ($id)');
  }

  static Future<String?> getCityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cityIdKey);
  }

  static Future<String?> getCityName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cityNameKey);
  }
}
