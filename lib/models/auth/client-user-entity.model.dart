import 'package:json_annotation/json_annotation.dart';

part 'client-user-entity.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientUserEntity {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? document;
  final String? documentType;
  final String? twoFactorAuthKey;
  final String? developerPassword;
  final String? administratorId;
  final List<String>? memberships;

  ClientUserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.document,
    this.documentType,
    this.twoFactorAuthKey,
    this.developerPassword,
    this.administratorId,
    this.memberships,
  });

  factory ClientUserEntity.fromJson(Map<String, dynamic> json) =>
      _$ClientUserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClientUserEntityToJson(this);
}
