// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceType _$ServiceTypeFromJson(Map<String, dynamic> json) => ServiceType(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      administratorId: json['administratorId'] as String?,
      codeRange: json['codeRange'] as String?,
      providers: (json['providers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceTypeToJson(ServiceType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'administratorId': instance.administratorId,
      'codeRange': instance.codeRange,
      'providers': instance.providers,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
