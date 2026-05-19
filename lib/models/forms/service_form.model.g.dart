// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_form.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceForm _$ServiceFormFromJson(Map<String, dynamic> json) => ServiceForm(
  id: json['id'] as String,
  title: json['title'] as String,
  clientId: json['clientId'] as String?,
  description: json['description'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  fields: (json['fields'] as List<dynamic>)
      .map((e) => ServiceFormField.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ServiceFormToJson(ServiceForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'clientId': instance.clientId,
      'description': instance.description,
      'metadata': instance.metadata,
      'fields': instance.fields.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
