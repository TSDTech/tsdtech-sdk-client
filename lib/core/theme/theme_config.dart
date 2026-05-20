import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/src/ui/config/tsdtech_ui_config.dart';
import 'package:tsdtech_client_sdk/src/ui/theme/tsdtech_theme.dart';

enum DemoThemePreset { brand, ocean, graphite }

class DemoThemeConfig {
  static void configure(DemoThemePreset preset) {
    TsdtechUiConfig.initialize(
      baseUrl: Constants.getBaseUrl(),
      gatewayBaseUrl: Constants.getBaseUrl(),
      apiKey: 'demo-api-key',
      locale: TsdtechLocale.pt,
      theme: themeForPreset(preset),
    );
  }

  static TsdtechThemeData themeForPreset(DemoThemePreset preset) {
    switch (preset) {
      case DemoThemePreset.brand:
        return TsdtechThemeData.light();
      case DemoThemePreset.ocean:
        return TsdtechThemeData.light().copyWith(
          primaryColor: const Color(0xFF005F73),
          primaryLightColor: const Color(0xFF0A9396),
          primaryDarkColor: const Color(0xFF003845),
          accentColor: const Color(0xFFEE9B00),
          surfaceVariantColor: const Color(0xFFE7F4F4),
          outlineColor: const Color(0xFFB8D3D4),
          borderRadius: 18,
          fontFamily: 'Open Sans',
        );
      case DemoThemePreset.graphite:
        return TsdtechThemeData.dark().copyWith(
          primaryColor: const Color(0xFFFF7A59),
          primaryLightColor: const Color(0xFFFFB199),
          primaryDarkColor: const Color(0xFFE85D3A),
          accentColor: const Color(0xFFFFD166),
          backgroundColor: const Color(0xFF121417),
          surfaceColor: const Color(0xFF1C2025),
          surfaceVariantColor: const Color(0xFF242A31),
          outlineColor: const Color(0xFF3C4450),
          textPrimaryColor: const Color(0xFFF5F7FA),
          textSecondaryColor: const Color(0xFFBCC4CF),
          textDisabledColor: const Color(0xFF717B88),
          borderRadius: 22,
          fontFamily: 'Open Sans',
        );
    }
  }

  static String presetLabel(DemoThemePreset preset) {
    switch (preset) {
      case DemoThemePreset.brand:
        return 'Brand';
      case DemoThemePreset.ocean:
        return 'Ocean';
      case DemoThemePreset.graphite:
        return 'Graphite';
    }
  }
}
