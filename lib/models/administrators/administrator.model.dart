import 'package:json_annotation/json_annotation.dart';

part 'administrator.model.g.dart';

@JsonSerializable()
class Administrator {
  final String id;
  final String? email;
  final String? name;
  final String? cnpj;
  final String? phoneContact;
  final List<String>? clients;
  final List<String>? fullDomain;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Administrator({
    required this.id,
    this.email,
    this.name,
    this.cnpj,
    this.phoneContact,
    this.clients,
    this.fullDomain,
    this.createdAt,
    this.updatedAt,
  });

  factory Administrator.fromJson(Map<String, dynamic> json) =>
      _$AdministratorFromJson(json);
  Map<String, dynamic> toJson() => _$AdministratorToJson(this);
}
