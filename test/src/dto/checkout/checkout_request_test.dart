import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';

void main() {
  group('CheckoutRequest JSON', () {
    test('CardPaymentData toJson/fromJson round-trip', () {
      final card = CardPaymentData(
        cardHolderName: 'John Doe',
        cardNumber: '4111111111111111',
        cardExpiryDate: '12/30',
        securityCode: '123',
        preAuthorizedTransaction: true,
      );

      final json = card.toJson();
      final parsed = CardPaymentData.fromJson(json);

      expect(parsed.cardHolderName, card.cardHolderName);
      expect(parsed.cardNumber, card.cardNumber);
      expect(parsed.cardExpiryDate, card.cardExpiryDate);
      expect(parsed.securityCode, card.securityCode);
      expect(
          parsed.preAuthorizedTransaction, card.preAuthorizedTransaction);
    });

    test('BillPayerData toJson/fromJson round-trip', () {
      final payer = BillPayerData(
        name: 'John',
        address: 'Some street',
        neighborhood: 'Center',
        city: 'City',
        zipCode: '00000',
        state: 'ST',
      );

      final json = payer.toJson();
      final parsed = BillPayerData.fromJson(json);

      expect(parsed.name, payer.name);
      expect(parsed.address, payer.address);
      expect(parsed.neighborhood, payer.neighborhood);
      expect(parsed.city, payer.city);
      expect(parsed.zipCode, payer.zipCode);
      expect(parsed.state, payer.state);
    });

    test('toJson/fromJson round-trip with encryptedCard and card data', () {
      final card = CardPaymentData(
        cardHolderName: 'John Doe',
        cardNumber: '4111111111111111',
        cardExpiryDate: '12/30',
        securityCode: '123',
      );
      final payer = BillPayerData(
        name: 'John',
        address: 'Some street',
        neighborhood: 'Center',
        city: 'City',
        zipCode: '00000',
        state: 'ST',
      );

      final req = CheckoutRequest(
        cart: [CalculateItem(serviceId: 's1', value: 10.0, quantity: 1)],
        paymentMethod: 'card',
        totalValue: 10.0,
        encryptedCard: 'encrypted',
        card: card,
        billPayer: payer,
        billDueDate: '2026-05-14',
        billInstructions: 'Pay by date',
        installmentNumber: 1,
      );

      final json = req.toJson();
      final parsed = CheckoutRequest.fromJson(json);

      expect(parsed.paymentMethod, req.paymentMethod);
      expect(parsed.totalValue, req.totalValue);
      expect(parsed.encryptedCard, req.encryptedCard);
      expect(parsed.card?.cardHolderName, req.card?.cardHolderName);
      expect(parsed.billPayer?.name, req.billPayer?.name);
      expect(parsed.installmentNumber, req.installmentNumber);
    });

    test('toJson/fromJson round-trip without encryptedCard', () {
      final req = CheckoutRequest(cart: [], paymentMethod: 'pix', totalValue: 0.0);
      final json = req.toJson();
      final parsed = CheckoutRequest.fromJson(json);
      expect(parsed.paymentMethod, 'pix');
      expect(parsed.encryptedCard, isNull);
    });
  });
}
