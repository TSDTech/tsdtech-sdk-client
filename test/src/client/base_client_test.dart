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

    tearDown(() async {
      await BaseApi.resetToken();
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

    test('timeout errors mapped to friendly message', () async {
      final requestOptions = RequestOptions(
        path: 'https://example.com/timeout',
      );
      final dioEx = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );
      adapter.whenThrow('GET', '/timeout', dioEx);

      try {
        await BaseApi.get('https://example.com/timeout');
        fail('Deveria ter lançado uma exception amigável');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Serviço indisponível no momento'));
      }
    });

    group('Token management', () {
      test(
        'setToken persiste no SharedPrefs e header Authorization é enviado',
        () async {
          await BaseApi.setToken('meu-token-123');

          expect(SharedPrefsHelper.authToken, equals('meu-token-123'));

          adapter.when('GET', '/auth-check', {});
          await BaseApi.get('https://example.com/auth-check');

          final sentHeaders = adapter.requests.last.headers;
          expect(sentHeaders['Authorization'], equals('Bearer meu-token-123'));
        },
      );

      test('setToken não polui dio.options.headers', () async {
        await BaseApi.setToken('qualquer-token');

        expect(dio.options.headers.containsKey('Authorization'), isFalse);
      });

      test('resetToken limpa o token do SharedPrefs', () async {
        await BaseApi.setToken('token-para-limpar');
        expect(SharedPrefsHelper.authToken, isNotNull);

        await BaseApi.resetToken();

        expect(SharedPrefsHelper.authToken, isNull);
      });

      test('resetToken via setToken(null) limpa o SharedPrefs', () async {
        await BaseApi.setToken('outro-token');
        await BaseApi.setToken(null);

        expect(SharedPrefsHelper.authToken, isNull);
      });

      test(
        'token gravado diretamente no SharedPrefs é injetado pelo _mergeHeaders',
        () async {
          await SharedPrefsHelper.setAuthToken('token-via-prefs');

          adapter.when('GET', '/via-prefs', {});
          await BaseApi.get('https://example.com/via-prefs');

          final sentHeaders = adapter.requests.last.headers;
          expect(
            sentHeaders['Authorization'],
            equals('Bearer token-via-prefs'),
          );
        },
      );

      test(
        'listener é notificado com o novo token ao chamar setToken',
        () async {
          String? notified;
          void listener(String? t) => notified = t;
          BaseApi.addTokenListener(listener);

          await BaseApi.setToken('token-listener');

          expect(notified, equals('token-listener'));
          BaseApi.removeTokenListener(listener);
        },
      );

      test('listener é notificado com null ao chamar resetToken', () async {
        await BaseApi.setToken('token-a-limpar');

        String? notified = 'nao-mudou';
        void listener(String? t) => notified = t;
        BaseApi.addTokenListener(listener);

        await BaseApi.resetToken();

        expect(notified, isNull);
        BaseApi.removeTokenListener(listener);
      });

      test('removeTokenListener remove o listener corretamente', () async {
        int callCount = 0;
        void listener(String? t) => callCount++;
        BaseApi.addTokenListener(listener);
        BaseApi.removeTokenListener(listener);

        await BaseApi.setToken('qualquer');

        expect(callCount, equals(0));
      });
    });
  });

  group('Token management', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();
    });

    tearDown(() async {
      await BaseApi.resetToken();
    });

    test('setToken persiste o token no SharedPrefsHelper', () async {
      await BaseApi.setToken('my-token');
      expect(SharedPrefsHelper.authToken, equals('my-token'));
    });

    test('resetToken limpa o token do SharedPrefsHelper', () async {
      await BaseApi.setToken('to-clear');
      await BaseApi.resetToken();
      expect(SharedPrefsHelper.authToken, isNull);
    });

    test('setToken(null) comporta-se como resetToken', () async {
      await BaseApi.setToken('will-be-cleared');
      await BaseApi.setToken(null);
      expect(SharedPrefsHelper.authToken, isNull);
    });

    test('listener é notificado quando token é definido', () async {
      String? received;
      void listener(String? t) => received = t;
      BaseApi.addTokenListener(listener);
      addTearDown(() => BaseApi.removeTokenListener(listener));

      await BaseApi.setToken('listener-token');
      expect(received, equals('listener-token'));
    });

    test('listener é notificado com null quando token é removido', () async {
      String? received = 'initial';
      void listener(String? t) => received = t;
      BaseApi.addTokenListener(listener);
      addTearDown(() => BaseApi.removeTokenListener(listener));

      await BaseApi.resetToken();
      expect(received, isNull);
    });

    test('removeTokenListener para de notificar', () async {
      int callCount = 0;
      void listener(String? t) => callCount++;
      BaseApi.addTokenListener(listener);
      BaseApi.removeTokenListener(listener);

      await BaseApi.setToken('no-notification');
      expect(callCount, equals(0));
    });

    test('múltiplos listeners são todos notificados', () async {
      final received = <String?>[];
      void l1(String? t) => received.add('l1:$t');
      void l2(String? t) => received.add('l2:$t');
      BaseApi.addTokenListener(l1);
      BaseApi.addTokenListener(l2);
      addTearDown(() {
        BaseApi.removeTokenListener(l1);
        BaseApi.removeTokenListener(l2);
      });

      await BaseApi.setToken('multi');
      expect(received, containsAll(['l1:multi', 'l2:multi']));
    });
  });
}
