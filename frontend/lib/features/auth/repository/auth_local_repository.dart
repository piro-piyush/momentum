import 'dart:convert';

import 'package:momentum/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepository {
  AuthLocalRepository(this._localStorage);

  final SharedPreferences _localStorage;

  static const String _userKey = 'auth_user';

  Future<UserModel?> getUser() async {
    final userJson = _localStorage.getString(_userKey);

    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      final data = jsonDecode(userJson) as Map<String, dynamic>;

      return UserModel.fromJson(data);
    } catch (_) {
      await clearUser();
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _localStorage.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _localStorage.remove(_userKey);
  }
}
