import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/screens/payment_status_screen.dart';
import 'package:tsdtech_client_sdk/src/ui/checkout/payment_types.dart';

void main() {
  PaymentResult buildResult({
    required PaymentStatus status,
    PaymentMethodType method = PaymentMethodType.card,
    String? message,
  }) {
    return PaymentResult(
      transactionId: 'tx_123',
      method: method,
      status: status,
      depositRequestId: 'dep_456',
      pixQrCode: method == PaymentMethodType.pix ? 'pix-code' : null,
      message: message,
    );
  }

  Future<void> pumpStatusScreen(
    WidgetTester tester,
    PaymentResult paymentResult,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: PaymentStatusScreen(paymentResult: paymentResult)),
    );
  }

  group('PaymentStatusScreen', () {
    testWidgets('renderiza estado processing', (tester) async {
      await pumpStatusScreen(
        tester,
        buildResult(status: PaymentStatus.processing),
      );

      expect(find.text('Processando pagamento'), findsOneWidget);
      expect(find.byIcon(Icons.sync_rounded), findsOneWidget);
      expect(find.text('Processing'), findsOneWidget);
      expect(find.text('Detalhes do pagamento'), findsOneWidget);
      expect(find.text('Voltar'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsNothing);
    });

    testWidgets('renderiza estado approved', (tester) async {
      await pumpStatusScreen(
        tester,
        buildResult(status: PaymentStatus.success),
      );

      expect(find.text('Pagamento aprovado'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);
      expect(find.text('Cartao'), findsOneWidget);
      expect(find.text('dep_456'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsNothing);
    });

    testWidgets('renderiza estado pending', (tester) async {
      await pumpStatusScreen(
        tester,
        buildResult(
          status: PaymentStatus.waitingPayment,
          method: PaymentMethodType.pix,
        ),
      );

      expect(find.text('Pagamento pendente'), findsOneWidget);
      expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Metodo'), findsOneWidget);
      expect(find.text('pix-code'), findsOneWidget);
    });

    testWidgets('renderiza estado failed com retry', (tester) async {
      var retryCount = 0;
      var backCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: PaymentStatusScreen(
            paymentResult: buildResult(
              status: PaymentStatus.failed,
              message: 'Cartao recusado',
            ),
            onRetry: () => retryCount++,
            onBack: () => backCount++,
          ),
        ),
      );

      expect(find.text('Pagamento falhou'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
      expect(find.text('Cartao recusado'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);

      await tester.ensureVisible(find.text('Tentar novamente'));
      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();
      expect(retryCount, 1);

      await tester.ensureVisible(find.text('Voltar'));
      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();
      expect(backCount, 1);
    });
  });
}
