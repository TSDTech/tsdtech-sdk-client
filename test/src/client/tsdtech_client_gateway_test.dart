import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/src/client/gateway-client/gateway_client.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/gateway_payment_status.dart';
import 'package:tsdtech_client_sdk/src/services/gateway-services/gateway_service.dart';

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
  final void Function(RequestOptions options, RequestInterceptorHandler handler)
  onRequestHandler;
  MockInterceptor(this.onRequestHandler);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestHandler(options, handler);
  }
}

CardPaymentData buildCardData() => CardPaymentData(
  cardNumber: '1111222233334444',
  cardHolderName: 'TEST USER',
  cardExpiryDate: '12/30',
  securityCode: '123',
);

void main() {
  late GatewayClient gatewayClient;
  late TsdtechClient client;

  setUpAll(() {
    TsdtechClient.initialize(
      baseUrl: 'http://api.local',
      gatewayBaseUrl: 'http://test-gateway.local',
      gatewayApiKey: 'secret_key',
    );
  });

  setUp(() {
    gatewayClient = GatewayClient(gatewayBaseUrl: 'http://test-gateway.local');
    client = TsdtechClient.instance;
    // Injeta um GatewayService com client mockável para isolar as chamadas HTTP
    client.gateway = GatewayService(gatewayClient);
  });

  group('payWithCard', () {
    test('executa o fluxo completo: fetch key + encrypt + pay', () async {
      String? sentEncryptedCard;
      int? sentInstallmentNumber;

      gatewayClient.dio.interceptors.add(
        MockInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'keyId': 'key_123', 'pemPublicKey': validMockPemKey},
              ),
            );
          } else if (options.path == '/payments/card' &&
              options.method == 'POST') {
            sentEncryptedCard = options.data['encryptedCard'] as String?;
            sentInstallmentNumber = options.data['installmentNumber'] as int?;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'depositRequestId': 'req_123', 'status': 'approved'},
              ),
            );
          }
        }),
      );

      final result = await client.payWithCard(
        depositRequestId: 'req_123',
        cardData: buildCardData(),
        installmentNumber: 3,
      );

      expect(result.isSuccess, true);
      expect(result.value?.status, GatewayPaymentStatus.approved);
      expect(result.value?.depositRequestId, 'req_123');
      expect(sentEncryptedCard, isNotNull);
      expect(sentEncryptedCard!.isNotEmpty, isTrue);
      expect(sentInstallmentNumber, 3);
    });

    test('retorna failure quando o fetch da chave pública falha', () async {
      gatewayClient.dio.interceptors.add(
        MockInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 500,
                  data: {'message': 'Falha ao gerar chave'},
                ),
              ),
            );
          } else {
            fail('Não deveria chamar ${options.path} após falha na chave');
          }
        }),
      );

      final result = await client.payWithCard(
        depositRequestId: 'req_123',
        cardData: buildCardData(),
      );

      expect(result.isError, true);
      expect(result.error, contains('[fetchPublicKey]'));
    });

    test('retorna failure quando a criptografia falha (PEM inválido)', () async {
      gatewayClient.dio.interceptors.add(
        MockInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'keyId': 'key_123', 'pemPublicKey': 'not-a-pem-key'},
              ),
            );
          } else {
            fail(
              'Não deveria chamar ${options.path} após falha na criptografia',
            );
          }
        }),
      );

      final result = await client.payWithCard(
        depositRequestId: 'req_123',
        cardData: buildCardData(),
      );

      expect(result.isError, true);
    });

    test('retorna failure quando o envio do pagamento falha', () async {
      gatewayClient.dio.interceptors.add(
        MockInterceptor((options, handler) {
          if (options.path == '/public-keys') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'keyId': 'key_123', 'pemPublicKey': validMockPemKey},
              ),
            );
          } else if (options.path == '/payments/card') {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 422,
                  data: {'message': 'Cartão expirado'},
                ),
              ),
            );
          }
        }),
      );

      final result = await client.payWithCard(
        depositRequestId: 'req_123',
        cardData: buildCardData(),
      );

      expect(result.isError, true);
      expect(result.error, 'Cartão expirado');
    });

    test('retorna failure quando o gateway não está configurado', () async {
      client.gateway = null;

      final result = await client.payWithCard(
        depositRequestId: 'req_123',
        cardData: buildCardData(),
      );

      expect(result.isError, true);
      expect(result.error, contains('Gateway não configurado'));
    });
  });

  group('getCardPaymentStatus', () {
    test('retorna o status do pagamento com sucesso', () async {
      gatewayClient.dio.interceptors.add(
        MockInterceptor((options, handler) {
          if (options.path == '/payments/status/req_789') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'depositRequestId': 'req_789', 'status': 'processing'},
              ),
            );
          }
        }),
      );

      final result = await client.getCardPaymentStatus('req_789');

      expect(result.isSuccess, true);
      expect(result.value?.status, GatewayPaymentStatus.processing);
      expect(result.value?.depositRequestId, 'req_789');
    });

    test('retorna failure quando a consulta de status falha', () async {
      gatewayClient.dio.interceptors.add(
        MockInterceptor((options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 404,
                data: {'message': 'Pagamento não encontrado'},
              ),
            ),
          );
        }),
      );

      final result = await client.getCardPaymentStatus('req_missing');

      expect(result.isError, true);
      expect(result.error, 'Pagamento não encontrado');
    });
  });
}
