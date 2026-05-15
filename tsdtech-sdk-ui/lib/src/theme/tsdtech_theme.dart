import 'package:flutter/material.dart';
import 'tsdtech_colors.dart';
import 'tsdtech_text_styles.dart';

/// Immutable data class that holds all visual properties consumed by TSDTech
/// UI widgets. Pass a custom instance to [TsdtechUiConfig.initialize] to
/// override the default brand appearance.
///
/// Example — dark theme with a custom primary color:
/// ```dart
/// TsdtechUiConfig.initialize(
///   baseUrl: 'https://api.myapp.com',
///   theme: TsdtechThemeData.dark().copyWith(
///     primaryColor: const Color(0xFF7C3AED),
///   ),
/// );
/// ```
@immutable
class TsdtechThemeData {
  const TsdtechThemeData({
    required this.primaryColor,
    required this.primaryLightColor,
    required this.primaryDarkColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.surfaceVariantColor,
    required this.outlineColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.textDisabledColor,
    required this.textOnPrimaryColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.borderRadius,
    required this.fontFamily,
    required this.brightness,
  });

  // ---------------------------------------------------------------------------
  // Colors
  // ---------------------------------------------------------------------------
  final Color primaryColor;
  final Color primaryLightColor;
  final Color primaryDarkColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color surfaceVariantColor;
  final Color outlineColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textDisabledColor;
  final Color textOnPrimaryColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  // ---------------------------------------------------------------------------
  // Shape & typography
  // ---------------------------------------------------------------------------

  /// Default border radius used by cards, buttons and input fields.
  final double borderRadius;

  /// Optional custom font family. When null, the system default is used.
  final String? fontFamily;

  /// Whether the theme is [Brightness.light] or [Brightness.dark].
  final Brightness brightness;

  // ---------------------------------------------------------------------------
  // Factories
  // ---------------------------------------------------------------------------

  /// Default light theme using the TSDTech brand palette.
  factory TsdtechThemeData.light() {
    return const TsdtechThemeData(
      primaryColor: TsdtechColors.primary,
      primaryLightColor: TsdtechColors.primaryLight,
      primaryDarkColor: TsdtechColors.primaryDark,
      accentColor: TsdtechColors.accent,
      backgroundColor: TsdtechColors.white,
      surfaceColor: TsdtechColors.surface,
      surfaceVariantColor: TsdtechColors.surfaceVariant,
      outlineColor: TsdtechColors.outline,
      textPrimaryColor: TsdtechColors.textPrimary,
      textSecondaryColor: TsdtechColors.textSecondary,
      textDisabledColor: TsdtechColors.textDisabled,
      textOnPrimaryColor: TsdtechColors.textOnPrimary,
      successColor: TsdtechColors.success,
      warningColor: TsdtechColors.warning,
      errorColor: TsdtechColors.error,
      borderRadius: 8.0,
      fontFamily: null,
      brightness: Brightness.light,
    );
  }

  /// Default dark theme using the TSDTech brand palette.
  factory TsdtechThemeData.dark() {
    return const TsdtechThemeData(
      primaryColor: TsdtechColors.primaryLight,
      primaryLightColor: TsdtechColors.accent,
      primaryDarkColor: TsdtechColors.primary,
      accentColor: TsdtechColors.accentLight,
      backgroundColor: TsdtechColors.darkBackground,
      surfaceColor: TsdtechColors.darkSurface,
      surfaceVariantColor: TsdtechColors.darkSurfaceVariant,
      outlineColor: TsdtechColors.darkOutline,
      textPrimaryColor: TsdtechColors.darkTextPrimary,
      textSecondaryColor: TsdtechColors.darkTextSecondary,
      textDisabledColor: TsdtechColors.darkTextDisabled,
      textOnPrimaryColor: TsdtechColors.white,
      successColor: TsdtechColors.success,
      warningColor: TsdtechColors.warning,
      errorColor: TsdtechColors.error,
      borderRadius: 8.0,
      fontFamily: null,
      brightness: Brightness.dark,
    );
  }

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------
  TsdtechThemeData copyWith({
    Color? primaryColor,
    Color? primaryLightColor,
    Color? primaryDarkColor,
    Color? accentColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? surfaceVariantColor,
    Color? outlineColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? textDisabledColor,
    Color? textOnPrimaryColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    double? borderRadius,
    String? fontFamily,
    Brightness? brightness,
  }) {
    return TsdtechThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      primaryLightColor: primaryLightColor ?? this.primaryLightColor,
      primaryDarkColor: primaryDarkColor ?? this.primaryDarkColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      surfaceVariantColor: surfaceVariantColor ?? this.surfaceVariantColor,
      outlineColor: outlineColor ?? this.outlineColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      textDisabledColor: textDisabledColor ?? this.textDisabledColor,
      textOnPrimaryColor: textOnPrimaryColor ?? this.textOnPrimaryColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      borderRadius: borderRadius ?? this.borderRadius,
      fontFamily: fontFamily ?? this.fontFamily,
      brightness: brightness ?? this.brightness,
    );
  }

  // ---------------------------------------------------------------------------
  // Flutter ThemeData bridge
  // ---------------------------------------------------------------------------

  /// Converts this [TsdtechThemeData] into a Flutter [ThemeData] that can be
  /// applied to a [MaterialApp]. Useful when the host app wants to align its
  /// own theme with the TSDTech brand.
  ThemeData toMaterialTheme() {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: textOnPrimaryColor,
      secondary: accentColor,
      onSecondary: textOnPrimaryColor,
      error: errorColor,
      onError: TsdtechColors.white,
      surface: surfaceColor,
      onSurface: textPrimaryColor,
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      textTheme: _buildTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: errorColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: surfaceVariantColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: TsdtechTextStyles.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: outlineColor),
        ),
        elevation: 0,
      ),
    );
  }

  TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TsdtechTextStyles.displayLarge,
      displayMedium: TsdtechTextStyles.displayMedium,
      headlineLarge: TsdtechTextStyles.headlineLarge,
      headlineMedium: TsdtechTextStyles.headlineMedium,
      headlineSmall: TsdtechTextStyles.headlineSmall,
      titleLarge: TsdtechTextStyles.titleLarge,
      titleMedium: TsdtechTextStyles.titleMedium,
      titleSmall: TsdtechTextStyles.titleSmall,
      bodyLarge: TsdtechTextStyles.bodyLarge,
      bodyMedium: TsdtechTextStyles.bodyMedium,
      bodySmall: TsdtechTextStyles.bodySmall,
      labelLarge: TsdtechTextStyles.labelLarge,
      labelMedium: TsdtechTextStyles.labelMedium,
      labelSmall: TsdtechTextStyles.labelSmall,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TsdtechThemeData &&
          runtimeType == other.runtimeType &&
          primaryColor == other.primaryColor &&
          brightness == other.brightness;

  @override
  int get hashCode => Object.hash(primaryColor, brightness);
}
