import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';

part 'calculate_response.model.g.dart';

@JsonSerializable()
class CalculateResponse {
  final double totalValue;
  final List<CalculateItem>? cart;

  CalculateResponse({required this.totalValue, this.cart});

  factory CalculateResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CalculateResponseToJson(this);
}
