import 'package:flutter/material.dart';
import 'tsdtech_colors.dart';

/// Standardized text styles for TSDTech UI widgets.
///
/// All sizes follow an 8-pt grid scale and use the system default font family,
/// so they inherit the host app's font unless overridden via [TsdtechThemeData].
abstract final class TsdtechTextStyles {
  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: TsdtechColors.textPrimary,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: TsdtechColors.textPrimary,
    height: 1.15,
  );

  // ---------------------------------------------------------------------------
  // Headline
  // ---------------------------------------------------------------------------
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: TsdtechColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: TsdtechColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: TsdtechColors.textPrimary,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // Title
  // ---------------------------------------------------------------------------
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: TsdtechColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TsdtechColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: TsdtechColors.textPrimary,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: TsdtechColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TsdtechColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TsdtechColors.textSecondary,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // Label
  // ---------------------------------------------------------------------------
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: TsdtechColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: TsdtechColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: TsdtechColors.textSecondary,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Caption / overline
  // ---------------------------------------------------------------------------
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TsdtechColors.textDisabled,
    height: 1.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: TsdtechColors.textSecondary,
    height: 1.6,
  );
}
