import 'package:json_annotation/json_annotation.dart';

part 'signup-request-client.model.g.dart';

@JsonSerializable(explicitToJson: true)
class SignupRequestClient {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String document;
  final String cellphone;
  final String documentType;
  final String administratorId;

  SignupRequestClient({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.document,
    required this.cellphone,
    required this.documentType,
    required this.administratorId,
  });

  factory SignupRequestClient.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestClientFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestClientToJson(this);
}
