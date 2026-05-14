import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_response.model.dart';

void main() {
  group('Checkout Service (behavioral)', () {
    test('detects two-step flow when depositRequestId present', () {
      final resp = CheckoutResponse.fromJson(
        {'paymentMethod': 'card', 'depositRequestId': 'dep_1'},
      );

      final isTwoStep = (resp.depositRequestId?.isNotEmpty ?? false);
      expect(isTwoStep, isTrue);
    });
  });
}
