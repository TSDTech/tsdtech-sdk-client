import 'package:json_annotation/json_annotation.dart';

part 'order_client_info.model.g.dart';

@JsonSerializable()
class OrderClientInfo {
	final String id;
	final String? firstName;
	final String? lastName;
	final String? email;
	final String? administratorId;
	final String? document;
	final String? documentType;
	final String? cellphone;

	OrderClientInfo({
		required this.id,
		this.firstName,
		this.lastName,
		this.email,
		this.administratorId,
		this.document,
		this.documentType,
		this.cellphone,
	});

	factory OrderClientInfo.fromJson(Map<String, dynamic> json) => _$OrderClientInfoFromJson(json);

	Map<String, dynamic> toJson() => _$OrderClientInfoToJson(this);
}

