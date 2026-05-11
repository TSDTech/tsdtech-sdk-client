import 'package:flutter/material.dart';
import 'ds_text.dart';

class DsRichTextPart {
  final String text;
  final bool bold;
  DsRichTextPart(this.text, {this.bold = false});
}

class DsRichText extends StatelessWidget {
  final List<DsRichTextPart> parts;
  final DsTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;

  const DsRichText({
    super.key,
    required this.parts,
    this.variant = DsTextVariant.base,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = DsText.styles[variant]?.copyWith(color: color);
    final boldStyle =
        DsText.styles[DsTextVariant.baseRegularBold]?.copyWith(color: color);

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: parts.map((part) {
          return TextSpan(
            text: part.text,
            style: part.bold ? boldStyle : baseStyle,
          );
        }).toList(),
      ),
    );
  }
}
