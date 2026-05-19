import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// Simple mock HttpClientAdapter for Dio used in unit tests.
class MockHttpClientAdapter implements HttpClientAdapter {
  final Map<String, Map<String, dynamic>> _responses = {};
  final Map<String, Exception> _throws = {};
  final List<RequestOptions> requests = [];

  /// Register a successful response for [method] and a path suffix [pathSuffix].
  void when(
    String method,
    String pathSuffix,
    dynamic data, {
    int statusCode = 200,
  }) {
    _responses['${method.toUpperCase()} $pathSuffix'] = {
      'data': data,
      'status': statusCode,
    };
  }

  /// Register an exception to be thrown for [method] + [pathSuffix].
  void whenThrow(String method, String pathSuffix, Exception e) {
    _throws['${method.toUpperCase()} $pathSuffix'] = e;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<dynamic>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final method = options.method.toUpperCase();
    final path = options.path;

    // Check for registered exception first
    for (final key in _throws.keys) {
      final parts = key.split(' ');
      final kMethod = parts[0];
      final suffix = key.substring(kMethod.length + 1);
      if (kMethod == method && path.endsWith(suffix)) {
        final e = _throws[key]!;
        if (e is DioException) throw e;
        throw e;
      }
    }

    // Find matching response by suffix
    for (final key in _responses.keys) {
      final parts = key.split(' ');
      final kMethod = parts[0];
      final suffix = key.substring(kMethod.length + 1);
      if (kMethod == method && path.endsWith(suffix)) {
        final entry = _responses[key]!;
        final bodyString = jsonEncode(entry['data']);
        return ResponseBody.fromString(
          bodyString,
          entry['status'] as int,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }
    }

    return ResponseBody.fromString(
      '',
      404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio createDioWithAdapter(MockHttpClientAdapter adapter) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );
  dio.httpClientAdapter = adapter;
  return dio;
}
