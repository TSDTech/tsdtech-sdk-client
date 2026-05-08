// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderRequest _$ProviderRequestFromJson(Map<String, dynamic> json) =>
    ProviderRequest(
      id: json['id'] as String,
      voucherId: json['voucherId'] as String?,
      providerId: json['providerId'] as String?,
      serviceId: json['serviceId'] as String?,
      formId: json['formId'] as String?,
      clientId: json['clientId'] as String?,
      administratorId: json['administratorId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      voucher: json['voucher'] == null
          ? null
          : Voucher.fromJson(json['voucher'] as Map<String, dynamic>),
      provider: json['provider'] as Map<String, dynamic>?,
      service: json['service'] == null
          ? null
          : Service.fromJson(json['service'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : ClientUserEntity.fromJson(json['client'] as Map<String, dynamic>),
      voucherServiceId: json['voucherServiceId'] as String? ?? '',
      serviceName: json['serviceName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      result: json['result'] as String? ?? '',
      inspector: json['inspector'] as String? ?? '',
      inspectionDate: json['inspectionDate'] == null
          ? null
          : DateTime.parse(json['inspectionDate'] as String),
      appointmentDate: json['appointmentDate'] == null
          ? null
          : DateTime.parse(json['appointmentDate'] as String),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      plate: json['plate'] as String? ?? '',
      renavam: json['renavam'] as String? ?? '',
      model: json['model'] as String? ?? '',
      year: json['year'] as String? ?? '',
      observacoes: json['observacoes'] as String? ?? '',
    );

Map<String, dynamic> _$ProviderRequestToJson(ProviderRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'voucherId': instance.voucherId,
      'providerId': instance.providerId,
      'serviceId': instance.serviceId,
      'formId': instance.formId,
      'clientId': instance.clientId,
      'administratorId': instance.administratorId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'voucher': instance.voucher?.toJson(),
      'provider': instance.provider,
      'service': instance.service?.toJson(),
      'client': instance.client?.toJson(),
      'voucherServiceId': instance.voucherServiceId,
      'serviceName': instance.serviceName,
      'status': instance.status,
      'result': instance.result,
      'inspector': instance.inspector,
      'inspectionDate': instance.inspectionDate?.toIso8601String(),
      'appointmentDate': instance.appointmentDate?.toIso8601String(),
      'completedDate': instance.completedDate?.toIso8601String(),
      'plate': instance.plate,
      'renavam': instance.renavam,
      'model': instance.model,
      'year': instance.year,
      'observacoes': instance.observacoes,
    };
