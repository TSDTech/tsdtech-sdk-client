import '../../models/value_result.dart';
import '../../models/checkouts/checkout_request.model.dart'
    hide CardPaymentData;
import '../../models/checkouts/checkout_response.model.dart';
import '../../core/services/intra-api/md-checkout/checkouts_service.dart';
import '../dto/gateway/payment_status_response.dart';
import '../utils/card-utils/card_encryptor.dart' show CardPaymentData;
import 'gateway-services/gateway_service.dart';

/// Orchestrates the full card payment flow: checkout → fetch public key → encrypt → pay.
///
/// Consumers of the SDK should use this class instead of manually chaining
/// [CheckoutsService] and [GatewayService] calls.
///
/// ## Usage
/// ```dart
/// final orchestrator = CheckoutOrchestrator(
///   checkoutService: CheckoutsService.instance,
///   gatewayService: client.gateway!,
/// );
///
/// final result = await orchestrator.payWithCard(request, cardData);
/// if (result.isSuccess) {
///   print('Status: ${result.value!.status}');
/// }
/// ```
class CheckoutOrchestrator {
  final CheckoutsService _checkoutService;
  final GatewayService _gatewayService;

  CheckoutOrchestrator({
    required CheckoutsService checkoutService,
    required GatewayService gatewayService,
  }) : _checkoutService = checkoutService,
       _gatewayService = gatewayService;

  /// Executes the full two-step card payment flow.
  ///
  /// Steps:
  /// 1. [CheckoutsService.createCheckout] — creates deposit request in the back-end
  /// 2. Validates that [CheckoutResponse.depositRequestId] is present
  /// 3. [GatewayService.fetchPublicKey] — fetches RSA public key from the gateway
  /// 4. [GatewayService.payWithEncryptedCard] — encrypts card data and submits payment
  ///
  /// Returns [ValueResult.failure] with a contextual message if any step fails.
  Future<ValueResult<PaymentStatusResponse>> payWithCard(
    CheckoutRequest request,
    CardPaymentData cardData,
  ) async {
    // Step 1: create checkout
    final checkoutResult = await _checkoutService.createCheckout(request);
    if (checkoutResult.isError) {
      return ValueResult.failure(
        '[checkout] ${checkoutResult.error}',
        title: checkoutResult.title,
      );
    }

    final checkoutResponse = checkoutResult.value!;

    // Step 2: validate depositRequestId
    if (checkoutResponse.depositRequestId == null ||
        checkoutResponse.depositRequestId!.isEmpty) {
      return ValueResult.failure('Cart payment not available');
    }

    // Step 3: fetch public key
    final keyResult = await _gatewayService.fetchPublicKey();
    if (keyResult.isError) {
      return ValueResult.failure(
        '[fetchPublicKey] ${keyResult.error}',
        title: keyResult.title,
      );
    }

    final publicKey = keyResult.value!;

    // Step 4: encrypt and pay
    final payResult = await _gatewayService.payWithEncryptedCard(
      checkoutResponse.depositRequestId!,
      cardData,
      publicKey.pemPublicKey,
      publicKey.keyId,
    );
    if (payResult.isError) {
      return ValueResult.failure(
        '[payWithEncryptedCard] ${payResult.error}',
        title: payResult.title,
      );
    }

    return payResult;
  }

  /// Convenience method for PIX payments (one-step flow).
  ///
  /// Delegates directly to [CheckoutsService.createCheckout]. The gateway is
  /// not involved — the response will contain a [CheckoutResponse.pix] payload.
  Future<ValueResult<CheckoutResponse>> payWithPix(
    CheckoutRequest request,
  ) async {
    return _checkoutService.createCheckout(request);
  }

  /// Convenience method for bill (boleto) payments (one-step flow).
  ///
  /// Delegates directly to [CheckoutsService.createCheckout]. The gateway is
  /// not involved — the response will contain a [CheckoutResponse.bill] payload.
  Future<ValueResult<CheckoutResponse>> payWithBill(
    CheckoutRequest request,
  ) async {
    return _checkoutService.createCheckout(request);
  }
}
