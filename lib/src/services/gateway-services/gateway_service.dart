import 'package:dio/dio.dart';
import '../../../models/value_result.dart';
import '../../client/gateway-client/gateway_client.dart';
import '../../dto/gateway/public_key_response.dart';
import '../../dto/gateway/card_payment_request.dart';
import '../../dto/gateway/payment_status_response.dart';
import '../../utils/card-utils/card_encryptor.dart';

class GatewayService {
  final GatewayClient _client;

  GatewayService(this._client);

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
      CardPaymentRequest request) async {
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
      String depositRequestId) async {
    try {
      final response =
          await _client.dio.get('/payments/status/$depositRequestId');
      final data = PaymentStatusResponse.fromJson(response.data);
      return ValueResult.success(data);
    } on DioException catch (e) {
      return _parseGatewayError<PaymentStatusResponse>(e);
    } catch (e) {
      return ValueResult.failure(
          'Erro inesperado ao consultar status do pagamento.');
    }
  }

  Future<ValueResult<PaymentStatusResponse>> payWithEncryptedCard(
    String depositRequestId,
    CardPaymentData cardData,
    String pemPublicKey,
    String keyId,
  ) async {
    try {
      final encryptedCard = CardEncryptor.encrypt(cardData, pemPublicKey);

      final request = CardPaymentRequest(
        depositRequestId: depositRequestId,
        encryptedCard: encryptedCard,
        keyId: keyId,
      );

      return await payWithCard(request);
    } catch (e) {
      return ValueResult.failure(
          'Erro inesperado ao criptografar ou processar o pagamento com cartão.');
    }
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
        error.message ?? 'Erro de comunicação com o gateway.');
  }
}