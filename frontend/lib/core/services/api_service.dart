import 'package:momentum/lib.dart';

class ApiService {
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: Constants.backendUri,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  final Dio _dio;

  Dio get instance => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException error) {
    final response = error.response;

    if (response != null) {
      final body = response.data;

      if (body is Map<String, dynamic>) {
        final message = body['message']?.toString();

        return ApiException(
          message ?? 'Request failed.',
          statusCode: response.statusCode,
          errors: body['errors'],
        );
      }

      return ApiException('Request failed.', statusCode: response.statusCode);
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const ApiException(
        'Request timed out. Please try again.',
      ),

      DioExceptionType.connectionError => const ApiException(
        'Network error. Please check your connection.',
      ),

      DioExceptionType.cancel => const ApiException('Request was cancelled.'),

      _ => const ApiException('Something went wrong. Please try again.'),
    };
  }

  static T handleResponse<T>(
    Response response,
    T Function(dynamic data) parser,
  ) {
    final body = response.data;

    if (body is! Map<String, dynamic>) {
      throw const ApiException('Invalid server response.');
    }

    final success = body['success'] == true;
    final message = body['message']?.toString() ?? 'Request failed.';

    if (!success) {
      throw ApiException(
        message,
        statusCode: response.statusCode,
        errors: body['errors'],
      );
    }

    return parser(body['data']);
  }

  void close() {
    _dio.close();
  }

  static String getApiErrorMessage(String fallback, dynamic details) {
    if (details is! Map) {
      return fallback;
    }

    final properties = details['properties'];

    if (properties is! Map || properties.isEmpty) {
      return fallback;
    }

    final entry = properties.entries.first;
    final field = entry.key.toString();
    final fieldError = entry.value;

    if (fieldError is Map) {
      final errors = fieldError['errors'];

      if (errors is List && errors.isNotEmpty) {
        return '$field: ${errors.first}';
      }
    }

    return '$field: $fieldError';
  }
}
