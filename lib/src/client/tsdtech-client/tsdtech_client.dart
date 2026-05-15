import '../gateway-client/gateway_client.dart';
import '../../services/gateway-services/gateway_service.dart';

class TsdtechClient {
  GatewayService? gateway;

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
    }
  }
}
