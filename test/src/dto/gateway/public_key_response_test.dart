import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  group('PublicKeyResponse', () {
    test('round-trip', () {
      final iso = DateTime.now().toUtc().toIso8601String();
      final json = {
        'pemPublicKey':
            '-----BEGIN PUBLIC KEY-----\nabc\n-----END PUBLIC KEY-----',
        'keyId': 'key-123',
        'expiresAt': iso,
      };

      final obj = PublicKeyResponse.fromJson(json);
      final json2 = obj.toJson();
      final obj2 = PublicKeyResponse.fromJson(json2);

      expect(obj2.pemPublicKey, equals(obj.pemPublicKey));
      expect(obj2.keyId, equals(obj.keyId));
      expect(obj2.expiresAt!.toUtc().toIso8601String(), equals(iso));
    });

    test('null optional fields', () {
      final json = {
        'pemPublicKey':
            '-----BEGIN PUBLIC KEY-----\nabc\n-----END PUBLIC KEY-----',
        'keyId': 'key-123',
        'expiresAt': null,
      };

      final obj = PublicKeyResponse.fromJson(json);
      expect(obj.expiresAt, isNull);
      final json2 = obj.toJson();
      expect(json2['expiresAt'], isNull);
    });

    test('malformed json throws', () {
      final malformed = {'pemPublicKey': 123, 'keyId': 'k'};
      expect(
        () => PublicKeyResponse.fromJson(malformed),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
