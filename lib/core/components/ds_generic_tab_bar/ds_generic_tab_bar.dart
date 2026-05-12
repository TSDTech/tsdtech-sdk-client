// core/components/ds_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_generic_tab_bar/ds_tab_button.dart';

class DsGenericTabBar<T> extends StatelessWidget {
  final List<DsTab<T>> tabs;
  final T selectedValue;
  final ValueChanged<T> onTabSelected;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  const DsGenericTabBar({
    super.key,
    required this.tabs,
    required this.selectedValue,
    required this.onTabSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Row(
        children: [
          for (final tab in tabs) ...[
            Expanded(
              child: TabButton(
                tab: tab,
                isSelected: tab.value == selectedValue,
                onTap: () => onTabSelected(tab.value),
              ),
            ),
            if (tab != tabs.last) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}
