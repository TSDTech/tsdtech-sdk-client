import 'package:json_annotation/json_annotation.dart';
import 'package:tsdtech_client_sdk/models/deposit-request/deposit_request_summary_item.model.dart';

part 'deposit_request_summary.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DepositRequestSummaryResponse {
  final String id;
  final double amount;
  //final double? totalAmount;
  final String createdAtUtc;
  final String depositRequestId;
  //final double? feeAmount;

  @JsonKey(name: 'items_summary')
  final List<DepositRequestItemSummary> itemsSummary;

  DepositRequestSummaryResponse({
    required this.id,
    required this.amount,
    //this.totalAmount,
    required this.createdAtUtc,
    required this.depositRequestId,
    //this.feeAmount,
    required this.itemsSummary,
  });

  factory DepositRequestSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$DepositRequestSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepositRequestSummaryResponseToJson(this);
}
