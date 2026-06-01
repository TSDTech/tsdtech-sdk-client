import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/app.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  TsdtechClient.initialize(
    baseUrl: 'https://api.tsdtech.com.br',
    gatewayBaseUrl: 'https://gateway.tsdtech.com.br',
    gatewayApiKey: 'sua-api-key-aqui',
    theme: TsdtechThemeData.light(),
  );

  runApp(const TsdtechApp());
}
