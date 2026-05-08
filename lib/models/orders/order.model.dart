import 'package:json_annotation/json_annotation.dart';

import 'order_client_info.model.dart';
import 'order_payment_info.model.dart';

part 'order.model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
	final String id;
	final String? hash;
	final String? status;
	final String? clientId;
	final String? orderPaymentInfoId;
	final DateTime? createdAt;
	final DateTime? updatedAt;
	final OrderClientInfo? client;
	final OrderPaymentInfo? orderPaymentInfo;

	OrderModel({
		required this.id,
		this.hash,
		this.status,
		this.clientId,
		this.orderPaymentInfoId,
		this.createdAt,
		this.updatedAt,
		this.client,
		this.orderPaymentInfo,
	});

	factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

	Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

