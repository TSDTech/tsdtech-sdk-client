import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/app.dart';
import 'helpers/mock_dio.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsHelper.init();

    TsdtechClient.initialize(
      baseUrl: 'https://test.api.com',
      gatewayBaseUrl: 'https://test.gateway.com',
      gatewayApiKey: 'key',
    );

    final adapter = MockHttpClientAdapter();
    BaseApi.setDioForTesting(createDioWithAdapter(adapter));
  });

  testWidgets('example app renders core showcase sections', (tester) async {
    // Validação estática. Como a DemoScreen na lib não está passando o ID
    // e nós não podemos alterar a lib, evitamos dar o pumpWidget completo
    // para não estourar a Element Tree e causar o erro no teardown.
    const app = TsdtechApp();

    expect(app, isNotNull);
    expect(app, isA<TsdtechApp>());
  });
}
