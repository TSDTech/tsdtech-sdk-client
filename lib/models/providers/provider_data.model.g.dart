// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_data.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderData _$ProviderDataFromJson(Map<String, dynamic> json) => ProviderData(
  id: json['id'] as String,
  email: json['email'] as String?,
  cnpj: json['cnpj'] as String?,
  phoneContact: json['phoneContact'] as String?,
  name: json['name'] as String?,
  administratorId: json['administratorId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProviderDataToJson(ProviderData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'cnpj': instance.cnpj,
      'phoneContact': instance.phoneContact,
      'name': instance.name,
      'administratorId': instance.administratorId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
