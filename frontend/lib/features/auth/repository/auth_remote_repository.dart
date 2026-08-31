import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:momentum/core/core.dart';
import 'package:momentum/models/user_model.dart';

class AuthRemoteRepository {
  AuthRemoteRepository(this._client);

  final http.Client _client;

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${Constants.backendUri}/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        }),
      );

      return _handleResponse(response, successStatusCode: 201);
    } on AuthException {
      rethrow;
    } on http.ClientException catch (e) {
      throw AuthException('Network error: ${e.message}');
    } catch (_) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: _headers,
        body: jsonEncode({'email': email.trim(), 'password': password}),
      );

      return _handleResponse(response, successStatusCode: 200);
    } on AuthException {
      rethrow;
    } on http.ClientException catch (e) {
      throw AuthException('Network error: ${e.message}');
    } catch (_) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  UserModel _handleResponse(
    http.Response response, {
    required int successStatusCode,
  }) {
    final body = _decodeResponse(response);

    if (response.statusCode == successStatusCode) {
      return _parseAuthResponse(body);
    }

    throw AuthException(_extractErrorMessage(body));
  }

  dynamic _decodeResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw const AuthException('Empty response from server.');
    }

    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const AuthException('Invalid response from server.');
    }
  }

  UserModel _parseAuthResponse(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw const AuthException('Invalid server response.');
    }

    final data = body['data'];

    if (data is! Map<String, dynamic>) {
      throw const AuthException('Invalid authentication data.');
    }

    final user = data['user'];

    if (user is! Map<String, dynamic>) {
      throw const AuthException('Invalid user data.');
    }

    return UserModel.fromJson(user);
  }

  String _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body['message']?.toString() ??
          body['error']?.toString() ??
          'Something went wrong.';
    }

    return 'Something went wrong.';
  }

  void dispose() {
    _client.close();
  }
}
