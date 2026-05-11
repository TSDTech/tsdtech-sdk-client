import 'package:json_annotation/json_annotation.dart';

part 'order_payment_info.model.g.dart';

@JsonSerializable()
class OrderPaymentInfo {
  final String id;
  final String? paymentMethod;
  final double? cartTotalValue;
  final int? installmentNumber;

  OrderPaymentInfo({
    required this.id,
    this.paymentMethod,
    this.cartTotalValue,
    this.installmentNumber,
  });

  factory OrderPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentInfoToJson(this);
}
