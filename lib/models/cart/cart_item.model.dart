import 'package:json_annotation/json_annotation.dart';
import 'package:voucherize/models/services/service.model.dart';

part 'cart_item.model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItem {
  final Service service;
  final int quantity;

  CartItem({required this.service, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
