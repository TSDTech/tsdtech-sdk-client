import 'package:json_annotation/json_annotation.dart';

part 'pix_data.model.g.dart';

@JsonSerializable()
class PixData {
  final String qrCode;
  final String copyPasteCode;

  PixData({required this.qrCode, required this.copyPasteCode});

  factory PixData.fromJson(Map<String, dynamic> json) =>
      _$PixDataFromJson(json);
  Map<String, dynamic> toJson() => _$PixDataToJson(this);
}
