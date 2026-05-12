import 'package:json_annotation/json_annotation.dart';

part 'api_key.model.g.dart';

@JsonSerializable()
class ApiKey {
  final String id;
  final String? organizationId;
  final String name;
  final String? rawKey;

  ApiKey(
      {required this.id, this.organizationId, required this.name, this.rawKey});

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);
}
