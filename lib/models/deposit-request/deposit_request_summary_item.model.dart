import 'package:json_annotation/json_annotation.dart';

part 'deposit_request_summary_item.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositRequestItemSummary {
  final String name;
  final double price;
  final int quantity;

  DepositRequestItemSummary({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory DepositRequestItemSummary.fromJson(Map<String, dynamic> json) =>
      _$DepositRequestItemSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DepositRequestItemSummaryToJson(this);
}
