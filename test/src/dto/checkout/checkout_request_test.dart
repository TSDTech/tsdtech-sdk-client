import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';

void main() {
  group('CheckoutRequest DTO', () {
    test('serializes and deserializes depositRequestId', () {
      final item = CalculateItem(serviceId: 'svc1', value: 10.0, quantity: 1);
      final req = CheckoutRequest(
        cart: [item],
        paymentMethod: 'card',
        totalValue: 10.0,
        depositRequestId: 'dep_123',
      );

      final json = req.toJson();
      final parsed = CheckoutRequest.fromJson(json);

      expect(parsed.depositRequestId, 'dep_123');
      expect(parsed.paymentMethod, 'card');
      expect(parsed.totalValue, 10.0);
      expect(parsed.cart.length, 1);
      expect(parsed.cart.first.serviceId, 'svc1');
    });
  });
}
