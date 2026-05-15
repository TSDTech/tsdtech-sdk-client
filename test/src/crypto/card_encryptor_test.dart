import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:test/test.dart';
// Ajuste os paths conforme sua estrutura
import 'package:tsdtech_client_sdk/src/crypto/card_encryptor.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';

void main() {
  group('CardEncryptor Tests', () {
    // Chaves geradas exclusivamente para teste unitário (Não use em prod!)
    const testPublicKeyPem = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtt1U5UFmzDjj7gapJsmm
bYtbyidVOPtj4WoyMnTaNL4EzwbunYI2oQWcxXR8H/e0f96eVHBa7w1Oq5l/IrcV
mpljD8AQqubMD9qN3D8m4CO2nENkoBQK7KP3+M1PqekqIRrIxWzGwSJPn0bSfRb/
E23qCA3Piha+u6ehKFcOs9zkO3tTfwEU3UwxYQCjrbBGDVWe+bOea6ieDjUV/P/J
ErpDWPDHh5/7bseus0lVJZkvqmoeT4ec98M3vxDpAc1N2ZGQE+5ou+i6gvJl8AMA
64n4gkOmYCWKXtcXQj4XtI6ZufN8FH/gPtgYglkB0TS9KXEcU+NTwdv5WGADYAZb
GQIDAQAB
-----END PUBLIC KEY-----''';

    const testPrivateKeyPem = '''-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC23VTlQWbMOOPu
BqkmyaZti1vKJ1U4+2PhajIydNo0vgTPBu6dgjahBZzFdHwf97R/3p5UcFrvDU6r
mX8itxWamWMPwBCq5swP2o3cPybgI7acQ2SgFArso/f4zU+p6SohGsjFbMbBIk+f
RtJ9Fv8TbeoIDc+KFr67p6EoVw6z3OQ7e1N/ARTdTDFhAKOtsEYNVZ75s55rqJ4O
NRX8/8kSukNY8MeHn/tux66zSVUlmS+qah5Ph5z3wze/EOkBzU3ZkZAT7mi76LqC
8mXwAwDrifiCQ6ZgJYpe1xdCPhe0jpm583wUf+A+2BiCWQHRNL0pcRxT41PB2/lY
YANgBlsZAgMBAAECggEAOV265ca8KIIKYyAczYnCF6h5zbPEJQGcRllp0PFeiOA5
ovbSQYBZge9ATKNr0x2CtwCQG/45ULgUf3nCbBISiXLoJEdFE1AfITQXf8oh+HvL
rD7qINvYx37y6k8CWFPIvyTnaiPjQDBy2Q0/ODXQJHi9S/SFMJVNFZKTWJPjDWJN
Ma7nkpI4Jo2v9ThCL/6AvmlTl+9S0cgRDClA7Y/W+Is5UmehwQAx1UKzxUaXYrKw
6hVFz52G0XllKf4IanuHPKE6dj4f0/ysHuDgv1PyB4YJwIVkFt+HFFRqIqoukh4o
dLcxBWeUa5wsmNAXHmMglKj/rDJ9NDdmZFahobOJ5wKBgQDgW6pptYX6w0pgA2/9
Ine7S9yeIwoCb73vmnfq3S4wF1QV9F/8uySWCy2AppDq+1pA3JgotA9l9twLF7u3
uvwUAedF/FRtSX7NUsK82muMAA2UjwjOTDV3z1SZPJcDpaOVBpRc/y67y4mmpOwu
TEgv6io4e9nzsk3+V6WPToy71wKBgQDQp5B/YbLmvcX+YSE3LeF9TYQCrzEZU9IX
b3uiXR1thVx0SOegzDI+nXonYDkTZFm+/6Y+MH/WCtsATvX7YrjfvX+anhJ54TcE
PFIBwAV5pUnuz3K+ktZkO5qxSNtHbhuw5XTgtJjvRFma6XnZ/o+wCJaVLy12HceD
FYjnAWRCjwKBgEC6saPl902t4ltpInpJ43lqHbCSM2UYkBf83PQp9BVz5ZKf+sGT
zK5tcydW5yCkfBmSi2PS705ftoSMyF/t1qR/GBadAk61kZvzcLPD4Jt3uHNQAR5j
5lk2vBWp4Xfv5g4s48kg5n7P7lrh4jJJV9pbGOtK8Era+p2S8/UwmHHpAoGAbwy/
mwwkayoVdo27X+LLYCUhXUxglVpHNrHe20sznlacHkeu/6WuGCU4HjzYI7oFCeKG
WBL39rNQW5mq0WB5hJsWjvQSYUu8PETeYJASWeverXs7VrJP6IjQjAp6qkmv8zYs
Pmvf+XgnOIuKjrstPkNT4ZJ6X6L5zIppkojrE4ECgYEAzjKPKv3vA602oP42bY33
/gGycyy9ZVMeIpmFEEo3YjikwxorgFP7UEIwfs1DlfC+jIxgSJkg4Xbgne1ksDxJ
t5yGJ2rP/S+flaC1qia/DxK1UcrRilLudj1CBvn5A7/wJHERLa9XB5ScahEB0esw
kZVhIwLwo/hz061nP2/el1c=
-----END PRIVATE KEY-----''';

    final testCardData = CardPaymentData(
      cardHolderName: 'JOAO DA SILVA',
      cardNumber: '1111222233334444',
      cardExpiryDate: '202812',
      securityCode: '123',
    );

    test('CA-1 & CA-2: Deve criptografar e retornar um Base64 válido', () {
      final base64Ciphertext = CardEncryptor.encrypt(testPublicKeyPem, testCardData);
      
      // Valida se é uma string Base64 válida
      expect(base64Ciphertext, isNotEmpty);
      expect(RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(base64Ciphertext), isTrue);

      // --- Validação da Descriptografia ---
      final parser = RSAKeyParser();
      final privateKey = parser.parse(testPrivateKeyPem) as RSAPrivateKey;
      
      final decrypter = Encrypter(
        RSA(
          privateKey: privateKey,
          encoding: RSAEncoding.OAEP,
          digest: RSADigest.SHA256,
        ),
      );

      final decryptedJsonString = decrypter.decrypt64(base64Ciphertext);
      final decryptedMap = jsonDecode(decryptedJsonString);

      expect(decryptedMap['cardNumber'], equals('1111222233334444'));
      expect(decryptedMap['cardHolderName'], equals('JOAO DA SILVA'));
    });

    test('CA-4: Deve lançar FormatException descritiva se a chave PEM for malformada', () {
      const invalidPem = '-----BEGIN PUBLIC KEY-----\nINVALID_DATA\n-----END PUBLIC KEY-----';
      
      expect(
        () => CardEncryptor.encrypt(invalidPem, testCardData),
        throwsA(isA<FormatException>()),
      );
    });

    test('Deve tratar chave vazia lançando FormatException', () {
      expect(
        () => CardEncryptor.encrypt('', testCardData),
        throwsA(isA<FormatException>()),
      );
    });
  });
}