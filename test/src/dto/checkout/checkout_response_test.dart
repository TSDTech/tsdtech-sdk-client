import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_response.model.dart';

void main() {
  group('CheckoutResponse DTO', () {
    test('parses depositRequestId when present', () {
      final json = {
        'paymentMethod': 'card',
        'paymentId': 'pay_123',
        'status': 'pending',
        'depositRequestId': 'dep_123',
        'gatewayBaseUrl': 'https://gateway.example',
        'publicKeyUrl': 'https://gateway.example/pub',
      };

      final resp = CheckoutResponse.fromJson(json);

      expect(resp.paymentMethod, 'card');
      expect(resp.depositRequestId, 'dep_123');
      expect(resp.pix, isNull);
    });

    test('parses pix payload without depositRequestId', () {
      final json = {
        'paymentMethod': 'pix',
        'paymentId': 'pix_123',
        'status': 'pending',
        'pix': {'qrCode': 'QR', 'copyPasteCode': 'COPY'},
      };

      final resp = CheckoutResponse.fromJson(json);

      expect(resp.paymentMethod, 'pix');
      expect(resp.depositRequestId, isNull);
      expect(resp.pix, isNotNull);
      expect(resp.pix?.qrCode, 'QR');
      expect(resp.pix?.copyPasteCode, 'COPY');
    });
  });
}
