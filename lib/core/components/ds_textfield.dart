import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voucherize/core/components/ds_text.dart';

typedef Validator = String? Function(String?);

class DsTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Validator? validator;
  final String? hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final EdgeInsets? contentPadding;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String? errorText;
  final Widget? suffixIcon;


  const DsTextfield({
    Key? key,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.validator,
    this.hintText,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.contentPadding,
    this.errorText,
    this.suffixIcon,
  }) : super(key: key);

  TextStyle? get _hintStyle => DsText.styles[DsTextVariant.normal]?.copyWith(
    color:const Color.fromRGBO(75, 85, 91, 1), // sua cor desejada
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hintText ?? '',
            hintStyle: _hintStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromRGBO(226, 232, 240, 1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromRGBO(226, 232, 240, 1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromRGBO(226, 232, 240, 1),
              ),
            ),
            contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(12, 10, 12, 10), // left, top, right, bottom
            suffixIcon: suffixIcon, 
          ),
          validator: validator,
          onChanged: onChanged,
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: DsText(
              text: errorText!,
              variant: DsTextVariant.small,
              color: Colors.red, // Vermelho para erro
              textAlign: TextAlign.start,
            ),
          ),
      ],
    );
  }
}

class InputRule {
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Validator? validator;
  final String? hintText;

  InputRule({
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.hintText,
  });
}
