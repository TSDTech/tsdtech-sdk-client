import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import '../../../models/checkouts/checkout_request.model.dart';

class CardEncryptor {
  // Criptografa os dados do cartão usando chave pública RSA.
  // Utiliza o padrão exigido para PCI: RSA/ECB/OAEPWithSHA-256AndMGF1Padding.
  // Retorna o ciphertext em Base64.
  static String encrypt(String pemPublicKey, CardPaymentData cardData) {
    if (pemPublicKey.trim().isEmpty) {
      throw const FormatException('A chave pública PEM não pode estar vazia.');
    }

    late final RSAPublicKey publicKey;

    try {
      final parser = RSAKeyParser();
      // O cast é necessário pois o parser pode retornar RSAPrivateKey dependendo do PEM
      publicKey = parser.parse(pemPublicKey) as RSAPublicKey;
    } catch (e) {
      throw FormatException('Falha ao fazer parse da chave pública PEM. Formato inválido. Detalhes: $e');
    }

    // O padding OAEP com SHA-256 e MGF1 é configurado aqui:
    final encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.OAEP,
        digest: RSADigest.SHA256,
      ),
    );

    // Converte o objeto do cartão para JSON String
    // IMPORTANTE: Nunca logue esta string no console
    final plainTextJson = jsonEncode(cardData.toJson());

    // Criptografa
    final encrypted = encrypter.encrypt(plainTextJson);

    // Retorna em Base64
    return encrypted.base64;
  }
}