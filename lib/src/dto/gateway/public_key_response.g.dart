// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_key_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicKeyResponse _$PublicKeyResponseFromJson(Map<String, dynamic> json) =>
    PublicKeyResponse(
      pemPublicKey: json['pemPublicKey'] as String,
      keyId: json['keyId'] as String,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$PublicKeyResponseToJson(PublicKeyResponse instance) =>
    <String, dynamic>{
      'pemPublicKey': instance.pemPublicKey,
      'keyId': instance.keyId,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
