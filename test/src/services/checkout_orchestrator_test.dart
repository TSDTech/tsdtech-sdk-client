import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart'
    show CardPaymentData, CheckoutRequest;
import 'package:tsdtech_client_sdk/src/client/gateway-client/gateway_client.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/gateway_payment_status.dart';
import 'package:tsdtech_client_sdk/src/models/checkout/deposit_pix_response.model.dart';
import 'package:tsdtech_client_sdk/src/services/checkout_orchestrator.dart';
import 'package:tsdtech_client_sdk/src/services/gateway-services/gateway_service.dart';

import '../../helpers/mock_dio.dart';

const validMockPemKey = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtt1U5UFmzDjj7gapJsmm
bYtbyidVOPtj4WoyMnTaNL4EzwbunYI2oQWcxXR8H/e0f96eVHBa7w1Oq5l/IrcV
mpljD8AQqubMD9qN3D8m4CO2nENkoBQK7KP3+M1PqekqIRrIxWzGwSJPn0bSfRb/
E23qCA3Piha+u6ehKFcOs9zkO3tTfwEU3UwxYQCjrbBGDVWe+bOea6ieDjUV/P/J
ErpDWPDHh5/7bseus0lVJZkvqmoeT4ec98M3vxDpAc1N2ZGQE+5ou+i6gvJl8AMA
64n4gkOmYCWKXtcXQj4XtI6ZufN8FH/gPtgYglkB0TS9KXEcU+NTwdv5WGADYAZb
GQIDAQAB
-----END PUBLIC KEY-----''';

class MockGatewayInterceptor extends Interceptor {
  final void Function(RequestOptions options, RequestInterceptorHandler handler)
  onRequestHandler;
  MockGatewayInterceptor(this.onRequestHandler);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestHandler(options, handler);
  }
}

void main() {
  late MockHttpClientAdapter checkoutAdapter;
  late GatewayClient gatewayClient;
  late GatewayService gatewayService;
  late CheckoutsService checkoutService;
  late CheckoutOrchestrator orchestrator;

  final cardData = CardPaymentData(
    cardNumber: '4111111111111111',
    cardHolderName: 'JOHN DOE',
    cardExpiryDate: '12/30',
    securityCode: '123',
  );
  final checkoutRequest = CheckoutRequest(
    cart: [],
    paymentMethod: 'card',
    totalValue: 100.0,
  );

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();
    gatewayClient = GatewayClient(gatewayBaseUrl: 'http://test-gateway.local');
    GatewayService.init(gatewayClient);
    TsdtechClient.initialize(
      baseUrl: 'http://api.local',
      gatewayBaseUrl: 'https://gateway',
    );
  });

  setUp(() {
    checkoutAdapter = MockHttpClientAdapter();
    BaseApi.setDioForTesting(createDioWithAdapter(checkoutAdapter));
    gatewayClient.dio.interceptors.clear();
    gatewayService = GatewayService.instance;
    checkoutService = CheckoutsService();

    orchestrator = CheckoutOrchestrator(
      checkoutService: checkoutService,
      gatewayService: gatewayService,
    );
  });

  group('CheckoutOrchestrator.payWithCard()', () {
    test('fluxo completo retorna PaymentStatusResponse approved', () async {
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'card',
        'depositRequestId': 'dep_123',
      });
      gatewayClient.dio.interceptors.add(
        MockGatewayInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'keyId': 'key_abc',
                  'pemPublicKey': '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtt1U5UFmzDjj7gapJsmm
bYtbyidVOPtj4WoyMnTaNL4EzwbunYI2oQWcxXR8H/e0f96eVHBa7w1Oq5l/IrcV
mpljD8AQqubMD9qN3D8m4CO2nENkoBQK7KP3+M1PqekqIRrIxWzGwSJPn0bSfRb/
E23qCA3Piha+u6ehKFcOs9zkO3tTfwEU3UwxYQCjrbBGDVWe+bOea6ieDjUV/P/J
ErpDWPDHh5/7bseus0lVJZkvqmoeT4ec98M3vxDpAc1N2ZGQE+5ou+i6gvJl8AMA
64n4gkOmYCWKXtcXQj4XtI6ZufN8FH/gPtgYglkB0TS9KXEcU+NTwdv5WGADYAZb
GQIDAQAB
-----END PUBLIC KEY-----''',
                },
              ),
            );
          } else if (options.path == '/payments/card') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'depositRequestId': 'dep_123', 'status': 'approved'},
              ),
            );
          }
        }),
      );
      final result = await orchestrator.payWithCard(checkoutRequest, cardData);
      expect(result.isSuccess, true);
    });

    test(
      'checkout falha retorna ValueResult.failure com contexto [checkout]',
      () async {
        checkoutAdapter.whenThrow(
          'POST',
          '/checkouts/client',
          DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: 422,
              data: {'message': 'err'},
            ),
          ),
        );
        final result = await orchestrator.payWithCard(
          checkoutRequest,
          cardData,
        );
        expect(result.isError, true);
      },
    );

    test('sem depositRequestId retorna "Cart payment not available"', () async {
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'pix',
      });
      final result = await orchestrator.payWithCard(checkoutRequest, cardData);
      expect(result.isError, true);
    });

    test('fetchPublicKey falha retorna ValueResult.failure', () async {
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'card',
        'depositRequestId': 'dep_456',
      });
      gatewayClient.dio.interceptors.add(
        MockGatewayInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionTimeout,
              ),
            );
          }
        }),
      );
      final result = await orchestrator.payWithCard(checkoutRequest, cardData);
      expect(result.isError, true);
    });

    test(
      'pagamento declinado retorna PaymentStatusResponse declined',
      () async {
        checkoutAdapter.when('POST', '/checkouts/client', {
          'paymentMethod': 'card',
          'depositRequestId': 'dep_789',
        });
        gatewayClient.dio.interceptors.add(
          MockGatewayInterceptor((options, handler) {
            if (options.path == '/public-keys') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'keyId': 'key_xyz',
                    'pemPublicKey': '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtt1U5UFmzDjj7gapJsmm
bYtbyidVOPtj4WoyMnTaNL4EzwbunYI2oQWcxXR8H/e0f96eVHBa7w1Oq5l/IrcV
mpljD8AQqubMD9qN3D8m4CO2nENkoBQK7KP3+M1PqekqIRrIxWzGwSJPn0bSfRb/
E23qCA3Piha+u6ehKFcOs9zkO3tTfwEU3UwxYQCjrbBGDVWe+bOea6ieDjUV/P/J
ErpDWPDHh5/7bseus0lVJZkvqmoeT4ec98M3vxDpAc1N2ZGQE+5ou+i6gvJl8AMA
64n4gkOmYCWKXtcXQj4XtI6ZufN8FH/gPtgYglkB0TS9KXEcU+NTwdv5WGADYAZb
GQIDAQAB
-----END PUBLIC KEY-----''',
                  },
                ),
              );
            } else if (options.path == '/payments/card') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'depositRequestId': 'dep_789', 'status': 'declined'},
                ),
              );
            }
          }),
        );
        final result = await orchestrator.payWithCard(
          checkoutRequest,
          cardData,
        );
        expect(result.isSuccess, true);
        expect(result.value!.status, GatewayPaymentStatus.declined);
      },
    );

    test('payWithEncryptedCard falha retorna [payWithEncryptedCard]', () async {
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'card',
        'depositRequestId': 'dep_err',
      });

      gatewayClient.dio.interceptors.add(
        MockGatewayInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'keyId': 'key_err',
                  'pemPublicKey': '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtt1U5UFmzDjj7gapJsmm
bYtbyidVOPtj4WoyMnTaNL4EzwbunYI2oQWcxXR8H/e0f96eVHBa7w1Oq5l/IrcV
mpljD8AQqubMD9qN3D8m4CO2nENkoBQK7KP3+M1PqekqIRrIxWzGwSJPn0bSfRb/
E23qCA3Piha+u6ehKFcOs9zkO3tTfwEU3UwxYQCjrbBGDVWe+bOea6ieDjUV/P/J
ErpDWPDHh5/7bseus0lVJZkvqmoeT4ec98M3vxDpAc1N2ZGQE+5ou+i6gvJl8AMA
64n4gkOmYCWKXtcXQj4XtI6ZufN8FH/gPtgYglkB0TS9KXEcU+NTwdv5WGADYAZb
GQIDAQAB
-----END PUBLIC KEY-----''',
                },
              ),
            );
          } else if (options.path == '/payments/card') {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 402,
                  data: {'message': 'Saldo insuficiente.'},
                ),
              ),
            );
          }
        }),
      );

      final result = await orchestrator.payWithCard(checkoutRequest, cardData);

      expect(result.isError, true);
      expect(result.error, contains('[payWithEncryptedCard]'));
    });
  });

  group('CheckoutOrchestrator.payWithPix()', () {
    test('retorna CheckoutResponse com pix data', () async {
      checkoutAdapter
          .when('POST', '/deposit-request/public/dep_123/convert-to-pix', {
            'id': 'pix_001',
            'paymentMethod': 'pix',
            'status': 'pending',
            'textQrCode': '00020126...',
            'pixPaymentIntentId': 'pix_001',
          });

      const depositRequestId = 'dep_123';

      final result = await orchestrator.payWithPix(depositRequestId);

      expect(result.isSuccess, true);
      expect(result.value!.paymentMethod, 'pix');
      expect(result.value!.pixPaymentIntentId, 'pix_001');
      expect(result.value!.id, 'pix_001');
    });
  });

  group('CheckoutOrchestrator.payWithBill()', () {
    test('retorna CheckoutResponse com bill data', () async {
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'bill',
        'paymentId': 'bill_001',
        'status': 'pending',
      });
      final request = CheckoutRequest(
        cart: [],
        paymentMethod: 'bill',
        totalValue: 75.0,
      );
      final result = await orchestrator.payWithBill(request);
      expect(result.isSuccess, true);
      expect(result.value!.paymentMethod, 'bill');
      expect(result.value!.paymentId, 'bill_001');
    });
  });

  group('TsdtechClient', () {
    test('initialize cria a instância corretamente com os serviços', () {
      // Usamos a nova sintaxe do Singleton que refatoramos
      TsdtechClient.initialize(
        baseUrl: 'http://api.local',
        gatewayBaseUrl: 'http://gateway.local',
      );
      final client = TsdtechClient.instance;

      expect(client.orchestrator, isNotNull);
      expect(client.gateway, isNotNull);
    });
  });
}
