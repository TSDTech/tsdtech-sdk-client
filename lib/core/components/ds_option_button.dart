import 'package:flutter/material.dart';

class DsOptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double? height;
  final EdgeInsets? padding;

  const DsOptionButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.height = 48,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        fixedSize: height != null ? Size.fromHeight(height!) : null,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
        ),
        backgroundColor:
            isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
