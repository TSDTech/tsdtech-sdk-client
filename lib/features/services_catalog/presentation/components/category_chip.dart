import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip(
      {required this.label,
      required this.selected,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF6FF) : const Color(0xFFF8FAFB),
          border: Border.all(
              color:
                  selected ? const Color(0xFFD6E9FF) : const Color(0xFFE6E9EE)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  const BoxShadow(
                      color: Color.fromRGBO(11, 102, 255, 0.06),
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]
              : null,
        ),
        child: DsText(
          text: label,
          variant: DsTextVariant.baseBold,
          color: selected ? const Color(0xFF0B66FF) : const Color(0xFF374151),
        ),
      ),
    );
  }
}
