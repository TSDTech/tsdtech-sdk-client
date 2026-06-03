import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import '../theme/tsdtech_theme.dart';

/// Supported locales for TSDTech UI widgets.
enum TsdtechLocale { pt, en, es }

/// Global configuration for the TSDTech SDK UI package.
///
/// Call [TsdtechUiConfig.initialize] once at app startup before using any
/// widgets or screens from this package.
///
/// ```dart
/// void main() {
///   TsdtechUiConfig.initialize(
///     baseUrl: 'https://api.yourapp.com',
///     apiKey: 'your-api-key',
///   );
///   runApp(const MyApp());
/// }
/// ```
class TsdtechUiConfig {
  TsdtechUiConfig._();

  static TsdtechUiConfig? _instance;

  /// The singleton instance. Throws if [initialize] has not been called yet.
  static TsdtechUiConfig get instance {
    assert(
      _instance != null,
      'TsdtechUiConfig has not been initialized. '
      'Call TsdtechUiConfig.initialize() before using any TSDTech UI widgets.',
    );
    return _instance!;
  }

  /// Whether [initialize] has been called.
  static bool get isInitialized => _instance != null;

  // ---------------------------------------------------------------------------
  // Configuration fields
  // ---------------------------------------------------------------------------

  /// Base URL of the TSDTech backend (SPA endpoint).
  late final String? baseUrl;

  /// Optional base URL of the payment gateway. Defaults to [baseUrl] when null.
  late final String? gatewayBaseUrl;

  /// Optional API key used to authenticate requests.
  late final String? apiKey;

  /// Theme applied to all TSDTech UI widgets.
  late final TsdtechThemeData theme;

  /// Locale used for all TSDTech UI copy. Defaults to [TsdtechLocale.pt].
  late final TsdtechLocale locale;

  late final Environment? stage;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Initializes the global TSDTech UI configuration.
  ///
  /// Parameters:
  /// - [baseUrl]: Required. Backend SPA base URL.
  /// - [gatewayBaseUrl]: Optional. Payment gateway URL.
  /// - [apiKey]: Optional. API key for authenticated requests.
  /// - [theme]: Optional. Custom [TsdtechThemeData]. Defaults to [TsdtechThemeData.light].
  /// - [locale]: Optional. UI locale. Defaults to [TsdtechLocale.pt].
  static void initialize({
    String? baseUrl,
    String? gatewayBaseUrl,
    String? apiKey,
    TsdtechThemeData? theme,
    TsdtechLocale locale = TsdtechLocale.pt,
    Environment? stage,
  }) {
    // assert(baseUrl.isNotEmpty, 'baseUrl must not be empty.');
    _instance = TsdtechUiConfig._()
      ..baseUrl = baseUrl
      ..gatewayBaseUrl = gatewayBaseUrl
      ..apiKey = apiKey
      ..theme = theme ?? TsdtechThemeData.light()
      ..locale = locale
      ..stage = stage;
  }

  /// Resets the configuration. Intended for use in tests only.
  @visibleForTesting
  static void reset() => _instance = null;
}
