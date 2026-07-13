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
    TsdtechClient.initialize(baseUrl: 'http://test');
    final adapter = MockHttpClientAdapter();
    BaseApi.setDioForTesting(createDioWithAdapter(adapter));
    adapter.when('GET', '/deposit-request/public/mock_dep_123/summary', {
      'id': 'mock_dep_123',
      'amount': 0,
      'createdAtUtc': '2026-06-01T00:00:00Z',
      'depositRequestId': 'mock_dep_123',
      'items_summary': [],
    });
  });

  group('CheckoutWidget UI Tests', () {
    testWidgets('CA-1 e CA-2: Renderiza corretamente com as opções PIX', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(
              depositRequestId: 'mock_dep_123',
              items: [],
              administratorId: 'a',
              showCard: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CheckoutWidget), findsOneWidget);
      expect(find.text('PIX'), findsOneWidget);
      expect(find.text('Cartão'), findsNothing);
    });

    testWidgets('Renderiza a opção Cartão quando showCard é true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(
              depositRequestId: 'mock_dep_123',
              items: [],
              administratorId: 'a',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('PIX'), findsOneWidget);
      expect(find.text('Cartão'), findsOneWidget);

      // Antes de selecionar cartão, o formulário não aparece
      expect(find.byType(CardPaymentView), findsNothing);
    });

    testWidgets('Selecionar Cartão exibe o formulário de cartão', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(
              depositRequestId: 'mock_dep_123',
              items: [],
              administratorId: 'a',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cartão'));
      await tester.pumpAndSettle();

      expect(find.byType(CardPaymentView), findsOneWidget);
      expect(find.text('Número do cartão'), findsOneWidget);
      expect(find.text('Nome do titular'), findsOneWidget);
      expect(find.text('Validade'), findsOneWidget);
      expect(find.text('CVV'), findsOneWidget);
      expect(find.text('CPF/CNPJ do titular'), findsOneWidget);
      expect(find.text('Pagar Agora'), findsOneWidget);
    });
  });
}
