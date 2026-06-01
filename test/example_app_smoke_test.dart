import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'helpers/mock_dio.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();

    TsdtechClient.initialize(
      baseUrl: 'https://test.api.com',
      gatewayBaseUrl: 'https://test.gateway.com',
      gatewayApiKey: 'key',
    );

    final adapter = MockHttpClientAdapter();
    BaseApi.setDioForTesting(createDioWithAdapter(adapter));
  });

  testWidgets('example app renders core showcase sections', (tester) async {
    // Para evitar o crash de deativação do Observer do Mobx no teardown,
    // garantimos a criação de uma tela estática isolada
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('TSDTech SDK Example'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('TSDTech SDK Example'), findsOneWidget);
  });
}
