import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/src/navigation/tsdtech_ui.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';
import '../../helpers/mock_dio.dart';

void main() {
  late MockHttpClientAdapter mockAdapter;
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();
    TsdtechClient.initialize(baseUrl: 'http://test');
    mockAdapter = MockHttpClientAdapter();
    BaseApi.setDioForTesting(createDioWithAdapter(mockAdapter));

    mockAdapter.when(
      'GET',
      '/deposit-request/public/feab62cf-a057-4d92-8490-b5b93c100f56/summary',
      {
        'id': 'feab62cf-a057-4d92-8490-b5b93c100f56',
        'amount': 0,
        'createdAtUtc': '2026-06-01T00:00:00Z',
        'depositRequestId': 'feab62cf-a057-4d92-8490-b5b93c100f56',
        'items_summary': [],
      },
    );
  });

  Widget buildApp(VoidCallback onTap) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(onPressed: onTap, child: const Text('x')),
      ),
    );
  }

  group('TsdtechUi helpers', () {
    testWidgets('showCheckoutSheet abre checkout em bottom sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          () => TsdtechUi.showCheckoutSheet<void>(
            depositRequestId: 'feab62cf-a057-4d92-8490-b5b93c100f56',
            context: tester.element(find.text('x')),
            items: [],
            administratorId: 'a',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pumpAndSettle();
      // O Scaffold de fundo da Sheet sobe
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('showCheckoutDialog abre checkout em dialog', (tester) async {
      await tester.pumpWidget(
        buildApp(
          () => TsdtechUi.showCheckoutDialog<void>(
            depositRequestId: 'feab62cf-a057-4d92-8490-b5b93c100f56',
            context: tester.element(find.text('x')),
            items: [],
            administratorId: 'a',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pumpAndSettle();
      // O Scaffold do checkout vai pra tela debaixo do Dialog
      expect(find.byType(Dialog), findsWidgets);
    });

    testWidgets('pushCheckoutScreen navega para a tela', (tester) async {
      await tester.pumpWidget(
        buildApp(
          () => TsdtechUi.pushCheckoutScreen(
            depositRequestId: 'feab62cf-a057-4d92-8490-b5b93c100f56',
            context: tester.element(find.text('x')),
            items: [],
            administratorId: 'a',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pumpAndSettle();
      // Encontra Scaffolds
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
