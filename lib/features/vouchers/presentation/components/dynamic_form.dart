import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/vouchers_store.dart';



class DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final props = widget.formSchema["properties"] as Map<String, dynamic>? ?? {};
    final requiredFields = (widget.formSchema["required"] as List?)?.toSet() ?? {};

    Widget buildField(String key, Map<String, dynamic> field) {
      final label = field["label"] ?? key;
      final description = field["description"] ?? "";
      final placeholder = field["placeholder"] ?? "";
      final isRequired = requiredFields.contains(key);
      final type = field["type"] as String? ?? 'string';

      if (type == 'select') {
        // prefer 'options' if present, otherwise fall back to 'enum'
        final options = (field['options'] as List?)?.map((e) => e.toString()).toList() ?? (field['enum'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final value = widget.store.formValues[key]?.toString();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DsText(text: label + (isRequired ? '*' : ''), variant: DsTextVariant.baseBold),
                const SizedBox(width: 8),
                if (description.isNotEmpty)
                  Tooltip(message: description, child: const Icon(Icons.info_outline, size: 16, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: value,
              items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => widget.store.setFormValue(key, v ?? '')),
              decoration: InputDecoration(
                hintText: placeholder,
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              validator: (v) {
                if (isRequired && (v == null || v.isEmpty)) return 'Campo obrigatório';
                return null;
              },
            ),
          ],
        );
      }

      // Text / number / validation / date fallback to text input with validators
      final initial = widget.store.formValues[key]?.toString();
      final keyboardType = (type == 'number') ? TextInputType.number : TextInputType.text;

      String? _validator(String? value) {
        if (isRequired && (value == null || value.isEmpty)) return 'Campo obrigatório';
        final vKey = field['validationKey'] as String?;
        if (vKey == 'cpf' && value != null && value.isNotEmpty) {
          if (!_isValidCPF(value)) return 'CPF inválido';
        }
        return null;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DsText(text: label + (isRequired ? '*' : ''), variant: DsTextVariant.baseBold),
              const SizedBox(width: 8),
              if (description.isNotEmpty)
                Tooltip(message: description, child: const Icon(Icons.info_outline, size: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initial,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            onChanged: (v) => widget.store.setFormValue(key, v),
            validator: _validator,
          ),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...props.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 18), child: buildField(e.key, e.value as Map<String, dynamic>))).toList(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Validate the form and, if valid, collect responses and return a structured
  /// payload matching the backend expected shape:
  /// {
  ///   "form": { "title": "...", "description": "...", "fields": [ { id, type, label, required, validationKey, options, value } ], "metadata": {} }
  /// }
  /// Returns null if validation fails.
  Map<String, dynamic>? validateAndCollect() {
    final valid = _formKey.currentState?.validate() ?? true;
    if (!valid) return null;

    final props = widget.formSchema['properties'] as Map<String, dynamic>? ?? {};
    final List<Map<String, dynamic>> fields = [];
    for (final entry in props.entries) {
      final id = entry.key;
      final field = entry.value as Map<String, dynamic>;
      final Map<String, dynamic> out = {
        'id': id,
        'type': field['type'] ?? 'text',
        'label': field['label'] ?? id,
        'required': (widget.formSchema['required'] as List?)?.contains(id) ?? false,
      };
      if (field.containsKey('validationKey')) out['validationKey'] = field['validationKey'];
      if (field.containsKey('options')) out['options'] = List.from(field['options'] as List);
      // include value collected from store
      out['value'] = widget.store.formValues[id];
      fields.add(out);
    }

    return {
      'form': {
        'title': widget.formSchema['title'] ?? '',
        'description': widget.formSchema['description'] ?? '',
        'fields': fields,
        'metadata': widget.formSchema['metadata'] ?? {},
      }
    };
  }

/// Utility: collect responses from a rendered form into a list of objects
/// Each item will include the field 'id' and the current 'value'.
List<Map<String, dynamic>> collectFormResponses(Map<String, dynamic> formSchema, Map<String, dynamic> values) {
  final props = formSchema['properties'] as Map<String, dynamic>? ?? {};
  final out = <Map<String, dynamic>>[];
  for (final entry in props.entries) {
    final id = entry.key;
    out.add({
      'id': id,
      'value': values[id],
    });
  }
  return out;
}

  // Basic CPF validation (format-insensitive, checks digits)
  bool _isValidCPF(String input) {
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length != 11) return false;
    if (numbers.split('').every((c) => c == numbers[0])) return false; // reject same-digit sequences

    List<int> digits = numbers.split('').map(int.parse).toList();

    int sum = 0;
    for (int i = 0; i < 9; i++) sum += digits[i] * (10 - i);
    int firstCheck = (sum * 10) % 11;
    if (firstCheck == 10) firstCheck = 0;
    if (firstCheck != digits[9]) return false;

    sum = 0;
    for (int i = 0; i < 10; i++) sum += digits[i] * (11 - i);
    int secondCheck = (sum * 10) % 11;
    if (secondCheck == 10) secondCheck = 0;
    if (secondCheck != digits[10]) return false;

    return true;
  }
}

class DynamicForm extends StatefulWidget {
  final Map<String, dynamic> formSchema;
  final VouchersStore store;

  const DynamicForm({
    super.key,
    required this.formSchema,
    required this.store,
  });

  @override
  DynamicFormState createState() => DynamicFormState();
}
