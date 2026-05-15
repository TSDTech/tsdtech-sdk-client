import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/widgets/checkout_widget.dart';
import 'package:tsdtech_client_sdk/src/components/payment_method_selector.dart';
import 'package:tsdtech_client_sdk/src/widgets/views/pix_payment_view.dart';
import 'package:tsdtech_client_sdk/src/widgets/views/card_payment_view.dart';
import 'package:tsdtech_client_sdk/src/widgets/views/bill_payment_view.dart';

void main() {
  group('CheckoutWidget UI Tests', () {
    testWidgets('CA-1 e CA-2: Renderiza corretamente com todas as opções (PIX, Cartão, Boleto)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(
              items: [], // Simula carrinho vazio para teste de UI
              administratorId: 'admin_123',
              gatewayPublicKey: 'pk_123',
            ),
          ),
        ),
      );

      // Verifica se o seletor está na tela
      expect(find.byType(PaymentMethodSelector), findsOneWidget);

      // Verifica se as 3 opções aparecem
      expect(find.text('PIX'), findsOneWidget);
      expect(find.text('Cartão'), findsOneWidget);
      expect(find.text('Boleto'), findsOneWidget);

      // PIX é o default, então a view do PIX deve estar visível
      expect(find.byType(PixPaymentView), findsOneWidget);
      expect(find.byType(CardPaymentView), findsNothing);
    });

    testWidgets('CA-2: Troca de abas atualiza a View do componente', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CheckoutWidget(
              items: [],
              administratorId: 'admin_123',
              gatewayPublicKey: 'pk_123',
            ),
          ),
        ),
      );

      // Toca no Cartão
      await tester.tap(find.text('Cartão'));
      await tester.pumpAndSettle(); // Aguarda a animação
      
      // Verifica se mudou a view
      expect(find.byType(PixPaymentView), findsNothing);
      expect(find.byType(CardPaymentView), findsOneWidget);
      // Verifica campos do cartão
      expect(find.text('Nome no cartão'), findsOneWidget);

      // Toca no Boleto
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();

      // Verifica se mudou a view
      expect(find.byType(CardPaymentView), findsNothing);
      expect(find.byType(BillPaymentView), findsOneWidget);
    });
  });
}