import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';

import '../../../helpers/mock_dio.dart';

void main() {
  test(
    'TsdtechClient does not initialize GatewayService when gatewayBaseUrl is null',
    () {
      final client = TsdtechClient();
      expect(client.gateway, isNull);
    },
  );

  test(
    'TsdtechClient initializes GatewayService when gatewayBaseUrl is provided',
    () {
      final client = TsdtechClient(
        gatewayBaseUrl: 'https://gateway.tsdtech.com',
        gatewayApiKey: 'secret_key',
      );

      expect(client.gateway, isNotNull);
      // You can also add more specific reflection over the gateway's inner client if needed
    },
  );

  test('TsdtechClient creates isolated services per baseUrl', () {
    final firstClient = TsdtechClient(baseUrl: 'https://api-one.example.com');
    final secondClient = TsdtechClient(baseUrl: 'https://api-two.example.com');

    expect(firstClient.checkouts, isNot(same(secondClient.checkouts)));
    expect(firstClient.auth, isNot(same(secondClient.auth)));
    expect(firstClient.checkouts.baseUrl, 'https://api-one.example.com');
    expect(secondClient.checkouts.baseUrl, 'https://api-two.example.com');
  });

  test('TsdtechClient uses injected BaseApi for service requests', () async {
    final adapter = MockHttpClientAdapter();
    final dio = createDioWithAdapter(adapter);
    adapter.when('GET', '/checkouts/client/methods', [
      {'paymentMethod': 'pix', 'isActive': true},
    ]);

    final client = TsdtechClient.withBaseApi(
      baseApi: BaseApiImpl(dio: dio),
      baseUrl: 'https://tenant.example.com',
    );

    final result = await client.checkouts.getPaymentMethods();

    expect(result.isSuccess, isTrue);
    expect(result.value, hasLength(1));
    expect(adapter.requests, hasLength(1));
    expect(
      adapter.requests.single.path,
      'https://tenant.example.com/checkouts/client/methods',
    );
  });
}
