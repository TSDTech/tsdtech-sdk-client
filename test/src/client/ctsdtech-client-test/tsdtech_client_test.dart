import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';

void main() {
  test(
      'TsdtechClient does not initialize GatewayService when gatewayBaseUrl is null',
      () {
    final client = TsdtechClient();
    expect(client.gateway, isNull);
    expect(client.checkouts, isNotNull);
    expect(client.auth, isNotNull);
  });

  test(
      'TsdtechClient initializes GatewayService when gatewayBaseUrl is provided',
      () {
    final client = TsdtechClient(
      gatewayBaseUrl: 'https://gateway.tsdtech.com',
      gatewayApiKey: 'secret_key',
    );

    expect(client.gateway, isNotNull);
  });

  test('TsdtechClient creates isolated intra-api clients per instance', () {
    final clientA = TsdtechClient(
      baseUrl: 'https://tenant-a.example.com',
      dio: Dio(),
      authToken: 'token-a',
    );
    final clientB = TsdtechClient(
      baseUrl: 'https://tenant-b.example.com',
      dio: Dio(),
      authToken: 'token-b',
    );

    expect(clientA.baseApi, isNot(same(clientB.baseApi)));
    expect(clientA.checkouts.baseUrl, 'https://tenant-a.example.com');
    expect(clientB.checkouts.baseUrl, 'https://tenant-b.example.com');
    expect(
      clientA.baseApi.dio.options.headers['Authorization'],
      'Bearer token-a',
    );
    expect(
      clientB.baseApi.dio.options.headers['Authorization'],
      'Bearer token-b',
    );
  });

  test('TsdtechClient updates auth token on its own BaseApi instance', () {
    final client = TsdtechClient(dio: Dio());

    client.setAuthToken('scoped-token');
    expect(
      client.baseApi.dio.options.headers['Authorization'],
      'Bearer scoped-token',
    );

    client.clearAuthToken();
    expect(
      client.baseApi.dio.options.headers.containsKey('Authorization'),
      isFalse,
    );
  });
}
