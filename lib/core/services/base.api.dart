import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';

/// Instantiable HTTP client contract for making API requests.
///
/// Use [BaseApiImpl] as the default Dio-backed implementation, or provide your
/// own implementation for tests and custom transports.
///
/// ## Usage
/// ```dart
/// final api = BaseApiImpl();
/// final response = await api.getRequest('/api/users');
/// final created = await api.postRequest('/api/create', data: payload);
/// ```
///
/// ## Token Management
/// Implementations may expose token helpers such as [BaseApiImpl.applyToken]
/// to automatically inject Bearer tokens in the Authorization header.
///
/// ## Error Handling
/// Connection timeouts and service unavailability are caught and converted
/// to user-friendly exception messages.
///
/// Example:
/// ```dart
/// final api = BaseApiImpl();
/// try {
///   response = await api.getRequest('/protected-endpoint');
/// } on Exception catch (e) {
///   print('Service unavailable: $e');
/// }
/// ```
abstract class BaseApi {
  Future<Response<dynamic>> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response<dynamic>> postRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<Response<dynamic>> putRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<Response<dynamic>> patchRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<Response<dynamic>> deleteRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  });

  void applyToken(String? token);

  void clearToken();
}

class BaseApiImpl implements BaseApi {
  BaseApiImpl({
    Dio? dio,
    String? Function()? tokenProvider,
    bool debugMode = false,
  })
    : _dio = dio ?? Dio(),
      _tokenProvider = tokenProvider ?? (() => SharedPrefsHelper.authToken),
      _debugMode = debugMode;

  final Dio _dio;
  final String? Function()? _tokenProvider;
  final bool _debugMode;

  void _debugLog(String message) {
    if (_debugMode) {
      // ignore: avoid_print
      print(message);
    }
  }

  bool _isServiceUnavailable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
  }

  Future<Response<dynamic>> _executeRequest(
    Future<Response<dynamic>> Function() requestFunction,
  ) async {
    try {
      return await requestFunction();
    } on DioException catch (e) {
      _debugLog('[BaseApi] DioError: ${e.type} ${e.message}');
      if (e.response != null) {
        _debugLog(
          '[BaseApi] response: ${e.response?.statusCode} ${e.response?.data}',
        );
      }
      if (_isServiceUnavailable(e)) {
        throw Exception(
          'Serviço indisponível no momento. Por favor, tente novamente mais tarde.',
        );
      }
      rethrow;
    }
  }

  Map<String, dynamic>? _mergeHeaders(Map<String, dynamic>? headers) {
    final merged = <String, dynamic>{};
    if (headers != null) {
      merged.addAll(headers);
    }

    final token = _tokenProvider?.call();
    if (token != null && !merged.containsKey('Authorization')) {
      merged['Authorization'] = 'Bearer $token';
    }

    return merged.isEmpty ? null : merged;
  }

  @override
  Future<Response<dynamic>> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: _mergeHeaders(headers)),
      ),
    );
  }

  @override
  Future<Response<dynamic>> postRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(
      () => _dio.post(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
    );
  }

  @override
  Future<Response<dynamic>> putRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(
      () => _dio.put(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
    );
  }

  @override
  Future<Response<dynamic>> patchRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(
      () => _dio.patch(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
    );
  }

  @override
  Future<Response<dynamic>> deleteRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(
      () => _dio.delete(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
    );
  }

  @override
  void applyToken(String? token) {
    if (token == null) {
      clearToken();
      return;
    }

    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }
}
