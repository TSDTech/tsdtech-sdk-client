import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

import '../gateway-client/gateway_client.dart';
import '../../services/gateway-services/gateway_service.dart';
import '../../services/checkout_orchestrator.dart';
import '../../../core/services/intra-api/md-checkout/checkouts_service.dart';

class TsdtechClient {
  static TsdtechClient? _instance;

  GatewayService? gateway;
  CheckoutOrchestrator? orchestrator;
  Environment? stage;

  // Construtor privado
  TsdtechClient._({
    String? gatewayBaseUrl,
    String? gatewayApiKey,
    Environment? stage,
  }) {
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

  // Método para inicializar o SDK (Vamos chamar no main)
  static void initialize({
    required String baseUrl, // Obrigatório para a API principal
    String? gatewayBaseUrl,
    String? gatewayApiKey,
    TsdtechThemeData? theme, // Opcional para quem quiser customizar a UI
    TsdtechLocale locale = TsdtechLocale.pt,
    Environment?
    stage, // Opcional para quem quiser setar o stage (dev, hml, prod)
  }) {
    TsdtechUiConfig.initialize(
      baseUrl: baseUrl,
      gatewayBaseUrl: gatewayBaseUrl,
      apiKey: gatewayApiKey,
      theme: theme,
      locale: locale,
      stage:
          stage ??
          Constants.getStage(), // Usa o stage do argumento ou o default do Constants
    );

    _instance ??= TsdtechClient._(
      gatewayBaseUrl: gatewayBaseUrl,
      gatewayApiKey: gatewayApiKey,
      stage: stage ?? Constants.getStage(),
    );

    Constants.setStage(stage ?? Constants.getStage());
  }

  // Pegar a instância pronta em qualquer lugar do app
  static TsdtechClient get instance {
    if (_instance == null) {
      throw Exception(
        'TsdtechClient não foi inicializado! Chame TsdtechClient.initialize() no main.dart.',
      );
    }
    return _instance!;
  }
}
