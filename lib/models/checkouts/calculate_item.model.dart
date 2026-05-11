import 'package:json_annotation/json_annotation.dart';

part 'calculate_item.model.g.dart';

@JsonSerializable()
class CalculateItem {
  final String serviceId;
  final double value;
  final int quantity;

  CalculateItem({
    required this.serviceId,
    required this.value,
    required this.quantity,
  });

  factory CalculateItem.fromJson(Map<String, dynamic> json) =>
      _$CalculateItemFromJson(json);
  Map<String, dynamic> toJson() => _$CalculateItemToJson(this);
}
