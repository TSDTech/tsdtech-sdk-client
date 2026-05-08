import 'package:flutter/material.dart';
import 'package:voucherize/core/components/ds_text.dart';

class SettingsLink extends StatelessWidget {
  final String label;
  const SettingsLink(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DsText(
        text: label,
        variant: DsTextVariant.base,
        color: const Color(0xFF2563EB),
      ),
    );
  }
}
