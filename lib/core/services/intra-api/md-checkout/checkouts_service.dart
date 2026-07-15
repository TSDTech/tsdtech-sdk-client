import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_response.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_response.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/payment_method.model.dart';
import 'package:tsdtech_client_sdk/models/deposit-request/deposit_request_fee.model.dart';
import 'package:tsdtech_client_sdk/models/deposit-request/deposit_request_summary.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/deposit_request.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/payment_status_response.dart';
import 'package:tsdtech_client_sdk/src/models/checkout/deposit_card_response.model.dart';
import 'package:tsdtech_client_sdk/src/models/checkout/deposit_pix_response.model.dart';
import 'package:tsdtech_client_sdk/src/services/gateway-services/gateway_service.dart';

import '../../../../src/ui/checkout/payment_types.dart';

/// Service for handling checkout and payment operations.
///
/// This service provides methods for managing payment methods, calculating
/// cart totals, creating checkouts, and checking PIX payment status.
///
/// ## Usage
/// ```dart
/// final checkoutService = CheckoutsService.instance;
///
/// // Get available payment methods
/// final methods = await checkoutService.getPaymentMethods();
///
/// // Calculate cart total
/// final calculated = await checkoutService.calculateCart(request);
///
/// // Create checkout
/// final result = await checkoutService.createCheckout(checkoutRequest);
/// ```
///
/// ## Singleton Pattern
/// Access the service via [CheckoutsService.instance].
class CheckoutsService extends IntraApi {
  /// Singleton instance of [CheckoutsService].
  static final CheckoutsService instance = CheckoutsService();

  /// Creates a [CheckoutsService] instance with the base URL from [Constants].
  CheckoutsService() : super(Constants.getMsUrl('back-ms-subaccount'));
  final depositRequestPath = '/deposit-request/public';

  // @override
  // String get msAuthorizerUrl => Constants.getMsUrl('back-ms-authorizer');

  /// Retrieves the list of available payment methods for the current user.
  ///
  /// - Returns: [ValueResult] containing a list of [PaymentMethodModel] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await checkoutService.getPaymentMethods();
  /// if (result.isSuccess) {
  ///   for (final method in result.value) {
  ///     print('${method.id}: ${method.name}');
  ///   }
  /// }
  /// ```
  Future<ValueResult<List<PaymentMethodModel>>> getPaymentMethods() async {
    try {
      const path = '/checkouts/client/methods';
      final response = await get(path);
      final data = response.data;
      if (data is List) {
        final list = data
            .map(
              (e) => PaymentMethodModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
        return ValueResult.success(list);
      }
      return ValueResult.success(<PaymentMethodModel>[]);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Calculates the cart total based on the provided [request].
  ///
  /// - [request]: The [CalculateRequest] containing cart items and configuration
  /// - Returns: [ValueResult] containing the [CalculateResponse] with totals
  ///
  /// ## Example
  /// ```dart
  /// final result = await checkoutService.calculateCart(
  ///   CalculateRequest(items: myItems, paymentMethodId: 'card'),
  /// );
  /// ```
  Future<ValueResult<CalculateResponse>> calculateCart(
    CalculateRequest request,
  ) async {
    try {
      const path = '/checkouts/client/calculate';
      final response = await post(path, data: request.toJson());
      final data = response.data as Map<String, dynamic>;
      final result = CalculateResponse.fromJson(data);
      return ValueResult.success(result);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Creates a new checkout with the provided [request].
  ///
  /// This method sends the checkout request to the backend SPA and returns a
  /// `CheckoutResponse`. The response supports multiple payment flows:
  ///
  /// - Card (two-step): the response may include `depositRequestId`. In this
  ///   flow the checkout creation only initiates the deposit; the client must
  ///   complete the card authorization/confirmation using the `GatewayService`
  ///   and the returned `depositRequestId`.
  /// - PIX (one-step): the response will contain `pix` payloads with payment
  ///   instructions that can be consumed immediately.
  ///
  /// Important: gateway-specific logic (fetch key, encrypt, send) lives in
  /// `GatewayService`. Methods here that touch the gateway ([payWithCard],
  /// [getCardPaymentStatus]) are thin delegations only — keep the actual
  /// orchestration in `GatewayService`.
  ///
  /// - [request]: The [CheckoutRequest] containing order details and payment info
  /// - Returns: [ValueResult] containing the [CheckoutResponse] with confirmation
  ///
  /// ## Example
  /// ```dart
  /// final result = await checkoutService.createCheckout(
  ///   CheckoutRequest(items: items, paymentMethodId: 'pix'),
  /// );
  /// if (result.isSuccess) {
  ///   final resp = result.value;
  ///   // Card (two-step): check `resp.depositRequestId` and use GatewayService
  ///   // PIX: check `resp.pix` for payment instructions
  /// }
  /// ```
  Future<ValueResult<CheckoutResponse>> createCheckout(
    CheckoutRequest request,
  ) async {
    try {
      const path = '/checkouts/client';
      final response = await post(path, data: request.toJson());
      final data = response.data as Map<String, dynamic>;
      final result = CheckoutResponse.fromJson(data);
      return ValueResult.success(result);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<CheckoutResponse>> createCheckoutDeposit(
    DepositRequest request,
  ) async {
    try {
      const path = '/checkouts/client';
      final response = await post(path, data: request.toJson());
      final data = response.data as Map<String, dynamic>;
      final result = CheckoutResponse.fromJson(data);
      return ValueResult.success(result);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Processa o pagamento com cartão de um deposit request já criado.
  ///
  /// Delega para o [GatewayService], que executa o fluxo completo:
  /// busca a chave pública, criptografa os dados do cartão e envia o
  /// pagamento. Os dados sensíveis nunca trafegam abertos.
  ///
  /// Requer que o SDK tenha sido inicializado com `gatewayBaseUrl`
  /// (via `TsdtechClient.initialize`), que é quem inicializa o gateway.
  Future<ValueResult<PaymentStatusResponse>> payWithCard({
    required String depositRequestId,
    required CardPaymentData cardData,
    int? installmentNumber,
  }) async {
    try {
      return await GatewayService.instance.payDepositRequest(
        depositRequestId,
        cardData,
        installmentNumber: installmentNumber,
      );
    } catch (e) {
      return ValueResult.failure(
        'Gateway não configurado. Inicialize o SDK com gatewayBaseUrl.',
      );
    }
  }

  /// Consulta o status do pagamento com cartão de um deposit request.
  ///
  /// Delega para o [GatewayService].
  Future<ValueResult<PaymentStatusResponse>> getCardPaymentStatus(
    String depositRequestId,
  ) async {
    try {
      return await GatewayService.instance.getPaymentStatus(depositRequestId);
    } catch (e) {
      return ValueResult.failure(
        'Gateway não configurado. Inicialize o SDK com gatewayBaseUrl.',
      );
    }
  }

  /// Converte um deposit request já criado para pagamento com cartão.
  ///
  /// Espelha o fluxo do PIX ([createDepositPix]): recebe o [depositRequestId]
  /// e retorna um [DepositCardResponse] com o intent de pagamento criado.
  /// O pagamento em si (criptografia + envio) acontece depois via
  /// [payWithCard], que delega ao `GatewayService`.
  Future<ValueResult<DepositCardResponse>> createDepositCard(
    String depositRequestId,
  ) async {
    try {
      final path = '$depositRequestPath/$depositRequestId/convert-to-card';
      final response = await post(path);
      final data = response.data as Map<String, dynamic>;
      final result = DepositCardResponse.fromJson(data);
      return ValueResult.success(result);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<DepositPixResponse>> createDepositPix(
    String depositRequestId,
  ) async {
    try {
      final path = '$depositRequestPath/$depositRequestId/convert-to-pix';
      final response = await post(path);
      final mockData = response.data as Map<String, dynamic>;

      // 3. Converte o map pro seu objeto CheckoutResponse exatamente como antes
      final result = DepositPixResponse.fromJson(mockData);

      // 4. Retorna o sucesso mockado!
      return ValueResult.success(result);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Retrieves the status of a PIX payment by its [depositRequestId].
  ///
  /// - [depositRequestId]: The unique identifier of the payment
  /// - Returns: [ValueResult] containing the status string (e.g., 'pending', 'completed')
  ///
  /// ## Example
  /// ```dart
  /// final status = await checkoutService.getPixStatus(paymentId);
  /// if (status.isSuccess) {
  ///   print('PIX Status: ${status.value}');
  /// }
  /// ```
  Future<ValueResult<String>> getPixStatus(String depositRequestId) async {
    try {
      final path = '$depositRequestPath/status-pix/$depositRequestId';
      final response = await get(path);
      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String? ?? '';
      return ValueResult.success(status);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<DepositRequestSummaryResponse>> getOrderSummary(
    String depositRequestId,
  ) async {
    try {
      final path = '$depositRequestPath/$depositRequestId/summary';
      final response = await get(path);
      final data = response.data as Map<String, dynamic>;
      final summaryResponse = DepositRequestSummaryResponse.fromJson(data);
      return ValueResult.success(summaryResponse);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<DepositRequestFeeResponse>> getDepositRequestFee(
    String depositRequestId,
    PaymentMethodType selectedMethod,
  ) async {
    try {
      const path = 'fee-config/public';
      final queryParams = {
        'depositRequestId': depositRequestId,
        'paymentMethod': selectedMethod.name.toUpperCase(),
      };
      final response = await get(path, queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final feeResponse = DepositRequestFeeResponse.fromJson(data);
      return ValueResult.success(feeResponse);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<String>> notifyPixExpired(String depositRequestId) async {
    try {
      final path = '$depositRequestPath/$depositRequestId/expire';
      final response = await post(path);
      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String? ?? '';
      return ValueResult.success(status);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
