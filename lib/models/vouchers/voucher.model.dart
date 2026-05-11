import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/models/auth/client-user-entity.model.dart';

part 'voucher.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Voucher {
  final String id;
  final String serviceId;
  final String? formId;
  final String code;
  final String status;
  // optional fields (backend may not provide all)
  final String? orderId;
  final String? clientId;
  final String? validity;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  // Nested objects returned when populate flags are true
  final Service? service;
  final ClientUserEntity? client;
  final Map<String, dynamic>? order;

  Voucher({
    required this.id,
    required this.serviceId,
    required this.status,
    required this.code,
    this.formId,
    this.orderId,
    this.clientId,
    this.validity,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.service,
    this.client,
    this.order,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}
