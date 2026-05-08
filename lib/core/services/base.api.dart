import 'package:voucherize/core/local_storage/auth_token/auth_token.prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class BaseApi {
  static final Dio _dio = Dio();

  static Future<Response> _executeRequest(
    Future<Response> Function() requestFunction,
  ) async {
    _initializeToken();
    try {
      return await requestFunction();
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[BaseApi] DioError: ${e.type} ${e.message}');
        if (e.response != null) debugPrint('[BaseApi] response: ${e.response?.statusCode} ${e.response?.data}');
      }
      if (_isServiceUnavailable(e)) {
        throw Exception(
            'Serviço indisponível no momento. Por favor, tente novamente mais tarde.');
      }
      rethrow;
    }
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.get(
          path,
          queryParameters: queryParameters,
          options: headers != null ? Options(headers: headers) : null,
        ));
  }

  static Future<Response> post(String path, {Object? data, Map<String, dynamic>? headers}) async {
    return _executeRequest(() => _dio.post(
          path,
          data: data,
          options: headers != null ? Options(headers: headers) : null,
        ));
  }

  static Future<Response> put(String path, {Object? data, Map<String, dynamic>? headers}) async {
    return _executeRequest(() => _dio.put(
          path,
          data: data,
          options: headers != null ? Options(headers: headers) : null,
        ));
  }

  static Future<Response> patch(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return _executeRequest(() => _dio.patch(
          path,
          data: data,
          options: headers != null ? Options(headers: headers) : null,
        ));
  }

  static Future<Response> delete(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return _executeRequest(() => _dio.delete(
          path,
          data: data,
          options: headers != null ? Options(headers: headers) : null,
        ));
  }

  static bool _isServiceUnavailable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
  }

  static String? _initializeToken() {
    var token = AuthTokenPrefs.get();
    setToken(token);
    return token;
  }

  static void setToken(String? token) async {
    if (token == null) {
      resetToken();
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static resetToken() {
    _dio.options.headers.remove('Authorization');
  }
}
