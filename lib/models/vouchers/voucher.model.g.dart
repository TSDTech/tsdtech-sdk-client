// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      status: json['status'] as String,
      code: json['code'] as String,
      formId: json['formId'] as String?,
      orderId: json['orderId'] as String?,
      clientId: json['clientId'] as String?,
      validity: json['validity'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      service: json['service'] == null
          ? null
          : Service.fromJson(json['service'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : ClientUserEntity.fromJson(json['client'] as Map<String, dynamic>),
      order: json['order'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'formId': instance.formId,
      'code': instance.code,
      'status': instance.status,
      'orderId': instance.orderId,
      'clientId': instance.clientId,
      'validity': instance.validity,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'service': instance.service?.toJson(),
      'client': instance.client?.toJson(),
      'order': instance.order,
    };
