import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

class DsBox extends StatelessWidget {
  final List<String> options;
  final List<bool> values;
  final ValueChanged<int> onChanged;

  const DsBox({
    super.key,
    required this.options,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DsText(
            text: 'Responsável pelo pagamento dos débitos:',
            variant: DsTextVariant.baseBold,
            color: Color.fromRGBO(31, 41, 55, 1),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          ...List.generate(options.length, (i) {
            return RadioListTile<int>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: i,
              groupValue: values.indexWhere((element) => element),
              onChanged: (value) => onChanged(value!),
              title: DsText(
                text: options[i],
                variant: DsTextVariant.normal,
                color: const Color.fromRGBO(31, 41, 55, 1),
                textAlign: TextAlign.left,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              activeColor: const Color.fromRGBO(0, 64, 128, 1),
              splashRadius: 0,
            );
          }),
        ],
      ),
    );
  }
}
