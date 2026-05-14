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
        'publicKeyUrl': 'https://gateway.example/pub'
      };

      final resp = CheckoutResponse.fromJson(json);

      expect(resp.paymentMethod, 'card');
      expect(resp.depositRequestId, 'dep_123');
      expect(resp.pix, isNull);
      expect(resp.bill, isNull);
    });

    test('parses pix payload without depositRequestId', () {
      final json = {
        'paymentMethod': 'pix',
        'paymentId': 'pix_123',
        'status': 'pending',
        'pix': {'qrCode': 'QR', 'copyPasteCode': 'COPY'}
      };

      final resp = CheckoutResponse.fromJson(json);

      expect(resp.paymentMethod, 'pix');
      expect(resp.depositRequestId, isNull);
      expect(resp.pix, isNotNull);
      expect(resp.pix?.qrCode, 'QR');
      expect(resp.pix?.copyPasteCode, 'COPY');
    });

    test('parses bill payload without depositRequestId', () {
      final json = {
        'paymentMethod': 'bill',
        'paymentId': 'bill_123',
        'status': 'pending',
        'bill': {
          'pinbankSlipId': 'pb_1',
          'base64Path': 'data:application/pdf;base64,AAA',
          'digitableLine': '123',
          'barCode': '456',
          'digitalAccountPinbankId': 'da_1'
        }
      };

      final resp = CheckoutResponse.fromJson(json);

      expect(resp.paymentMethod, 'bill');
      expect(resp.depositRequestId, isNull);
      expect(resp.bill, isNotNull);
      expect(resp.bill?.pinbankSlipId, 'pb_1');
      expect(resp.bill?.digitableLine, '123');
    });
  });
}
