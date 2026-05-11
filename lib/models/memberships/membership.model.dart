import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/auth/client-user-entity.model.dart';

part 'membership.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Membership {
  final String clientUserId;
  final String organizationId;
  final int role;
  final ClientUserEntity? clientUser;

  Membership({
    required this.clientUserId,
    required this.organizationId,
    required this.role,
    this.clientUser,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
