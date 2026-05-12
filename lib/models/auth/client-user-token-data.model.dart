import 'package:json_annotation/json_annotation.dart';

part 'client-user-token-data.model.g.dart';

@JsonSerializable()
class ClientUserTokenData {
  final String? id;
  final String? name;
  final String? secondName;
  final String? email;
  final String? phone;
  final String? cpf;
  final bool? is2FAAuthorized;
  final int? expiresAt;

  ClientUserTokenData({
    this.id,
    this.name,
    this.secondName,
    this.email,
    this.phone,
    this.cpf,
    this.is2FAAuthorized,
    this.expiresAt,
  });

  bool isTokenExpired() {
    if (expiresAt == null) return true;
    final currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch;
    return currentTimeInSeconds >= expiresAt!;
  }

  factory ClientUserTokenData.fromJson(Map<String, dynamic> json) =>
      _$ClientUserTokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClientUserTokenDataToJson(this);
}
