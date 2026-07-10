import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/src/crypto/card_encryptor.dart';
import '../../../models/value_result.dart';
import '../../client/gateway-client/gateway_client.dart';
import '../../dto/gateway/public_key_response.dart';
import '../../dto/gateway/card_payment_request.dart';
import '../../dto/gateway/payment_status_response.dart';

/// Serviço responsável por orquestrar chamadas de pagamento com o Gateway.
class GatewayService {
  final GatewayClient _client;

  GatewayService._(this._client);
  GatewayService(this._client);

  static GatewayService? _instance;

  // 3. Getter público para você chamar 'GatewayService.instance' em qualquer lugar
  static GatewayService get instance {
    if (_instance == null) {
      throw Exception(
        'GatewayService não foi inicializado! Chame GatewayService.init() primeiro.',
      );
    }
    return _instance!;
  }

  // 4. Método para inicializar o Singleton passando o Client
  static void init(GatewayClient client) {
    _instance ??= GatewayService._(client);
  }

  Future<ValueResult<PublicKeyResponse>> fetchPublicKey() async {
    try {
      final response = await _client.dio.get('/public-keys');
      final data = PublicKeyResponse.fromJson(response.data);
      return ValueResult.success(data);
    } on DioException catch (e) {
      return _parseGatewayError<PublicKeyResponse>(e);
    } catch (e) {
      return ValueResult.failure('Erro inesperado ao buscar chave pública.');
    }
  }

  Future<ValueResult<PaymentStatusResponse>> payWithCard(
    CardPaymentRequest request,
  ) async {
    try {
      final response = await _client.dio.post(
        '/payments/card',
        data: request.toJson(),
      );
      final data = PaymentStatusResponse.fromJson(response.data);
      return ValueResult.success(data);
    } on DioException catch (e) {
      return _parseGatewayError<PaymentStatusResponse>(e);
    } catch (e) {
      return ValueResult.failure('Erro inesperado ao processar pagamento.');
    }
  }

  Future<ValueResult<PaymentStatusResponse>> getPaymentStatus(
    String depositRequestId,
  ) async {
    try {
      final response = await _client.dio.get(
        '/payments/status/$depositRequestId',
      );
      final data = PaymentStatusResponse.fromJson(response.data);
      return ValueResult.success(data);
    } on DioException catch (e) {
      return _parseGatewayError<PaymentStatusResponse>(e);
    } catch (e) {
      return ValueResult.failure(
        'Erro inesperado ao consultar status do pagamento.',
      );
    }
  }

  Future<ValueResult<PaymentStatusResponse>> payWithEncryptedCard(
    String depositRequestId,
    CardPaymentData cardData,
    String pemPublicKey,
    String keyId, {
    int? installmentNumber,
  }) async {
    try {
      final encryptedCard = CardEncryptor.encrypt(pemPublicKey, cardData);

      final request = CardPaymentRequest(
        depositRequestId: depositRequestId,
        encryptedCard: encryptedCard,
        keyId: keyId,
        installmentNumber: installmentNumber,
      );

      return await payWithCard(request);
    } catch (e) {
      return ValueResult.failure(
        'Erro inesperado ao criptografar ou processar o pagamento com cartão.',
      );
    }
  }

  /// Executa o fluxo completo de pagamento com cartão para um deposit request
  /// já existente: busca a chave pública, criptografa os dados do cartão e
  /// envia o pagamento (steps 5-7 do fluxo do gateway).
  Future<ValueResult<PaymentStatusResponse>> payDepositRequest(
    String depositRequestId,
    CardPaymentData cardData, {
    int? installmentNumber,
  }) async {
    final keyResult = await fetchPublicKey();
    if (keyResult.isError) {
      return ValueResult.failure(
        '[fetchPublicKey] ${keyResult.error}',
        title: keyResult.title,
      );
    }

    final publicKey = keyResult.value!;

    return payWithEncryptedCard(
      depositRequestId,
      cardData,
      publicKey.pemPublicKey,
      publicKey.keyId,
      installmentNumber: installmentNumber,
    );
  }

  ValueResult<T> _parseGatewayError<T>(DioException error) {
    try {
      final data = error.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        final message =
            data['message'] ?? data['error'] ?? 'Erro no gateway de pagamento.';
        return ValueResult.failure(message.toString());
      }
    } catch (_) {}

    return ValueResult.failure(
      error.message ?? 'Erro de comunicação com o gateway.',
    );
  }
}
