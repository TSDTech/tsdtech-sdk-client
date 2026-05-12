import 'package:json_annotation/json_annotation.dart';

enum GatewayPaymentStatus {
  @JsonValue('processing')
  processing,
  @JsonValue('approved')
  approved,
  @JsonValue('declined')
  declined,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
}
