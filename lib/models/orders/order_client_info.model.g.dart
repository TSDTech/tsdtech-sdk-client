// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_client_info.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderClientInfo _$OrderClientInfoFromJson(Map<String, dynamic> json) =>
    OrderClientInfo(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      administratorId: json['administratorId'] as String?,
      document: json['document'] as String?,
      documentType: json['documentType'] as String?,
      cellphone: json['cellphone'] as String?,
    );

Map<String, dynamic> _$OrderClientInfoToJson(OrderClientInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'administratorId': instance.administratorId,
      'document': instance.document,
      'documentType': instance.documentType,
      'cellphone': instance.cellphone,
    };
