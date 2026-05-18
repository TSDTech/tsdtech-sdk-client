import '../gateway-client/gateway_client.dart';
import '../../services/gateway-services/gateway_service.dart';
import '../../services/checkout_orchestrator.dart';
import '../../../core/services/intra-api/md-checkout/checkouts_service.dart';

class TsdtechClient {
  GatewayService? gateway;
  CheckoutOrchestrator? orchestrator;

  TsdtechClient({
    String? gatewayBaseUrl,
    String? gatewayApiKey,
  }) {
    if (gatewayBaseUrl != null && gatewayBaseUrl.isNotEmpty) {
      final gatewayClient = GatewayClient(
        gatewayBaseUrl: gatewayBaseUrl,
        apiKey: gatewayApiKey,
      );
      gateway = GatewayService(gatewayClient);
      orchestrator = CheckoutOrchestrator(
        checkoutService: CheckoutsService.instance,
        gatewayService: gateway!,
      );
    }
  }
}
