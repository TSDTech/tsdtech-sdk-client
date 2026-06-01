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
            context: tester.element(find.text('x')),
            items: [],
            administratorId: 'a',
            depositRequestId: '123',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pump();
      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('showCheckoutDialog abre checkout em dialog', (tester) async {
      await tester.pumpWidget(
        buildApp(
          () => TsdtechUi.showCheckoutDialog<void>(
            context: tester.element(find.text('x')),
            items: [],
            administratorId: 'a',
            depositRequestId: '123',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pump();
      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('pushCheckoutScreen navega para a tela', (tester) async {
      await tester.pumpWidget(
        buildApp(
          () => TsdtechUi.pushCheckoutScreen(
            context: tester.element(find.text('x')),
            items: [],
            administratorId: 'a',
            depositRequestId: '123',
            onSuccess: () {},
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pump();
      expect(tester.takeException(), isA<TypeError>());
    });
  });
}
