// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderModel _$ProviderModelFromJson(Map<String, dynamic> json) =>
    ProviderModel(
      providerId: json['providerId'] as String?,
      serviceTypeId: json['serviceTypeId'] as String?,
      provider: json['provider'] == null
          ? null
          : ProviderData.fromJson(json['provider'] as Map<String, dynamic>),
      serviceType: json['serviceType'] == null
          ? null
          : ServiceTypeModel.fromJson(
              json['serviceType'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProviderModelToJson(ProviderModel instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'serviceTypeId': instance.serviceTypeId,
      'provider': instance.provider?.toJson(),
      'serviceType': instance.serviceType?.toJson(),
    };
