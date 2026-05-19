// lib/platform_origin_web.dart
import 'dart:js_interop';

@JS('window.location.origin')
external String get _windowLocationOrigin;

String? platformOrigin() => _windowLocationOrigin;
