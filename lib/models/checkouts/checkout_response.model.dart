import 'package:json_annotation/json_annotation.dart';
import 'package:voucherize/models/checkouts/pix_data.model.dart';
import 'package:voucherize/models/checkouts/bill_data.model.dart';

part 'checkout_response.model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckoutResponse {
  final String paymentMethod;
  final String? paymentId;
  final PixData? pix;
  final BillData? bill;
  final String? status;

  CheckoutResponse(
      {required this.paymentMethod,
      this.paymentId,
      this.pix,
      this.bill,
      this.status});

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutResponseToJson(this);
}
