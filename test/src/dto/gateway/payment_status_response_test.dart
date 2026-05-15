import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  group('PaymentStatusResponse', () {
    test('round-trip and enum mapping', () {
      final resp = PaymentStatusResponse(
        status: GatewayPaymentStatus.approved,
        authorizationCode: 'AUTH123',
        nsu: 'NSU1',
        depositRequestId: 'dep-1',
        message: 'Approved',
        brand: 'visa',
      );

      final json = resp.toJson();
      final resp2 = PaymentStatusResponse.fromJson(json);

      expect(resp2.status, equals(GatewayPaymentStatus.approved));
      expect(resp2.authorizationCode, equals('AUTH123'));
      expect(resp2.brand, equals('visa'));
    });

    test('null optional fields', () {
      final resp = PaymentStatusResponse(status: GatewayPaymentStatus.processing);
      final json = resp.toJson();
      final resp2 = PaymentStatusResponse.fromJson(json);
      expect(resp2.authorizationCode, isNull);
      expect(resp2.nsu, isNull);
    });

    test('malformed status throws', () {
      final bad = {'status': 'unknown'};
      expect(() => PaymentStatusResponse.fromJson(bad), throwsA(isA<ArgumentError>()));
    });
  });
}
