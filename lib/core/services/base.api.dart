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
/// Call [setToken] after login to persist the Bearer token in [SharedPrefsHelper].
/// [_mergeHeaders] is the single injection point: it reads the token on every
/// request so the correct value is always used. Call [resetToken] on logout.
/// Register callbacks via [addTokenListener] to react to token changes.
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
  static Dio _dio = Dio();
  static bool _debugMode = false;
  static final List<void Function(String?)> _tokenListeners = [];

  /// Sets whether to enable debug logging.
  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  /// Sets the internal Dio instance (useful for tests to inject a mocked Dio).
  ///
  /// This method is intentionally simple and intended for test usage only.
  static void setDioForTesting(Dio dio) {
    _dio = dio;
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
    return _executeRequest(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: _mergeHeaders(headers)),
      ),
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
    return _executeRequest(
      () => _dio.post(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
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
    return _executeRequest(
      () => _dio.put(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
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
    return _executeRequest(
      () => _dio.patch(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
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
    return _executeRequest(
      () => _dio.delete(
        path,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      ),
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
  /// Persists [token] in [SharedPrefsHelper] so that [_mergeHeaders] — the
  /// single injection point — always reads the authoritative value.
  /// Notifies any registered token listeners after persisting.
  ///
  /// If null is passed, [resetToken] is called instead.
  ///
  /// ```dart
  /// await BaseApi.setToken(loginResponse.token);
  /// ```
  static Future<void> setToken(String? token) async {
    if (token == null) {
      await resetToken();
      return;
    }
    await SharedPrefsHelper.setAuthToken(token);
    for (final fn in List.of(_tokenListeners)) {
      fn(token);
    }
  }

  /// Resets (clears) the Bearer token from [SharedPrefsHelper].
  ///
  /// Notifies any registered token listeners with `null` after clearing.
  ///
  /// ```dart
  /// await BaseApi.resetToken();
  /// ```
  static Future<void> resetToken() async {
    await SharedPrefsHelper.clearAuthToken();
    for (final fn in List.of(_tokenListeners)) {
      fn(null);
    }
  }

  /// Registers a [listener] to be called whenever the token changes.
  ///
  /// The listener receives the new token value, or `null` when the token
  /// is cleared via [resetToken].
  static void addTokenListener(void Function(String?) listener) {
    _tokenListeners.add(listener);
  }

  /// Removes a previously registered token [listener].
  static void removeTokenListener(void Function(String?) listener) {
    _tokenListeners.remove(listener);
  }
}
