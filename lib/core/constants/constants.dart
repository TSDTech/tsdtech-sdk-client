import 'package:tsdtech_client_sdk/core/constants/platform/platform_origin.dart';

class Constants {
  static const String stage = String.fromEnvironment(
    'STAGE',
    defaultValue: 'dev',
  );

  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue:
        'https://$stage-voucherize-backend-480088766073.southamerica-east1.run.app',
  );

  static const frontendUrl = String.fromEnvironment(
    'FRONTEND_URL',
    defaultValue:
        'https://$stage-voucherize-client-front-480088766073.southamerica-east1.run.app',
  );

  static String getBaseUrl() => backendUrl;

  static String getMsUrl(String msName) => 'https://$stage-$msName-415041877599.southamerica-east1.run.app';

  static String get fullDomain {
    if (frontendUrl.isNotEmpty) return Uri.parse(frontendUrl).host;

    final origin = platformOrigin();
    if (origin != null && Uri.parse(origin).host == 'localhost') {
      return Uri.parse(frontendUrl).host;
    }

    return origin != null ? Uri.parse(origin).host : Uri.parse(backendUrl).host;
  }
}
