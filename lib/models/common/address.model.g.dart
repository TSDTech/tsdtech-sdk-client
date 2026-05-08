// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      id: json['id'] as String,
      createdAtUtc: const UnixDateTimeConverter()
          .fromJson((json['createdAtUtc'] as num).toInt()),
      countryCode: json['countryCode'] as String? ?? 'BR',
      street: json['street'] as String,
      number: json['number'] as String,
      complement: json['complement'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAtUtc':
          const UnixDateTimeConverter().toJson(instance.createdAtUtc),
      'countryCode': instance.countryCode,
      'street': instance.street,
      'number': instance.number,
      'complement': instance.complement,
      'district': instance.district,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
    };
