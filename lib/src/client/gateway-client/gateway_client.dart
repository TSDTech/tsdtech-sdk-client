import 'package:dio/dio.dart';

class GatewayClient {
  final Dio _dio;

  final String gatewayBaseUrl;
  final String? apiKey;

  GatewayClient({
    required this.gatewayBaseUrl,
    this.apiKey,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: gatewayBaseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           sendTimeout: sendTimeout,
           headers: {
             'accept': 'application/json',
             'content-type': 'application/json',
           },
         ),
       ) {
    if (apiKey != null) {
      _dio.options.headers['X-API-Key'] = apiKey;
    }
  }

  Dio get dio => _dio;
}
