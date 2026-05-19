import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart'
    hide CardPaymentData;
import 'package:tsdtech_client_sdk/src/client/gateway-client/gateway_client.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/gateway_payment_status.dart';
import 'package:tsdtech_client_sdk/src/services/checkout_orchestrator.dart';
import 'package:tsdtech_client_sdk/src/services/gateway-services/gateway_service.dart';
import 'package:tsdtech_client_sdk/src/utils/card-utils/card_encryptor.dart'
    show CardPaymentData;

import '../../helpers/mock_dio.dart';

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
    expirationMonth: '12',
    expirationYear: '2030',
    cvv: '123',
  );

  final checkoutRequest = CheckoutRequest(
    cart: [],
    paymentMethod: 'card',
    totalValue: 100.0,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();

    checkoutAdapter = MockHttpClientAdapter();
    final checkoutDio = createDioWithAdapter(checkoutAdapter);
    BaseApi.setDioForTesting(checkoutDio);

    gatewayClient = GatewayClient(gatewayBaseUrl: 'http://test-gateway.local');
    gatewayService = GatewayService(gatewayClient);
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
                data: {'keyId': 'key_abc', 'pemPublicKey': 'pem_value'},
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
      expect(result.value!.status, GatewayPaymentStatus.approved);
      expect(result.value!.depositRequestId, 'dep_123');
    });

    test(
      'checkout falha retorna ValueResult.failure com contexto [checkout]',
      () async {
        checkoutAdapter.whenThrow(
          'POST',
          '/checkouts/client',
          DioException(
            requestOptions: RequestOptions(path: '/checkouts/client'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/checkouts/client'),
              statusCode: 422,
              data: {'message': 'Dados inválidos no checkout.'},
            ),
          ),
        );

        final result = await orchestrator.payWithCard(
          checkoutRequest,
          cardData,
        );

        expect(result.isError, true);
        expect(result.error, contains('[checkout]'));
      },
    );

    test('sem depositRequestId retorna "Cart payment not available"', () async {
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'pix',
        'paymentId': 'pix_999',
      });

      final result = await orchestrator.payWithCard(checkoutRequest, cardData);

      expect(result.isError, true);
      expect(result.error, 'Cart payment not available');
    });

    test(
      'fetchPublicKey falha retorna ValueResult.failure com [fetchPublicKey]',
      () async {
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

        final result = await orchestrator.payWithCard(
          checkoutRequest,
          cardData,
        );

        expect(result.isError, true);
        expect(result.error, contains('[fetchPublicKey]'));
      },
    );

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
                  data: {'keyId': 'key_xyz', 'pemPublicKey': 'pem_value'},
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
                data: {'keyId': 'key_err', 'pemPublicKey': 'pem_value'},
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
      checkoutAdapter.when('POST', '/checkouts/client', {
        'paymentMethod': 'pix',
        'paymentId': 'pix_001',
        'pix': {'qrCode': 'qr_code_value', 'copyPasteCode': '00020126...'},
      });

      final request = CheckoutRequest(
        cart: [],
        paymentMethod: 'pix',
        totalValue: 50.0,
      );

      final result = await orchestrator.payWithPix(request);

      expect(result.isSuccess, true);
      expect(result.value!.paymentMethod, 'pix');
      expect(result.value!.paymentId, 'pix_001');
      expect(result.value!.pix, isNotNull);
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
    test('sem gatewayBaseUrl → orchestrator é null', () {
      final client = TsdtechClient();
      expect(client.orchestrator, isNull);
      expect(client.gateway, isNull);
    });

    test('com gatewayBaseUrl → orchestrator não é null', () {
      final client = TsdtechClient(gatewayBaseUrl: 'http://gateway.local');
      expect(client.orchestrator, isNotNull);
      expect(client.gateway, isNotNull);
    });
  });
}
