// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Membership _$MembershipFromJson(Map<String, dynamic> json) => Membership(
  clientUserId: json['clientUserId'] as String,
  organizationId: json['organizationId'] as String,
  role: (json['role'] as num).toInt(),
  clientUser: json['clientUser'] == null
      ? null
      : ClientUserEntity.fromJson(json['clientUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'clientUserId': instance.clientUserId,
      'organizationId': instance.organizationId,
      'role': instance.role,
      'clientUser': instance.clientUser?.toJson(),
    };
