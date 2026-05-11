import 'package:json_annotation/json_annotation.dart';

part 'bill_data.model.g.dart';

@JsonSerializable()
class BillData {
  final String pinbankSlipId;
  final String base64Path;
  final String digitableLine;
  final String barCode;
  final String digitalAccountPinbankId;

  BillData({
    required this.pinbankSlipId,
    required this.base64Path,
    required this.digitableLine,
    required this.barCode,
    required this.digitalAccountPinbankId,
  });

  factory BillData.fromJson(Map<String, dynamic> json) =>
      _$BillDataFromJson(json);
  Map<String, dynamic> toJson() => _$BillDataToJson(this);
}
