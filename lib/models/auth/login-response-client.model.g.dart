// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login-response-client.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseClient _$LoginResponseClientFromJson(Map<String, dynamic> json) =>
    LoginResponseClient(
      data: json['data'] == null
          ? null
          : ClientUserTokenData.fromJson(json['data'] as Map<String, dynamic>),
      entity: json['entity'] == null
          ? null
          : ClientUserEntity.fromJson(json['entity'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: (json['expiresAt'] as num).toInt(),
    );

Map<String, dynamic> _$LoginResponseClientToJson(
  LoginResponseClient instance,
) => <String, dynamic>{
  'data': instance.data,
  'entity': instance.entity,
  'token': instance.token,
  'expiresAt': instance.expiresAt,
};
