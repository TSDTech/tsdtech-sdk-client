import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';

/// Base class for intra-service API communication.
///
/// This class extends [BaseApi] functionality with URL joining capabilities.
/// Each service extends [IntraApi] with a configured [baseUrl] for making
/// API calls to specific microservice endpoints.
///
/// ## Usage
/// ```dart
/// class VouchersService extends IntraApi {
///   static final VouchersService instance = VouchersService();
///   VouchersService() : super('https://vouchers.tsdtech.com');
///
///   Future<ValueResult<List<Voucher>>> getVouchers() async { ... }
/// }
/// ```
///
/// ## URL Handling
/// The [joinUrl] method ensures proper URL construction by:
/// - Removing trailing slashes from baseUrl
/// - Adding leading slash to path if missing
/// - Concatenating without duplicate slashes
class IntraApi {
  final String _baseUrl;

  /// Creates an IntraApi instance with the specified [baseUrl].
  ///
  /// - [baseUrl]: The base URL for all API requests in this service
  IntraApi(this._baseUrl);

  /// Returns the base URL of this service.
  String get baseUrl => _baseUrl;

  /// Performs a GET request to the specified [path] on this service's base URL.
  ///
  /// - [path]: The API endpoint path (will be joined with baseUrl)
  /// - [queryParameters]: Optional map of query parameters
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  @protected
  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    return await BaseApi.get(
      joinUrl(_baseUrl, path),
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// Performs a POST request to the specified [path] on this service's base URL.
  ///
  /// - [path]: The API endpoint path (will be joined with baseUrl)
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  @protected
  Future<Response<dynamic>> post(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return await BaseApi.post(
      joinUrl(_baseUrl, path),
      data: data,
      headers: headers,
    );
  }

  /// Performs a PUT request to the specified [path] on this service's base URL.
  ///
  /// - [path]: The API endpoint path (will be joined with baseUrl)
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  @protected
  Future<Response<dynamic>> put(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return await BaseApi.put(
      joinUrl(_baseUrl, path),
      data: data,
      headers: headers,
    );
  }

  /// Performs a PATCH request to the specified [path] on this service's base URL.
  ///
  /// - [path]: The API endpoint path (will be joined with baseUrl)
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  @protected
  Future<Response<dynamic>> patch(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return await BaseApi.patch(
      joinUrl(_baseUrl, path),
      data: data,
      headers: headers,
    );
  }

  /// Performs a DELETE request to the specified [path] on this service's base URL.
  ///
  /// - [path]: The API endpoint path (will be joined with baseUrl)
  /// - [data]: Optional body data to send
  /// - [headers]: Optional map of additional headers
  /// - Returns: A [Future] containing the [Response]
  @protected
  Future<Response<dynamic>> delete(String path,
      {Object? data, Map<String, dynamic>? headers}) async {
    return await BaseApi.delete(
      joinUrl(_baseUrl, path),
      data: data,
      headers: headers,
    );
  }

  /// Joins a [baseUrl] and [path] into a single URL string.
  ///
  /// Handles trailing/leading slashes appropriately to avoid duplicates.
  /// - [baseUrl]: The base URL (trailing slash will be stripped if present)
  /// - [path]: The endpoint path (leading slash will be added if missing)
  /// - Returns: Properly joined URL string
  String joinUrl(String baseUrl, String path) {
    baseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    path = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$path';
  }
}
