import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/src/screens/checkout_screen.dart';

void main() {
  CartItem buildItem({
    required String name,
    required double price,
    required int quantity,
  }) {
    return CartItem(
      service: Service(
        id: name.toLowerCase(),
        name: name,
        price: price,
      ),
      quantity: quantity,
    );
  }

  group('CheckoutScreen', () {
    testWidgets('renderiza header, resumo, checkout e footer', (
      tester,
    ) async {
      var successCount = 0;
      var cancelCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: CheckoutScreen(
            items: [
              buildItem(name: 'Plano Premium', price: 10, quantity: 2),
              buildItem(name: 'Servico Extra', price: 5.5, quantity: 1),
            ],
            administratorId: 'admin_123',
            onSuccess: () => successCount++,
            onCancel: () => cancelCount++,
          ),
        ),
      );

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Resumo do pedido'), findsOneWidget);
      expect(find.text('Metodo de pagamento'), findsOneWidget);
      expect(find.text('Plano Premium'), findsOneWidget);
      expect(find.text('Servico Extra'), findsOneWidget);
      expect(find.textContaining('25,50'), findsWidgets);
      expect(find.text('Gerar pagamento'), findsOneWidget);
      expect(find.textContaining('termos'), findsOneWidget);
      expect(successCount, 0);
      expect(cancelCount, 0);
    });

    testWidgets('expoe route Material e fecha com callback', (tester) async {
      var cancelCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CheckoutScreen.route(
                          items: [
                            buildItem(
                              name: 'Item teste',
                              price: 12,
                              quantity: 1,
                            ),
                          ],
                          administratorId: 'admin_123',
                          onSuccess: () {},
                          onCancel: () => cancelCount++,
                        ),
                      );
                    },
                    child: const Text('Abrir checkout'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Abrir checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(cancelCount, 1);
      expect(find.text('Abrir checkout'), findsOneWidget);
    });
  });
}