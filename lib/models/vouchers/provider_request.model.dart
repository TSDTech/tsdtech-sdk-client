import 'package:json_annotation/json_annotation.dart';
import 'package:voucherize/models/vouchers/voucher.model.dart';
import 'package:voucherize/models/services/service.model.dart';
import 'package:voucherize/models/auth/client-user-entity.model.dart';

part 'provider_request.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProviderRequest {
  final String id;

  // Backend identifiers
  final String? voucherId;
  final String? providerId;
  final String? serviceId;
  final String? formId;
  final String? clientId;
  final String? administratorId;

  final String? createdAt;
  final String? updatedAt;

  // Nested objects
  final Voucher? voucher;
  final Map<String, dynamic>? provider;
  final Service? service;
  final ClientUserEntity? client;

  // Existing UI-oriented fields (kept for backward compatibility)
  final String voucherServiceId;
  final String serviceName;
  final String status;
  final String result; // e.g., 'Aprovado'
  final String inspector;
  final DateTime? inspectionDate;
  final DateTime? appointmentDate;
  final DateTime? completedDate;
  final String plate;
  final String renavam;
  final String model;
  final String year;
  final String observacoes;

  ProviderRequest({
    required this.id,
    this.voucherId,
    this.providerId,
    this.serviceId,
    this.formId,
    this.clientId,
    this.administratorId,
    this.createdAt,
    this.updatedAt,
    this.voucher,
    this.provider,
    this.service,
    this.client,
    this.voucherServiceId = '',
    this.serviceName = '',
    this.status = '',
    this.result = '',
    this.inspector = '',
    this.inspectionDate,
    this.appointmentDate,
    this.completedDate,
    this.plate = '',
    this.renavam = '',
    this.model = '',
    this.year = '',
    this.observacoes = '',
  });

  factory ProviderRequest.fromJson(Map<String, dynamic> json) => _$ProviderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderRequestToJson(this);
}
