import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/services/service_type.model.dart';

part 'service.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Service {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? administratorId;
  final String? serviceTypeId;
  final ServiceType? serviceType;
  final double? price;
  final List<String>? tags;
  final int? validTimestamp;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Service({
    this.id,
    this.name,
    this.code,
    this.description,
    this.administratorId,
    this.serviceTypeId,
    this.serviceType,
    this.price,
    this.tags,
    this.validTimestamp,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
