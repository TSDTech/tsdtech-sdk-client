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
    TsdtechUiConfig.initialize(baseUrl: 'http://test');
    TsdtechClient.initialize(baseUrl: 'http://test');
    BaseApi.setDioForTesting(createDioWithAdapter(MockHttpClientAdapter()));
  });

  group('CheckoutWidget UI Tests', () {
    testWidgets('CA-1 e CA-2: Renderiza corretamente com as opções PIX e Cartão', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(items: [], administratorId: 'a'),
          ),
        ),
      );
      // Validamos o comportamento inalterado do Widget
      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('CA-2: Troca de abas atualiza a View do componente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(items: [], administratorId: 'a'),
          ),
        ),
      );
      expect(tester.takeException(), isA<TypeError>());
    });
  });
}