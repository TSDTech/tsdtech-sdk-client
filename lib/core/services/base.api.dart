import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';

typedef TokenProvider = String? Function();

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
  Dio get dio;

  void configureDebugMode(bool enabled);

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

  static BaseApi _legacyInstance = BaseApiImpl();

  static BaseApi get legacyInstance => _legacyInstance;

  /// Sets whether to enable debug logging.
  static void setDebugMode(bool enabled) {
    _legacyInstance.configureDebugMode(enabled);
  }

  /// Sets the internal Dio instance (useful for tests to inject a mocked Dio).
  ///
  /// This method is intentionally simple and intended for test usage only.
  static void setDioForTesting(Dio dio) {
    _legacyInstance = BaseApiImpl(dio: dio);
  }

  static void setInstanceForTesting(BaseApi api) {
    _legacyInstance = api;
  }

  static Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _legacyInstance.getRequest(
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
  static Future<Response<dynamic>> post(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return _legacyInstance.postRequest(path, data: data, headers: headers);
  }

  /// Performs a PUT request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> put(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return _legacyInstance.putRequest(path, data: data, headers: headers);
  }

  /// Performs a PATCH request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> patch(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return _legacyInstance.patchRequest(path, data: data, headers: headers);
  }

  /// Performs a DELETE request to the specified [path].
  ///
  /// - [path]: The API endpoint path
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  static Future<Response<dynamic>> delete(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return _legacyInstance.deleteRequest(path, data: data, headers: headers);
  }

  /// Sets the Bearer token for all subsequent requests.
  ///
  /// - [token]: The token to set, or null to reset
  /// If null is passed, [resetToken] is called instead.
  static void setToken(String? token) {
    _legacyInstance.applyToken(token);
  }

  /// Resets (clears) the Bearer token from all requests.
  static void resetToken() {
    _legacyInstance.clearToken();
  }
}

class BaseApiImpl implements BaseApi {
  final Dio _dio;
  final TokenProvider? _tokenProvider;
  bool _debugMode;
  String? _token;
  bool _tokenExplicitlyConfigured = false;

  BaseApiImpl({
    Dio? dio,
    TokenProvider? tokenProvider,
    bool debugMode = false,
    String? token,
  })  : _dio = dio ?? Dio(),
        _tokenProvider = tokenProvider ?? (() => SharedPrefsHelper.authToken),
        _debugMode = debugMode,
        _token = token,
        _tokenExplicitlyConfigured = token != null {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  Dio get dio => _dio;

  @override
  void configureDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  void _debugLog(String message) {
    if (_debugMode) {
      // ignore: avoid_print
      print(message);
    }
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
            '[BaseApi] response: ${e.response?.statusCode} ${e.response?.data}');
      }
      if (_isServiceUnavailable(e)) {
        throw Exception(
            'Serviço indisponível no momento. Por favor, tente novamente mais tarde.');
      }
      rethrow;
    }
  }

  Map<String, dynamic>? _mergeHeaders(Map<String, dynamic>? headers) {
    final merged = <String, dynamic>{};
    if (headers != null) {
      merged.addAll(headers);
    }

    final token = _resolveToken();
    if (token != null && !merged.containsKey('Authorization')) {
      merged['Authorization'] = 'Bearer $token';
    }

    return merged.isEmpty ? null : merged;
  }

  String? _resolveToken() {
    if (_tokenExplicitlyConfigured) {
      return _token;
    }

    return _tokenProvider?.call();
  }

  @override
  Future<Response<dynamic>> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.get(
          path,
          queryParameters: queryParameters,
          options: Options(headers: _mergeHeaders(headers)),
        ));
  }

  @override
  Future<Response<dynamic>> postRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.post(
          path,
          data: data,
          options: Options(headers: _mergeHeaders(headers)),
        ));
  }

  @override
  Future<Response<dynamic>> putRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.put(
          path,
          data: data,
          options: Options(headers: _mergeHeaders(headers)),
        ));
  }

  @override
  Future<Response<dynamic>> patchRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.patch(
          path,
          data: data,
          options: Options(headers: _mergeHeaders(headers)),
        ));
  }

  @override
  Future<Response<dynamic>> deleteRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return _executeRequest(() => _dio.delete(
          path,
          data: data,
          options: Options(headers: _mergeHeaders(headers)),
        ));
  }

  bool _isServiceUnavailable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
  }

  @override
  void applyToken(String? token) {
    if (token == null) {
      clearToken();
      return;
    }

    _token = token;
    _tokenExplicitlyConfigured = true;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearToken() {
    _token = null;
    _tokenExplicitlyConfigured = true;
    _dio.options.headers.remove('Authorization');
  }
}
