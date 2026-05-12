// lib/platform_origin_web.dart
import 'dart:html' as html;

String? platformOrigin() => html.window.location.origin;
