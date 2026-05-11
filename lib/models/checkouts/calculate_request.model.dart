import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';

part 'calculate_request.model.g.dart';

@JsonSerializable(explicitToJson: true)
class CalculateRequest {
  final List<CalculateItem> cart;

  CalculateRequest({required this.cart});

  factory CalculateRequest.fromJson(Map<String, dynamic> json) => _$CalculateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CalculateRequestToJson(this);
}