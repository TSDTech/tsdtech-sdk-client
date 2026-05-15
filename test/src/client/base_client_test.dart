import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';

import '../../helpers/mock_dio.dart';

void main() {
  group('BaseApi / IntraApi', () {
    late MockHttpClientAdapter adapter;
    late Dio dio;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();
      
      adapter = MockHttpClientAdapter();
      dio = createDioWithAdapter(adapter);
      BaseApi.setDioForTesting(dio);
    });

    test('joinUrl remove trailing slash e une os paths corretamente', () {
      final intra = IntraApi('https://api.example.com/');
      final joined = intra.joinUrl('https://api.example.com/', 'path');
      expect(joined, equals('https://api.example.com/path'));

      final joined2 = intra.joinUrl('https://api.example.com', '/path');
      expect(joined2, equals('https://api.example.com/path'));
    });

    test('Header de Auth NÃO deve ser adicionado se token for null', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();

      adapter.when('GET', '/test-noauth', {});

      await BaseApi.get('https://example.com/test-noauth');
      
      // Valida que o dio.options não foi poluído
      expect(dio.options.headers.containsKey('Authorization'), isFalse);
    });

    test('Timeout errors são mapeados para a mensagem correta (Serviço indisponível)', () async {
      final requestOptions = RequestOptions(path: 'https://example.com/timeout');
      final dioEx = DioException(requestOptions: requestOptions, type: DioExceptionType.connectionTimeout);
      adapter.whenThrow('GET', '/timeout', dioEx);

      try {
        await BaseApi.get('https://example.com/timeout');
        fail('Deveria ter lançado uma exception amigável');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Serviço indisponível no momento'));
      }
    });
  });
}