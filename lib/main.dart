/// TSDTech Client SDK - HTTP Client for TSDTech Platform
///
/// This is a pure Dart SDK for integrating with the TSDTech payment platform.
/// It provides HTTP clients and services for payment operations.
///
/// ## Usage
/// ```dart
/// import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
///
/// // Configure the base URL
/// Constants.setBaseUrl('https://api.seu-servidor.com');
///
/// // Use services
/// final checkoutService = CheckoutsService.instance;
/// final result = await checkoutService.createCheckout(request);
/// ```
library tsdtech_client_sdk;

export 'tsdtech_sdk_client.dart';
