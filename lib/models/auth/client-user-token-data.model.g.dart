// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client-user-token-data.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientUserTokenData _$ClientUserTokenDataFromJson(Map<String, dynamic> json) =>
    ClientUserTokenData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      secondName: json['secondName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      cpf: json['cpf'] as String?,
      is2FAAuthorized: json['is2FAAuthorized'] as bool?,
      expiresAt: (json['expiresAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientUserTokenDataToJson(
  ClientUserTokenData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'secondName': instance.secondName,
  'email': instance.email,
  'phone': instance.phone,
  'cpf': instance.cpf,
  'is2FAAuthorized': instance.is2FAAuthorized,
  'expiresAt': instance.expiresAt,
};
