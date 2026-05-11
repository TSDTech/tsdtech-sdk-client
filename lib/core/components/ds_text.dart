import 'package:flutter/material.dart';

enum DsTextVariant {
  textVoucher,
  titleVoucher,
  boldTitle,
  base,
  baseBold,
  small,
  title,
  section,
  normal,
  statusBar,
  statusBarNumber,
  baseBoldTab,
  baseBoldMedium,
  smallBold,
  carTitle,
  carDescription,
  carPlate,
  titleText,
  finesTitle,
  foundVehicle,
  baseRegular,
  baseRegularBold,
  carModel,
  plate,
  text,
  debtValueLarge,
  mediumTitle,
  subTitleVoucher,
  smallBoldIcon
}

class DsText extends StatelessWidget {
  final String text;
  final DsTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const DsText({
    super.key,
    required this.text,
    this.variant = DsTextVariant.base,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  // Reduced base styles used across the app. Many legacy variants map to
  // these simpler definitions for consistency and easier maintenance.
  static const TextStyle _small = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w300,
    fontSize: 12,
    height: 16 / 12,
  );

  static const TextStyle _medium = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 19 / 14,
  );

  static const TextStyle _large = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 25 / 18,
  );

  static const TextStyle _bold = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 22 / 16,
  );

  // static const TextStyle _boldTitle = TextStyle(
  //   fontFamily: 'Open Sans',
  //   fontWeight: FontWeight.w700,
  //   fontSize: 32,
  //   height: 39 / 32,
  // );

  static final Map<DsTextVariant, TextStyle> _styles = {
    // Prefer small
    DsTextVariant.small: _small,
    DsTextVariant.smallBold: _small.copyWith(fontWeight: FontWeight.w600),
    DsTextVariant.smallBoldIcon: _small.copyWith(
        fontSize: 10, height: 12 / 10, fontWeight: FontWeight.w600),

    // Prefer medium
    DsTextVariant.base: _medium,
    DsTextVariant.baseRegular: _medium,
    DsTextVariant.baseBold: _medium.copyWith(fontWeight: FontWeight.w600),
    DsTextVariant.baseRegularBold:
        _medium.copyWith(fontWeight: FontWeight.w700),
    DsTextVariant.baseBoldTab: _medium.copyWith(fontSize: 11, height: 15 / 11),
    DsTextVariant.normal: _medium,
    DsTextVariant.text: _medium,
    DsTextVariant.titleText: _medium,
    DsTextVariant.textVoucher: _medium.copyWith(fontSize: 14, height: 19 / 14),

    // Larger / emphasis
    DsTextVariant.baseBoldMedium: _bold,
    DsTextVariant.title: _large,
    DsTextVariant.section: _large,
    DsTextVariant.mediumTitle: _large,
    DsTextVariant.subTitleVoucher:
        _large.copyWith(fontSize: 24, height: 27 / 24),
    DsTextVariant.titleVoucher: _bold.copyWith(fontSize: 30, height: 39 / 30),

    // Map legacy car/fines/plate variants to medium/large as appropriate
    DsTextVariant.carTitle: _large,
    DsTextVariant.carDescription: _large,
    DsTextVariant.carPlate: _medium,
    DsTextVariant.carModel: _large,
    DsTextVariant.plate: _medium,

    DsTextVariant.finesTitle: _bold,
    DsTextVariant.foundVehicle: _large,
    DsTextVariant.debtValueLarge: _large,
  };

  static Map<DsTextVariant, TextStyle> get styles => _styles;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: color != null
          ? _styles[variant]?.copyWith(color: color)
          : _styles[variant],
      textAlign:
          variant == DsTextVariant.section ? TextAlign.center : textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
