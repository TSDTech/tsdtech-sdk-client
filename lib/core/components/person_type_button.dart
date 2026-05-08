import 'package:flutter/material.dart';
import 'package:voucherize/core/components/ds_text.dart';

class PersonTypeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PersonTypeButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color.fromRGBO(0, 87, 168, 1);
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1);
    const hoverColor =
        Color.fromRGBO(230, 240, 255, 1); // Light blue for hover background

    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isHovered,
      builder: (context, hovered, child) {
        return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              onHover: (hovering) {
                isHovered.value = hovering;
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(229, 231, 235, 1), width: 1),
                  borderRadius: BorderRadius.circular(8),
                  color: hovered ? hoverColor : Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      alignment: Alignment.center,
                      child: Icon(icon, size: 25, color: activeColor),
                    ),
                    const SizedBox(height: 8),
                    DsText(
                      text: title,
                      variant: DsTextVariant.baseBold,
                      color: activeColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    DsText(
                      text: subtitle,
                      variant: DsTextVariant.small,
                      color: blackTextColor,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
