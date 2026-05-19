// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup-request-client.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequestClient _$SignupRequestClientFromJson(Map<String, dynamic> json) =>
    SignupRequestClient(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      document: json['document'] as String,
      cellphone: json['cellphone'] as String,
      documentType: json['documentType'] as String,
      administratorId: json['administratorId'] as String,
    );

Map<String, dynamic> _$SignupRequestClientToJson(
  SignupRequestClient instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'document': instance.document,
  'cellphone': instance.cellphone,
  'documentType': instance.documentType,
  'administratorId': instance.administratorId,
};
