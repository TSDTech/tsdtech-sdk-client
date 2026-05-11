// lib/platform_origin.dart
export 'platform_origin_stub.dart'
    if (dart.library.html) 'platform_origin_web.dart';
