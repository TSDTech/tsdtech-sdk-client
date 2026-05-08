import 'package:json_annotation/json_annotation.dart';
import 'client-user-token-data.model.dart';
import 'client-user-entity.model.dart';

part 'login-response-client.model.g.dart';

@JsonSerializable()
class LoginResponseClient {
  final ClientUserTokenData? data;
  final ClientUserEntity? entity;
  final String token;
  final int expiresAt;

  LoginResponseClient({
    this.data,
    this.entity,
    required this.token,
    required this.expiresAt,
  });

  factory LoginResponseClient.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseClientFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseClientToJson(this);
}
