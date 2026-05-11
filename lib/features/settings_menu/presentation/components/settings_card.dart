import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> links;
  const SettingsCard({super.key, required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DsText(text: title, variant: DsTextVariant.baseBold),
          const SizedBox(height: 16),
          ...links,
        ],
      ),
    );
  }
}
