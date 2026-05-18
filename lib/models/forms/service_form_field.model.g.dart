// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_form_field.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceFormField _$ServiceFormFieldFromJson(Map<String, dynamic> json) =>
    ServiceFormField(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      isRequired: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      validationKey: json['validationKey'] as String?,
    );

Map<String, dynamic> _$ServiceFormFieldToJson(ServiceFormField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'label': instance.label,
      'required': instance.isRequired,
      'options': instance.options,
      'validationKey': instance.validationKey,
    };
