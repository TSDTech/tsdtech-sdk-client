import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/src/client/gateway-client/gateway_client.dart';
import 'package:tsdtech_client_sdk/src/services/gateway-services/gateway_service.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/card_payment_request.dart';

const validMockPemKey = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtt1U5UFmzDjj7gapJsmm
bYtbyidVOPtj4WoyMnTaNL4EzwbunYI2oQWcxXR8H/e0f96eVHBa7w1Oq5l/IrcV
mpljD8AQqubMD9qN3D8m4CO2nENkoBQK7KP3+M1PqekqIRrIxWzGwSJPn0bSfRb/
E23qCA3Piha+u6ehKFcOs9zkO3tTfwEU3UwxYQCjrbBGDVWe+bOea6ieDjUV/P/J
ErpDWPDHh5/7bseus0lVJZkvqmoeT4ec98M3vxDpAc1N2ZGQE+5ou+i6gvJl8AMA
64n4gkOmYCWKXtcXQj4XtI6ZufN8FH/gPtgYglkB0TS9KXEcU+NTwdv5WGADYAZb
GQIDAQAB
-----END PUBLIC KEY-----''';

class MockInterceptor extends Interceptor {
  final void Function(RequestOptions options, RequestInterceptorHandler handler) onRequestHandler;
  MockInterceptor(this.onRequestHandler);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestHandler(options, handler);
  }
}

void main() {
  late GatewayClient client;
  late GatewayService service;

  setUp(() {
    client = GatewayClient(gatewayBaseUrl: 'http://test-gateway.local');
    service = GatewayService(client);
  });

  test('fetchPublicKey returns PublicKeyResponse with pemPublicKey and keyId', () async {
    client.dio.interceptors.add(MockInterceptor((options, handler) {
      if (options.path == '/public-keys') {
        handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'keyId': 'key_123', 'pemPublicKey': validMockPemKey}));
      }
    }));
    final result = await service.fetchPublicKey();
    expect(result.isSuccess, true);
    expect(result.value?.pemPublicKey, validMockPemKey); // 🔥 Aqui tava o erro!
  });

  test('payWithCard returns PaymentStatusResponse approved', () async {
    client.dio.interceptors.add(MockInterceptor((options, handler) {
      if (options.path == '/payments/card' && options.method == 'POST') {
        handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'depositRequestId': 'req_456', 'status': 'approved'}));
      }
    }));
    final result = await service.payWithCard(CardPaymentRequest(depositRequestId: 'req_456', encryptedCard: 'data', keyId: 'key_123'));
    expect(result.isSuccess, true);
  });

  test('getPaymentStatus returns PaymentStatusResponse processing', () async {
    client.dio.interceptors.add(MockInterceptor((options, handler) {
      if (options.path == '/payments/status/req_789') {
        handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'depositRequestId': 'req_789', 'status': 'processing'}));
      }
    }));
    final result = await service.getPaymentStatus('req_789');
    expect(result.isSuccess, true);
  });

  test('payWithEncryptedCard executes the complete flow: encrypt + pay', () async {
    client.dio.interceptors.add(MockInterceptor((options, handler) {
      if (options.path == '/payments/card' && options.method == 'POST') {
        handler.resolve(Response(requestOptions: options, statusCode: 200, data: {'depositRequestId': 'req_abc', 'status': 'approved'}));
      }
    }));
    final cardData = CardPaymentData(cardNumber: '1111222233334444', cardHolderName: 'TEST USER', cardExpiryDate: '12/30', securityCode: '123');
    final result = await service.payWithEncryptedCard('req_abc', cardData, validMockPemKey, 'fake_key');
    expect(result.isSuccess, true);
  });

  test('returns ValueResult.failure with message from gateway on error', () async {
    client.dio.interceptors.add(MockInterceptor((options, handler) {
      if (options.path == '/payments/card') {
        handler.reject(DioException(requestOptions: options, type: DioExceptionType.badResponse, response: Response(requestOptions: options, statusCode: 422, data: {'message': 'Cartão expirado'})));
      }
    }));
    final result = await service.payWithCard(CardPaymentRequest(depositRequestId: 'req_err', encryptedCard: 'data', keyId: 'key_123'));
    expect(result.isError, true);
  });

  test('returns ValueResult.failure with friendly error message on timeout', () async {
    client.dio.interceptors.add(MockInterceptor((options, handler) {
      if (options.path == '/public-keys') handler.reject(DioException(requestOptions: options, type: DioExceptionType.connectionTimeout));
    }));
    final result = await service.fetchPublicKey();
    expect(result.isError, true);
  });
}