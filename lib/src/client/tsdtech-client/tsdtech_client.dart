import '../gateway-client/gateway_client.dart';
import '../../services/gateway-services/gateway_service.dart';
import '../../services/checkout_orchestrator.dart';
import '../../../core/services/intra-api/md-checkout/checkouts_service.dart';

class TsdtechClient {
  static TsdtechClient? _instance;

  GatewayService? gateway;
  CheckoutOrchestrator? orchestrator;

  // Construtor privado
  TsdtechClient._({required String gatewayBaseUrl, String? gatewayApiKey}) {
    if (gatewayBaseUrl.isNotEmpty) {
      final gatewayClient = GatewayClient(
        gatewayBaseUrl: gatewayBaseUrl,
        apiKey: gatewayApiKey,
      );
      
      // Inicializa o Gateway
      GatewayService.init(gatewayClient);
      gateway = GatewayService.instance;
      
      // Cria o orquestrador e deixa salvo aqui
      orchestrator = CheckoutOrchestrator(
        checkoutService: CheckoutsService.instance,
        gatewayService: gateway!,
      );
    }
  }

  // Método para inicializar o SDK (Vamos chamar no main)
  static void initialize({required String gatewayBaseUrl, String? gatewayApiKey}) {
    _instance ??= TsdtechClient._(
      gatewayBaseUrl: gatewayBaseUrl, 
      gatewayApiKey: gatewayApiKey,
    );
  }

  // Pegar a instância pronta em qualquer lugar do app
  static TsdtechClient get instance {
    if (_instance == null) {
      throw Exception('TsdtechClient não foi inicializado! Chame TsdtechClient.initialize() no main.dart.');
    }
    return _instance!;
  }
}