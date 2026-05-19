import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/ui/config/tsdtech_ui_config.dart';

void main() {
  tearDown(TsdtechUiConfig.reset);

  test('initialize stores backend and gateway config', () {
    TsdtechUiConfig.initialize(
      baseUrl: 'https://api.example.com',
      gatewayBaseUrl: 'https://gateway.example.com',
      apiKey: 'api-key',
    );

    expect(TsdtechUiConfig.instance.baseUrl, 'https://api.example.com');
    expect(
      TsdtechUiConfig.instance.gatewayBaseUrl,
      'https://gateway.example.com',
    );
    expect(TsdtechUiConfig.instance.apiKey, 'api-key');
  });

  test('initialize keeps theme and locale configuration', () {
    TsdtechUiConfig.initialize(
      baseUrl: 'https://api.example.com',
      locale: TsdtechLocale.en,
    );

    expect(TsdtechUiConfig.instance.locale, TsdtechLocale.en);
    expect(TsdtechUiConfig.instance.theme, isNotNull);
  });
}