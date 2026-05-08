// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: json['id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      administratorId: json['administratorId'] as String?,
      serviceTypeId: json['serviceTypeId'] as String?,
      serviceType: json['serviceType'] == null
          ? null
          : ServiceType.fromJson(json['serviceType'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toDouble(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      validTimestamp: (json['validTimestamp'] as num?)?.toInt(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'administratorId': instance.administratorId,
      'serviceTypeId': instance.serviceTypeId,
      'serviceType': instance.serviceType?.toJson(),
      'price': instance.price,
      'tags': instance.tags,
      'validTimestamp': instance.validTimestamp,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
