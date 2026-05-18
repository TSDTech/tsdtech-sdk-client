// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  hash: json['hash'] as String?,
  status: json['status'] as String?,
  clientId: json['clientId'] as String?,
  orderPaymentInfoId: json['orderPaymentInfoId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  client: json['client'] == null
      ? null
      : OrderClientInfo.fromJson(json['client'] as Map<String, dynamic>),
  orderPaymentInfo: json['orderPaymentInfo'] == null
      ? null
      : OrderPaymentInfo.fromJson(
          json['orderPaymentInfo'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hash': instance.hash,
      'status': instance.status,
      'clientId': instance.clientId,
      'orderPaymentInfoId': instance.orderPaymentInfoId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'client': instance.client?.toJson(),
      'orderPaymentInfo': instance.orderPaymentInfo?.toJson(),
    };
