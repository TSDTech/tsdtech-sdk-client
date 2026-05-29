import 'package:json_annotation/json_annotation.dart';

part 'public_key_response.g.dart';

/// DTO que representa a resposta da chave pública RSA do Gateway.
@JsonSerializable()
class PublicKeyResponse {
  final String pemPublicKey;
  final String keyId;
  final DateTime? expiresAt;

  PublicKeyResponse({
    required this.pemPublicKey,
    required this.keyId,
    this.expiresAt,
  });

  factory PublicKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicKeyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PublicKeyResponseToJson(this);
}
