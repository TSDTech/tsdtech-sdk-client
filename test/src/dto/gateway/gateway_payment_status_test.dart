import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  group('GatewayPaymentStatus enum', () {
    test('serializes and deserializes', () {
      final resp = PaymentStatusResponse(status: GatewayPaymentStatus.declined);
      final json = resp.toJson();
      expect(json['status'], equals('declined'));

      final resp2 = PaymentStatusResponse.fromJson({'status': 'declined'});
      expect(resp2.status, equals(GatewayPaymentStatus.declined));
    });
  });
}
