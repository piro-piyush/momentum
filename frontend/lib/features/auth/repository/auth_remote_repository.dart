import 'package:momentum/lib.dart';

class AuthRemoteRepository {
  AuthRemoteRepository(this._service);

  final ApiService _service;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _service.post(
      '/auth/register',
      data: {'name': name.trim(), 'email': email.trim(), 'password': password},
    );

    ApiService.handleResponse(response, (_) {});
  }

  Future<(UserModel, String)> login({
    required String email,
    required String password,
  }) async {
    final response = await _service.post(
      '/auth/login',
      data: {'email': email.trim(), 'password': password},
    );

    return ApiService.handleResponse(response, (data) {
      final json = data as Map<String, dynamic>;

      return (
        UserModel.fromJson(json['user'] as Map<String, dynamic>),
        json['token'] as String,
      );
    });
  }

  Future<(bool, String)> tokenIsValid({required String token}) async {
    final response = await _service.get(
      '/auth/token-is-valid',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ApiService.handleResponse(response, (data) {
      final json = data as Map<String, dynamic>;

      return (json['valid'] as bool, json['userId'] as String);
    });
  }

  Future<UserModel?> getUser({required String token}) async {
    try {
      final response = await _service.get(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return await ApiService.handleResponse(
        response,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      return null;
    }
  }

  void dispose() => _service.close();
}
