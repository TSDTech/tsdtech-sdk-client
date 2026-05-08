import 'package:json_annotation/json_annotation.dart';

part 'provider_data.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProviderData {
  final String id;
  final String? email;
  final String? cnpj;
  final String? phoneContact;
  final String? name;
  final String? administratorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProviderData({
    required this.id,
    this.email,
    this.cnpj,
    this.phoneContact,
    this.name,
    this.administratorId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProviderData.fromJson(Map<String, dynamic> json) => _$ProviderDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderDataToJson(this);
}
