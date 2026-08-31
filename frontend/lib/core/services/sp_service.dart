import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  SpService._();

  static const String _tokenKey = 'x-auth-token';

  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setToken(String token) {
    return _prefs.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static Future<bool> clearToken() {
    return _prefs.remove(_tokenKey);
  }
}
