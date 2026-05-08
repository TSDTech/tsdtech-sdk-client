// lib/core/components/ds_generic_tab_bar/ds_tab_button.dart
import 'package:flutter/material.dart';
import 'package:voucherize/core/components/ds_text.dart';

class TabButton<T> extends StatelessWidget {
  final DsTab<T> tab;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const selectedBg = Color(0xFF0057A8);
    const unselectedBg = Color(0xFFF8F9FA);
    const unselectedFg = Color(0xFF64748B);
    final radius = BorderRadius.circular(8);

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Aba ${tab.label}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isSelected ? null : onTap,
            borderRadius: radius,
            splashFactory: InkRipple.splashFactory,
            child: Ink(
              decoration: BoxDecoration(
                color: isSelected ? selectedBg : unselectedBg,
                borderRadius: radius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Center(
                  child: DsText(
                    text: tab.label,
                    variant: DsTextVariant.small,
                    color: isSelected ? Colors.white : unselectedFg,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DsTab<T> {
  final String label;
  final T value;
  const DsTab(this.label, this.value);
}
