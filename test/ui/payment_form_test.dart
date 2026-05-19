import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

void main() {
  testWidgets('does not submit invalid card form', (tester) async {
    PaymentFormData? submittedData;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentForm(
            initialMethod: PaymentFormMethod.card,
            onSubmit: (data) => submittedData = data,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pagar'));
    await tester.pumpAndSettle();

    expect(submittedData, isNull);
    expect(find.text('Número do cartão obrigatório'), findsOneWidget);
  });

  testWidgets('submits validated card data', (tester) async {
    PaymentFormData? submittedData;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentForm(
            initialMethod: PaymentFormMethod.card,
            onSubmit: (data) => submittedData = data,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Número do cartão'),
      '4111111111111111',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome do titular'),
      'John Doe',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Validade'),
      '12/99',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'CVV'), '123');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'CPF/CNPJ do titular'),
      '52998224725',
    );

    await tester.tap(find.text('Pagar'));
    await tester.pumpAndSettle();

    expect(submittedData, isNotNull);
    expect(submittedData!.method, PaymentFormMethod.card);
    expect(submittedData!.cardData, isNotNull);
    expect(submittedData!.cardData!.cleanCardNumber, '4111111111111111');
  });

  testWidgets('submits pix without card validation', (tester) async {
    PaymentFormData? submittedData;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentForm(
            initialMethod: PaymentFormMethod.pix,
            onSubmit: (data) => submittedData = data,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pagar'));
    await tester.pumpAndSettle();

    expect(submittedData, isNotNull);
    expect(submittedData!.method, PaymentFormMethod.pix);
    expect(submittedData!.cardData, isNull);
  });
}
