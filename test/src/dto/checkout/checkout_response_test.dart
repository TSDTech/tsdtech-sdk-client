import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_response.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/pix_data.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/bill_data.model.dart';

void main() {
  group('CheckoutResponse JSON', () {
    test('toJson/fromJson round-trip with pix and bill', () {
      final pix = PixData(qrCode: 'qr', copyPasteCode: 'paste');
      final bill = BillData(
        pinbankSlipId: 'pid',
        base64Path: 'b64',
        digitableLine: 'dig',
        barCode: 'bar',
        digitalAccountPinbankId: 'acc',
      );

      final res = CheckoutResponse(paymentMethod: 'pix', paymentId: 'p1', pix: pix, bill: bill, status: 'pending');
      final json = res.toJson();
      final parsed = CheckoutResponse.fromJson(json);

      expect(parsed.paymentMethod, res.paymentMethod);
      expect(parsed.paymentId, res.paymentId);
      expect(parsed.pix?.qrCode, res.pix?.qrCode);
      expect(parsed.bill?.digitableLine, res.bill?.digitableLine);
      expect(parsed.status, res.status);
    });
  });
}
