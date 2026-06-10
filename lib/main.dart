import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/app.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/src/ui/theme/demo_theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa as configs de tema
  DemoThemeConfig.configure(DemoThemePreset.brand);

  TsdtechClient.initialize(
    baseUrl: 'https://api.tsdtech.com.br',
    gatewayBaseUrl: 'https://api.seugateway.com.br',
    gatewayApiKey: 'sua-api-key-se-tiver',
    stage: Environment
        .hml, // Ou Environment.dev ou Environment.prod dependendo do ambiente que quiser usar
  );

  runApp(const TsdtechApp());
}
