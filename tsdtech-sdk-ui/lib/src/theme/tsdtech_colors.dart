import 'package:flutter/material.dart';

/// TSDTech brand color palette.
///
/// Use the semantic tokens (e.g. [TsdtechColors.primary]) instead of raw hex
/// values to stay consistent across light/dark variants.
abstract final class TsdtechColors {
  // ---------------------------------------------------------------------------
  // Brand primaries
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF4D7FE8);
  static const Color primaryDark = Color(0xFF1040B0);

  // ---------------------------------------------------------------------------
  // Accent
  // ---------------------------------------------------------------------------
  static const Color accent = Color(0xFF0EA5E9);
  static const Color accentLight = Color(0xFF38BDF8);
  static const Color accentDark = Color(0xFF0284C7);

  // ---------------------------------------------------------------------------
  // Neutral / surface
  // ---------------------------------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color outline = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoLight = Color(0xFFE0F2FE);

  // ---------------------------------------------------------------------------
  // Dark surface equivalents
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextDisabled = Color(0xFF64748B);
}
