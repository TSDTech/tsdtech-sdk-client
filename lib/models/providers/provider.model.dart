import 'package:json_annotation/json_annotation.dart';
import 'provider_data.model.dart';
import 'service_type.model.dart';

part 'provider.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProviderModel{
  final String? providerId;
  final String? serviceTypeId;
  final ProviderData? provider;
  final ServiceTypeModel? serviceType;

  ProviderModel({
    this.providerId,
    this.serviceTypeId,
    this.provider,
    this.serviceType,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => _$ProviderModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderModelToJson(this);
}
