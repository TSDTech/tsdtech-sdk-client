// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTypeModel _$ServiceTypeModelFromJson(Map<String, dynamic> json) =>
    ServiceTypeModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      administratorId: json['administratorId'] as String?,
      codeRange: json['codeRange'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceTypeModelToJson(ServiceTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'administratorId': instance.administratorId,
      'codeRange': instance.codeRange,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
