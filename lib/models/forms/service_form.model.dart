import 'package:json_annotation/json_annotation.dart';
import 'service_form_field.model.dart';

part 'service_form.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceForm {
  final String id;
  final String title;
  final String? clientId;
  final String? description;
  final Map<String, dynamic>? metadata;
  final List<ServiceFormField> fields;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceForm({
    required this.id,
    required this.title,
    this.clientId,
    this.description,
    this.metadata,
    required this.fields,
    this.createdAt,
    this.updatedAt,
  });

  /// The API can return either the form directly or an envelope { id, form: { ... } }.
   factory ServiceForm.fromJson(Map<String, dynamic> json) => _$ServiceFormFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceFormToJson(this);
}
