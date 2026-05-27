import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';

/// Dio interceptor that manages a short-lived scoped JWT for the TSDTech SDK.
///
/// Responsibilities:
/// - **Auto-init**: if no token is stored when the first request fires, fetches
///   one from [pixTokenUrl] before forwarding the request.
/// - **Auto-refresh**: on a 401 response it obtains a fresh token and
///   transparently retries the failed request once.
/// - **Concurrent safety**: at most one in-flight token request at a time;
///   subsequent callers await the same [Future].
/// - **Session expiry**: calls [onSessionExpired] and clears stored tokens when
///   the token endpoint itself fails or returns a non-token body.
///
/// The interceptor must be added to the **same** [Dio] instance passed as
/// [mainDio] so that retried requests share the same adapter and base options.
class SdkTokenInterceptor extends Interceptor {
  final Dio _mainDio;
  final Dio _tokenDio;

  /// Organisation identifier sent as `orgId` in the token request body.
  final String orgId;

  /// Full URL of the `POST /auth/sdk/pix-token` endpoint.
  final String pixTokenUrl;

  /// Called when the session cannot be renewed. The host app should redirect
  /// the user to a login/re-auth screen.
  final void Function()? onSessionExpired;

  /// Called whenever the token is changed by this interceptor (refresh or
  /// clear). Receives the new token, or `null` when cleared.
  /// Used by [BaseApi.configure] to propagate changes to token listeners.
  final void Function(String?)? onTokenChanged;

  /// Key added to [RequestOptions.extra] on a retried request to prevent
  /// infinite refresh loops.
  static const _retryKey = '_sdk_pix_retry';

  /// In-flight refresh [Future]. Non-null while a token request is pending,
  /// ensuring concurrent 401s share the same refresh call.
  Future<String?>? _refreshFuture;

  SdkTokenInterceptor({
    required Dio mainDio,
    required this.orgId,
    required this.pixTokenUrl,
    this.onSessionExpired,
    this.onTokenChanged,
  })  : _mainDio = mainDio,
        _tokenDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  /// Named constructor for unit tests — allows injecting a custom [tokenDio]
  /// so the token endpoint can be mocked independently.
  @visibleForTesting
  SdkTokenInterceptor.withTokenDio({
    required Dio mainDio,
    required Dio tokenDio,
    required this.orgId,
    required this.pixTokenUrl,
    this.onSessionExpired,
    this.onTokenChanged,
  })  : _mainDio = mainDio,
        _tokenDio = tokenDio;

  // ---------------------------------------------------------------------------
  // Interceptor overrides
  // ---------------------------------------------------------------------------

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Never intercept the token endpoint itself (avoids infinite recursion).
    if (_isTokenRequest(options.path)) {
      handler.next(options);
      return;
    }

    // If Authorization was already injected (e.g. by BaseApi._mergeHeaders or
    // by a retry path), nothing left to do.
    if (options.headers.containsKey('Authorization')) {
      handler.next(options);
      return;
    }

    // Try SharedPrefs first (token from a previous session or a previous call).
    var token = SharedPrefsHelper.authToken;
    if (token == null) {
      // Auto-init: fetch the first scoped token.
      token = await _refreshToken();
      if (token == null) {
        onSessionExpired?.call();
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'SDK session expired: could not obtain initial token.',
          ),
        );
        return;
      }
    }

    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized.
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Already a retry, or the token endpoint itself returned 401 — give up.
    if (err.requestOptions.extra[_retryKey] == true ||
        _isTokenRequest(err.requestOptions.path)) {
      await _clearAndNotify();
      handler.next(err);
      return;
    }

    // Refresh token (concurrent-safe: multiple 401s share one refresh call).
    final newToken = await _refreshToken();
    if (newToken == null) {
      await _clearAndNotify();
      handler.next(err);
      return;
    }

    // Retry the original request with the refreshed token.
    try {
      final retryOptions = Options(
        method: err.requestOptions.method,
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer $newToken',
        },
        extra: {...err.requestOptions.extra, _retryKey: true},
      );
      final response = await _mainDio.request<dynamic>(
        err.requestOptions.path,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
        options: retryOptions,
      );
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  /// Returns the single in-flight refresh [Future], or starts a new one.
  /// Resets [_refreshFuture] to null once the future completes.
  Future<String?> _refreshToken() {
    _refreshFuture ??= _doRefresh().whenComplete(() => _refreshFuture = null);
    return _refreshFuture!;
  }

  /// Exposed for unit tests to verify concurrent-refresh behaviour.
  @visibleForTesting
  Future<String?> refreshTokenForTesting() => _refreshToken();

  Future<String?> _doRefresh() async {
    try {
      final response = await _tokenDio.post<Map<String, dynamic>>(
        pixTokenUrl,
        data: {'orgId': orgId},
      );
      final token = response.data?['token'] as String?;
      if (token == null) return null;
      await SharedPrefsHelper.setAuthToken(token);
      onTokenChanged?.call(token);
      return token;
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearAndNotify() async {
    await SharedPrefsHelper.clearAuthToken();
    onTokenChanged?.call(null);
    onSessionExpired?.call();
  }

  bool _isTokenRequest(String path) => path.contains('/auth/sdk/pix-token');
}
