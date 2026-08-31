import 'package:momentum/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepository {
  AuthLocalRepository(this._localStorage);

  final SharedPreferences _localStorage;

  Future<UserModel?> getUser() async {
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    return;
  }
}
