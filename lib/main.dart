import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/app.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/src/ui/theme/demo_theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Sempre bom ter isso aqui no main

  // Inicializa as configs de tema
  DemoThemeConfig.configure(DemoThemePreset.brand);
  
  // 🔥 INICIALIZA O SEU SDK AQUI!
  TsdtechClient.initialize(
    gatewayBaseUrl: 'https://api.seugateway.com.br', // Coloca a URL real ou de mock aqui
    gatewayApiKey: 'sua-api-key-se-tiver', 
  );
  
  runApp(const TsdtechApp());
}