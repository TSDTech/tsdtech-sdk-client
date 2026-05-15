import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/checkouts/pix_data.model.dart';

part 'checkout_response.model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckoutResponse {
  final String paymentMethod;
  final String? paymentId;
  final PixData? pix;
  final String? status;
  final String? depositRequestId;
  final String? gatewayBaseUrl;
  final String? publicKeyUrl;

  CheckoutResponse(
      {required this.paymentMethod,
      this.paymentId,
      this.pix,
      this.status,
      this.depositRequestId,
      this.gatewayBaseUrl,
      this.publicKeyUrl});

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutResponseToJson(this);
}
