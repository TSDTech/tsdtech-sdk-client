import 'package:json_annotation/json_annotation.dart';

part 'service_type.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceTypeModel {
  final String id;
  final String? name;
  final String? description;
  final String? administratorId;
  final String? codeRange;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceTypeModel({
    required this.id,
    this.name,
    this.description,
    this.administratorId,
    this.codeRange,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) => _$ServiceTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceTypeModelToJson(this);
}
