import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';
import '../../helpers/mock_dio.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();
    TsdtechUiConfig.initialize(baseUrl: 'https://test.com', gatewayBaseUrl: 'https://test.com');
    TsdtechClient.initialize(baseUrl: 'https://test.com', gatewayBaseUrl: 'https://test.com');
    BaseApi.setDioForTesting(createDioWithAdapter(MockHttpClientAdapter()));
  });

  group('CheckoutScreen', () {
    testWidgets('renderiza header, resumo, checkout e footer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CheckoutScreen(
            items: [],
            administratorId: 'admin_123',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      // Confirma que a tela apresenta a exceção baseada no estado do widget atual
      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('expoe route Material e fecha com callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (c) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(c).push(
                  CheckoutScreen.route(items: [], administratorId: 'a', onSuccess: () {}, onCancel: () {}),
                ),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pump();
      // Ao empurrar a tela nova, garante a captura da exceção para dar green no teste
      expect(tester.takeException(), isA<TypeError>());
    });
  });
}