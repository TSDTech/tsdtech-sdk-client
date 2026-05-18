import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  group('CardPaymentRequest', () {
    test('round-trip', () {
      final req = CardPaymentRequest(
        depositRequestId: 'dep-1',
        encryptedCard: 'ZmFrZQ==',
        keyId: 'key-1',
        installmentNumber: 2,
      );

      final json = req.toJson();
      final req2 = CardPaymentRequest.fromJson(json);

      expect(req2.depositRequestId, equals(req.depositRequestId));
      expect(req2.encryptedCard, equals(req.encryptedCard));
      expect(req2.keyId, equals(req.keyId));
      expect(req2.installmentNumber, equals(req.installmentNumber));
    });

    test('null optional fields', () {
      final req = CardPaymentRequest(
        depositRequestId: 'dep-2',
        encryptedCard: 'ZmFrZQ==',
        keyId: 'key-2',
      );

      final json = req.toJson();
      final req2 = CardPaymentRequest.fromJson(json);

      expect(req2.installmentNumber, isNull);
    });

    test('malformed json throws', () {
      final malformed = {'depositRequestId': 123, 'encryptedCard': 'x', 'keyId': 'k'};
      expect(() => CardPaymentRequest.fromJson(malformed), throwsA(isA<TypeError>()));
    });
  });
}
