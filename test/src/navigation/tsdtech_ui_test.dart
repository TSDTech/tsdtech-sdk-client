import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/src/navigation/tsdtech_ui.dart';
import 'package:tsdtech_client_sdk/src/ui/checkout/payment_types.dart';

void main() {
  CartItem buildCartItem() {
    return CartItem(
      service: Service(id: 'service_1', name: 'Servico teste', price: 19.9),
      quantity: 1,
    );
  }

  PaymentResult buildPaymentResult() {
    return PaymentResult(
      transactionId: 'tx_123',
      method: PaymentMethodType.card,
      status: PaymentStatus.failed,
      message: 'Falha no pagamento',
    );
  }

  Widget buildHostApp() {
    final item = buildCartItem();
    final paymentResult = buildPaymentResult();
    final client = TsdtechClient(baseUrl: 'https://api.example.com');

    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () {
                    TsdtechUi.showCheckoutSheet<void>(
                      context: context,
                      items: [item],
                      administratorId: 'admin_123',
                      client: client,
                      onSuccess: () {},
                      onCancel: () {},
                    );
                  },
                  child: const Text('sheet'),
                ),
                TextButton(
                  onPressed: () {
                    TsdtechUi.showCheckoutDialog<void>(
                      context: context,
                      items: [item],
                      administratorId: 'admin_123',
                      client: client,
                      onSuccess: () {},
                      onCancel: () {},
                    );
                  },
                  child: const Text('dialog'),
                ),
                TextButton(
                  onPressed: () {
                    TsdtechUi.pushCheckoutScreen(
                      context: context,
                      items: [item],
                      administratorId: 'admin_123',
                      client: client,
                      onSuccess: () {},
                      onCancel: () {},
                    );
                  },
                  child: const Text('push'),
                ),
                TextButton(
                  onPressed: () {
                    TsdtechUi.showPaymentStatus<void>(
                      context: context,
                      paymentResult: paymentResult,
                    );
                  },
                  child: const Text('status'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  group('TsdtechUi helpers', () {
    testWidgets('showCheckoutSheet abre checkout em bottom sheet', (
      tester,
    ) async {
      await tester.pumpWidget(buildHostApp());

      await tester.tap(find.text('sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Resumo do pedido'), findsOneWidget);
    });

    testWidgets('showCheckoutDialog abre checkout em dialog', (tester) async {
      await tester.pumpWidget(buildHostApp());

      await tester.tap(find.text('dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('pushCheckoutScreen navega para a tela', (tester) async {
      await tester.pumpWidget(buildHostApp());

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Metodo de pagamento'), findsOneWidget);
    });

    testWidgets('showPaymentStatus exibe status em dialog', (tester) async {
      await tester.pumpWidget(buildHostApp());

      await tester.tap(find.text('status'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Status do pagamento'), findsOneWidget);
      expect(find.text('Pagamento falhou'), findsOneWidget);
    });
  });
}
