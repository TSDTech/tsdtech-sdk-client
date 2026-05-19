import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';

/// Static HTTP client base class using Dio for making API requests.
///
/// This class provides a singleton Dio instance with common configuration
/// for all API communications. It handles token injection, error processing,
/// and timeout management automatically.
///
/// ## Usage
/// ```dart
/// final response = await BaseApi.get('/api/users');
/// final response = await BaseApi.post('/api/create', data: payload);
/// ```
///
/// ## Token Management
/// Tokens can be set via [setToken] to be automatically injected as Bearer
/// tokens in the Authorization header. Use [resetToken] to clear it.
///
/// ## Error Handling
/// Connection timeouts and service unavailability are caught and converted
/// to user-friendly exception messages.
///
/// Example:
/// ```dart
/// try {
///   response = await BaseApi.get('/protected-endpoint');
/// } on Exception catch (e) {
///   print('Service unavailable: $e');
/// }
/// ```
abstract class BaseApi {
  static BaseApi _legacyInstance = BaseApiImpl(
    tokenProvider: () => SharedPrefsHelper.authToken,
  );
  static bool _debugMode = false;

  static BaseApi get legacyInstance => _legacyInstance;

  static bool get isDebugMode => _debugMode;

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

  /// Sets whether to enable debug logging.
  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  static void setLegacyInstance(BaseApi baseApi) {
    _legacyInstance = baseApi;
  }

  /// Sets the internal Dio instance (useful for tests to inject a mocked Dio).
  ///
  /// This method is intentionally simple and intended for test usage only.
  static void setDioForTesting(Dio dio) {
    _legacyInstance = BaseApiImpl(
      dio: dio,
      tokenProvider: () => SharedPrefsHelper.authToken,
    );
  }

  static void _debugLog(String message) {
    if (_debugMode) {
      // ignore: avoid_print
      print(message);
    }
  }

  /// Executes an HTTP request with automatic error handling.
  ///
  /// - Catches [DioException] for service unavailability (timeouts, connection errors)
  /// - Throws a user-friendly [Exception] when service is unavailable
  /// - Re-throws other [DioException] errors for calling code to handle
  static Future<Response<dynamic>> _executeRequest(
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

  /// Performs a GET request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [queryParameters]: Optional map of query parameters
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Map<String, dynamic>? _mergeHeaders(Map<String, dynamic>? headers) {
    final merged = <String, dynamic>{};
    if (headers != null) {
      merged.addAll(headers);
    }

    final token = SharedPrefsHelper.authToken;
    if (token != null && !merged.containsKey('Authorization')) {
      merged['Authorization'] = 'Bearer $token';
    }

    return merged.isEmpty ? null : merged;
  }

  static Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return legacyInstance.getRequest(
      path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// Performs a POST request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return legacyInstance.postRequest(
      path,
      data: data,
      headers: headers,
    );
  }

  /// Performs a PUT request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return legacyInstance.putRequest(
      path,
      data: data,
      headers: headers,
    );
  }

  /// Performs a PATCH request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return legacyInstance.patchRequest(
      path,
      data: data,
      headers: headers,
    );
  }

  /// Performs a DELETE request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return legacyInstance.deleteRequest(
      path,
      data: data,
      headers: headers,
    );
  }

  /// Checks if the [DioException] represents a service unavailability condition.
  ///
  /// Returns true for connection timeout, receive timeout, send timeout,
  /// or connection error types.
  static bool _isServiceUnavailable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
  }

  /// Sets the Bearer token for all subsequent requests.
  ///
  /// - [token]: The token to set, or null to reset
  /// If null is passed, [resetToken] is called instead.
  static void setToken(String? token) {
    legacyInstance.applyToken(token);
  }

  /// Resets (clears) the Bearer token from all requests.
  static void resetToken() {
    legacyInstance.clearToken();
  }
}

class BaseApiImpl implements BaseApi {
  BaseApiImpl({Dio? dio, String? Function()? tokenProvider})
    : _dio = dio ?? Dio(),
      _tokenProvider = tokenProvider;

  final Dio _dio;
  final String? Function()? _tokenProvider;

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
    return BaseApi._executeRequest(
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
    return BaseApi._executeRequest(
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
    return BaseApi._executeRequest(
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
    return BaseApi._executeRequest(
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
    return BaseApi._executeRequest(
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
