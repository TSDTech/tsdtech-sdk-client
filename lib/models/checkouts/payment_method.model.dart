import 'package:json_annotation/json_annotation.dart';

part 'payment_method.model.g.dart';

@JsonSerializable()
class PaymentMethodModel {
  final String paymentMethod;
  final bool isActive;
  final int? installmentNumber;

  PaymentMethodModel(
      {required this.paymentMethod,
      required this.isActive,
      this.installmentNumber});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
}
