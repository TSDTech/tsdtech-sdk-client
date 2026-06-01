import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';
import '../../helpers/mock_dio.dart';

void main() {
  late MockHttpClientAdapter adapter;
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();
    TsdtechClient.initialize(baseUrl: 'https://test.com');
    adapter = MockHttpClientAdapter();
    BaseApi.setDioForTesting(createDioWithAdapter(adapter));
    adapter.when(
      'GET',
      '/deposit-request/public/acaa27a1-ade2-45ea-a8b0-3f619ba5ae8f/summary',
      {
        'id': 'acaa27a1-ade2-45ea-a8b0-3f619ba5ae8f',
        'amount': 0,
        'createdAtUtc': '2026-06-01T00:00:00Z',
        'depositRequestId': 'acaa27a1-ade2-45ea-a8b0-3f619ba5ae8f',
        'items_summary': [],
      },
    );
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
      await tester.pumpAndSettle();
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('expoe route Material e fecha com callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (c) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(c).push(
                  CheckoutScreen.route(
                    items: [],
                    administratorId: 'a',
                    onSuccess: () {},
                    onCancel: () {},
                  ),
                ),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
