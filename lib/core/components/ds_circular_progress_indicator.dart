import 'package:flutter/material.dart';

class DsCircularProgressIndicator extends StatelessWidget {
  final double? value;
  final Color? backgroundColor;
  final Animation<Color?>? valueColor;
  final double strokeWidth;
  final String? semanticsLabel;
  final String? semanticsValue;

  const DsCircularProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth = 4.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      backgroundColor: backgroundColor,
      valueColor:
          valueColor ?? const AlwaysStoppedAnimation<Color>(Color(0xFF0057A8)),
      strokeWidth: strokeWidth,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
  }
}
