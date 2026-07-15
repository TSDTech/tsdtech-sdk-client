import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  group('CardPaymentRequest', () {
    test('round-trip', () {
      final req = CardPaymentRequest(
        depositRequestId: 'dep-1',
        encryptedCardData: 'ZmFrZQ==',
        keyId: 'key-1',
        installmentNumber: 2,
        cardPayer: CardPayer(cardHolderName: 'John Doe', cpf: '12345678901'),
      );

      final json = req.toJson();
      final req2 = CardPaymentRequest.fromJson(json);

      expect(req2.depositRequestId, equals(req.depositRequestId));
      expect(req2.encryptedCardData, equals(req.encryptedCardData));
      expect(req2.keyId, equals(req.keyId));
      expect(req2.installmentNumber, equals(req.installmentNumber));
      expect(req2.cardPayer?.cardHolderName, equals('John Doe'));
      expect(req2.cardPayer?.cpf, equals('12345678901'));
    });

    test('serializes with backend field names', () {
      final req = CardPaymentRequest(
        depositRequestId: 'dep-1',
        encryptedCardData: 'ZmFrZQ==',
        keyId: 'key-1',
      );

      final json = req.toJson();

      expect(json.containsKey('encryptedCardData'), isTrue);
      expect(json.containsKey('encryptedCard'), isFalse);
    });

    test('null optional fields', () {
      final req = CardPaymentRequest(
        depositRequestId: 'dep-2',
        encryptedCardData: 'ZmFrZQ==',
        keyId: 'key-2',
      );

      final json = req.toJson();
      final req2 = CardPaymentRequest.fromJson(json);

      expect(req2.installmentNumber, isNull);
      expect(req2.cardPayer, isNull);
    });

    test('malformed json throws', () {
      final malformed = {
        'depositRequestId': 123,
        'encryptedCardData': 'x',
        'keyId': 'k',
      };
      expect(
        () => CardPaymentRequest.fromJson(malformed),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
