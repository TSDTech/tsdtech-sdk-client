// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'administrator.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Administrator _$AdministratorFromJson(Map<String, dynamic> json) =>
    Administrator(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      cnpj: json['cnpj'] as String?,
      phoneContact: json['phoneContact'] as String?,
      clients:
          (json['clients'] as List<dynamic>?)?.map((e) => e as String).toList(),
      fullDomain: (json['fullDomain'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AdministratorToJson(Administrator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'cnpj': instance.cnpj,
      'phoneContact': instance.phoneContact,
      'clients': instance.clients,
      'fullDomain': instance.fullDomain,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
