// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client-user-entity.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientUserEntity _$ClientUserEntityFromJson(Map<String, dynamic> json) =>
    ClientUserEntity(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      document: json['document'] as String?,
      documentType: json['documentType'] as String?,
      twoFactorAuthKey: json['twoFactorAuthKey'] as String?,
      developerPassword: json['developerPassword'] as String?,
      administratorId: json['administratorId'] as String?,
      memberships: (json['memberships'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ClientUserEntityToJson(ClientUserEntity instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'document': instance.document,
      'documentType': instance.documentType,
      'twoFactorAuthKey': instance.twoFactorAuthKey,
      'developerPassword': instance.developerPassword,
      'administratorId': instance.administratorId,
      'memberships': instance.memberships,
    };
