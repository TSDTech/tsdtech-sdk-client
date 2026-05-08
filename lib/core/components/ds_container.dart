import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voucherize/core/components/ds_text.dart';

class DsContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  // Toggle related optional parameters
  final String? title;
  final bool? minimized;
  final VoidCallback? onToggle;
  final IconData? icon;

  const DsContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.padding = const EdgeInsets.fromLTRB(23, 23, 15, 23),
    this.title,
    this.minimized,
    this.onToggle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final hasToggle = title != null && minimized != null && onToggle != null;

    Widget content = child ?? const SizedBox.shrink();

    if (hasToggle) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon ?? LucideIcons.fileText,
                color: const Color.fromRGBO(0, 87, 168, 1),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DsText(
                  text: title!,
                  variant: DsTextVariant.baseBold,
                  color: const Color.fromRGBO(0, 87, 168, 1),
                  textAlign: TextAlign.left,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  minimized! ? LucideIcons.chevronRight : LucideIcons.chevronDown,
                  color: const Color.fromRGBO(0, 87, 168, 1),
                ),
                onPressed: onToggle,
              ),
            ],
          ),
          if (!minimized!) ...[
            content,
          ],
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(0, 87, 168, 1),
          width: 1,
        ),
      ),
      padding: padding,
      height: height,
      width: width,
      child: hasToggle ? content : child,
    );
  }
}
