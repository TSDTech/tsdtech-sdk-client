import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';

void main() {
  test(
      'TsdtechClient does not initialize GatewayService when gatewayBaseUrl is null',
      () {
    final client = TsdtechClient();
    expect(client.gateway, isNull);
  });

  test(
      'TsdtechClient initializes GatewayService when gatewayBaseUrl is provided',
      () {
    final client = TsdtechClient(
      gatewayBaseUrl: 'https://gateway.tsdtech.com',
      gatewayApiKey: 'secret_key',
    );

    expect(client.gateway, isNotNull);
    // You can also add more specific reflection over the gateway's inner client if needed
  });
}
