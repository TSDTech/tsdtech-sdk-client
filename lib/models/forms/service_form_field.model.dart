import 'package:json_annotation/json_annotation.dart';

part 'service_form_field.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceFormField {
  final String id;
  final String type;
  final String label;
  @JsonKey(name: 'required')
  final bool isRequired;
  final List<String>? options;
  final String? validationKey;

  ServiceFormField({
    required this.id,
    required this.type,
    required this.label,
    this.isRequired = false,
    this.options,
    this.validationKey,
  });

  factory ServiceFormField.fromJson(Map<String, dynamic> json) =>
      _$ServiceFormFieldFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceFormFieldToJson(this);
}
