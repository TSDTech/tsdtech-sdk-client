// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => ApiKey(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String?,
  name: json['name'] as String,
  rawKey: json['rawKey'] as String?,
);

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'name': instance.name,
  'rawKey': instance.rawKey,
};
