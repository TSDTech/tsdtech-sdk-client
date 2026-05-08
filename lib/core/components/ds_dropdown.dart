import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voucherize/core/components/ds_text.dart';

class DsDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final String Function(T) getLabel;
  final String? infoMessage;

  const DsDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.getLabel,
    this.hintText,
    this.infoMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DsText(
              text: label,
              variant: DsTextVariant.smallBold,
              color: const Color.fromRGBO(0, 0, 0, 1),
              textAlign: TextAlign.left,
            ),
            if (infoMessage != null) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: infoMessage!,
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 1),
        Container(
          height: 46,
          padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<T>(
            isExpanded: true,
            value: selectedValue,
            hint: DsText(
              text: hintText ?? label,
              variant: DsTextVariant.small,
              color: const Color.fromARGB(255, 0, 0, 0),
              textAlign: TextAlign.left,
            ),
            icon: const Icon(LucideIcons.chevronDown, size: 16),
            underline: const SizedBox.shrink(),
            dropdownColor: Colors.white,
            onChanged: onChanged,
            items: options.map((option) {
              return DropdownMenuItem<T>(
                  value: option,
                  child: DsText(
                    text: getLabel(option),
                    variant: DsTextVariant.small,
                    color: const Color.fromRGBO(31, 41, 55, 1),
                    textAlign: TextAlign.left,
                  ));
            }).toList(),
          ),
        ),
      ],
    );
  }
}
