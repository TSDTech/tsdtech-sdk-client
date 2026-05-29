import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/ui/config/tsdtech_ui_config.dart';
import 'package:tsdtech_client_sdk/src/ui/theme/theme.dart';
// import 'package:tsdtech_client_sdk/main.dart' as example;
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  testWidgets('example app renders core showcase sections', (tester) async {
    TsdtechUiConfig.initialize(
      baseUrl: Constants.getBaseUrl(),
      gatewayBaseUrl: Constants.getBaseUrl(),
      apiKey: 'demo-api-key',
      locale: TsdtechLocale.pt,
      theme: TsdtechThemeData.light(),
    );

    // await tester.pumpWidget(const example.ExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('TSDTech SDK Example'), findsWidgets);
    expect(find.text('Uso básico com CheckoutWidget'), findsOneWidget);
    expect(find.text('Uso de telas com CheckoutScreen'), findsOneWidget);
    expect(find.text('Formulários isolados'), findsOneWidget);
    expect(find.text('Customização de tema'), findsOneWidget);
  });
}
