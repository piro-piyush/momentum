import 'package:momentum/lib.dart';

class AuthLocalRepository {
  AuthLocalRepository(this._db);

  final Database _db;

  static const String _tableName = 'users';

  Future<UserModel?> getUser() async {
    final result = await _db.query(_tableName, limit: 1);

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromJson(result.first);
  }

  Future<void> saveUser(UserModel user) async {
    await _db.insert(
      _tableName,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearUser() async {
    await _db.delete(_tableName);
  }
}
