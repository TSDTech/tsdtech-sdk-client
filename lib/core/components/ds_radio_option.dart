import 'package:flutter/material.dart';

class DsRadioOption<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final EdgeInsets? padding;
  final Color activeColor;
  final bool showBorder;
  final bool useCompactLayout;

  const DsRadioOption({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.padding,
    this.activeColor = const Color(0xFF0057A8),
    this.showBorder = true,
    this.useCompactLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;

    Widget radioButton = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: activeColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    Widget content;

    if (useCompactLayout) {
      // Layout compacto - apenas título em linha
      content = Row(
        children: [
          radioButton,
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'Open Sans',
            ),
          ),
        ],
      );
    } else {
      // Layout completo - com subtítulo e espaçamento maior
      content = Row(
        children: [
          radioButton,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? activeColor : Colors.black87,
                    fontFamily: 'Open Sans',
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? activeColor.withOpacity(0.8)
                          : Colors.grey[600],
                      fontFamily: 'Open Sans',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    Widget child = content;

    if (showBorder && !useCompactLayout) {
      child = Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
        ),
        child: content,
      );
    } else if (padding != null) {
      child = Padding(
        padding: padding!,
        child: content,
      );
    }

    return GestureDetector(
      onTap: () => onChanged(value),
      child: child,
    );
  }
}
