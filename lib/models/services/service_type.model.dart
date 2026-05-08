import 'package:json_annotation/json_annotation.dart';

part 'service_type.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceType {
  final String? id;
  final String? name;
  final String? description;
  final String? administratorId;
  final String? codeRange;
  final List<String>? providers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceType({
    this.id,
    this.name,
    this.description,
    this.administratorId,
    this.codeRange,
    this.providers,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) => _$ServiceTypeFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceTypeToJson(this);
}
