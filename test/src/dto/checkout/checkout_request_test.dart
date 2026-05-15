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
      expect(parsed.preAuthorizedTransaction, card.preAuthorizedTransaction);
    });

    test('toJson/fromJson round-trip with encryptedCard and card data', () {
      final card = CardPaymentData(
        cardHolderName: 'John Doe',
        cardNumber: '4111111111111111',
        cardExpiryDate: '12/30',
        securityCode: '123',
      );

      final req = CheckoutRequest(
        cart: [CalculateItem(serviceId: 's1', value: 10.0, quantity: 1)],
        paymentMethod: 'card',
        totalValue: 10.0,
        encryptedCard: 'encrypted',
        card: card,
        installmentNumber: 1,
      );

      final json = req.toJson();
      final parsed = CheckoutRequest.fromJson(json);

      expect(parsed.paymentMethod, req.paymentMethod);
      expect(parsed.totalValue, req.totalValue);
      expect(parsed.encryptedCard, req.encryptedCard);
      expect(parsed.card?.cardHolderName, req.card?.cardHolderName);
      expect(parsed.installmentNumber, req.installmentNumber);
    });

    test('toJson/fromJson round-trip without encryptedCard', () {
      final req =
          CheckoutRequest(cart: [], paymentMethod: 'pix', totalValue: 0.0);
      final json = req.toJson();
      final parsed = CheckoutRequest.fromJson(json);
      expect(parsed.paymentMethod, 'pix');
      expect(parsed.encryptedCard, isNull);
    });
  });
}
