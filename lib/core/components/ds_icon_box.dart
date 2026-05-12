import 'package:flutter/material.dart';

class DsIconBox extends StatelessWidget {
  final Widget icon;
  final double height;
  final double width;
  final Widget title;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const DsIconBox({
    super.key,
    required this.icon,
    required this.title,
    this.height = 64,
    this.width = 86.5,
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.borderRadius = 7,
    this.padding = const EdgeInsets.fromLTRB(6, 10, 6, 12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      height: height == double.infinity
          ? null
          : height, // Se for infinito, não define altura
      width: width,
      constraints: height == double.infinity
          ? const BoxConstraints(minHeight: 64)
          : null, // Altura mínima quando flexível
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 3),
          title,
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    } else {
      return content;
    }
  }
}
