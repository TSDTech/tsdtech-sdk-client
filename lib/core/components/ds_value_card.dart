import 'package:flutter/material.dart';

class ValueCard extends StatelessWidget {
  final String value;
  final Color textColor;
  final double fontSize;

  const ValueCard({
    super.key,
    required this.value,
    required this.textColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }
}
