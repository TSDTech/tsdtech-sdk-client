import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/services/sdk_token_interceptor.dart';

import '../../helpers/mock_dio.dart';

const _baseUrl = 'https://api.example.com';
const _pixTokenUrl = '$_baseUrl/auth/sdk/pix-token';
const _orgId = 'org-test';

void main() {
  group('SdkTokenInterceptor', () {
    late MockHttpClientAdapter mainAdapter;
    late MockHttpClientAdapter tokenAdapter;
    late Dio mainDio;
    late Dio tokenDio;
    late SdkTokenInterceptor interceptor;
    bool sessionExpiredCalled = false;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();
      sessionExpiredCalled = false;

      mainAdapter = MockHttpClientAdapter();
      tokenAdapter = MockHttpClientAdapter();
      mainDio = createDioWithAdapter(mainAdapter);
      tokenDio = createDioWithAdapter(tokenAdapter);

      interceptor = SdkTokenInterceptor.withTokenDio(
        mainDio: mainDio,
        tokenDio: tokenDio,
        orgId: _orgId,
        pixTokenUrl: _pixTokenUrl,
        onSessionExpired: () => sessionExpiredCalled = true,
      );
      mainDio.interceptors.add(interceptor);
    });

    tearDown(() async {
      await SharedPrefsHelper.clearAuthToken();
    });

    // -------------------------------------------------------------------------
    // Auto-init
    // -------------------------------------------------------------------------

    group('auto-init (sem token no SharedPrefs)', () {
      test('busca token do pix-token antes da primeira request', () async {
        tokenAdapter.when('POST', '/auth/sdk/pix-token', {
          'token': 'jwt-inicial',
        });
        mainAdapter.when('GET', '/recurso', {'data': 'ok'});

        await mainDio.get('$_baseUrl/recurso');

        expect(SharedPrefsHelper.authToken, equals('jwt-inicial'));
        expect(
          mainAdapter.requests.last.headers['Authorization'],
          equals('Bearer jwt-inicial'),
        );
      });

      test('orgId correto é enviado ao pix-token', () async {
        tokenAdapter.when('POST', '/auth/sdk/pix-token', {'token': 'tk'});
        mainAdapter.when('GET', '/recurso', {});

        await mainDio.get('$_baseUrl/recurso');

        final tokenReq = tokenAdapter.requests.last;
        expect(tokenReq.data, containsPair('orgId', _orgId));
      });

      test(
        'chama onSessionExpired e rejeita request se pix-token falha',
        () async {
          // Token endpoint retorna 500 → DioException → _doRefresh retorna null
          tokenAdapter.when('POST', '/auth/sdk/pix-token', {
            'error': 'server error',
          }, statusCode: 500);

          try {
            await mainDio.get('$_baseUrl/recurso');
            fail('Deveria lançar DioException');
          } catch (e) {
            expect(e, isA<DioException>());
          }

          expect(sessionExpiredCalled, isTrue);
          expect(SharedPrefsHelper.authToken, isNull);
        },
      );
    });

    // -------------------------------------------------------------------------
    // Token já presente no SharedPrefs
    // -------------------------------------------------------------------------

    group('com token existente no SharedPrefs', () {
      setUp(() async {
        await SharedPrefsHelper.setAuthToken('token-existente');
      });

      test('não chama pix-token se token já existe', () async {
        mainAdapter.when('GET', '/recurso', {'data': 'ok'});

        await mainDio.get('$_baseUrl/recurso');

        expect(
          tokenAdapter.requests.any((r) => r.path.contains('pix-token')),
          isFalse,
        );
      });

      test('injeta token do SharedPrefs no header Authorization', () async {
        mainAdapter.when('GET', '/recurso', {'data': 'ok'});

        await mainDio.get('$_baseUrl/recurso');

        expect(
          mainAdapter.requests.last.headers['Authorization'],
          equals('Bearer token-existente'),
        );
      });
    });

    // -------------------------------------------------------------------------
    // Auto-refresh em 401
    // -------------------------------------------------------------------------

    group('refresh em 401', () {
      test('401 → obtém novo token → retry transparente', () async {
        await SharedPrefsHelper.setAuthToken('token-expirado');

        // Primeira chamada: 401. Segunda (retry pelo interceptor): 200.
        mainAdapter.whenOnce('GET', '/protegido', {
          'error': 'Unauthorized',
        }, statusCode: 401);
        mainAdapter.when('GET', '/protegido', {'ok': true});
        tokenAdapter.when('POST', '/auth/sdk/pix-token', {
          'token': 'token-novo',
        });

        final response = await mainDio.get('$_baseUrl/protegido');

        expect(response.statusCode, equals(200));
        expect(SharedPrefsHelper.authToken, equals('token-novo'));
        // Retry deve ter enviado o novo token
        final retryReq = mainAdapter.requests.last;
        expect(retryReq.headers['Authorization'], equals('Bearer token-novo'));
      });

      test(
        '401 no retry (marcado com _retryKey) limpa token e notifica',
        () async {
          await SharedPrefsHelper.setAuthToken('token-qualquer');
          tokenAdapter.when('POST', '/auth/sdk/pix-token', {
            'token': 'renovado',
          });

          // Ambas as chamadas ao /protegido retornam 401
          mainAdapter.whenOnce('GET', '/protegido', {}, statusCode: 401);
          mainAdapter.when('GET', '/protegido', {}, statusCode: 401);

          try {
            await mainDio.get('$_baseUrl/protegido');
          } on DioException catch (_) {}

          expect(sessionExpiredCalled, isTrue);
          expect(SharedPrefsHelper.authToken, isNull);
        },
      );

      test(
        'refresh falho em 401 limpa token e chama onSessionExpired',
        () async {
          await SharedPrefsHelper.setAuthToken('expirado');

          mainAdapter.when('GET', '/protegido', {}, statusCode: 401);
          // Token endpoint lança erro
          tokenAdapter.when('POST', '/auth/sdk/pix-token', {
            'error': 'fail',
          }, statusCode: 500);

          try {
            await mainDio.get('$_baseUrl/protegido');
          } on DioException catch (_) {}

          expect(sessionExpiredCalled, isTrue);
          expect(SharedPrefsHelper.authToken, isNull);
        },
      );

      test('401 no próprio pix-token não tenta refresh recursivo', () async {
        // Simula pix-token retornando 401
        tokenAdapter.when('POST', '/auth/sdk/pix-token', {}, statusCode: 401);

        // Primeira request sem token → auto-init → 401 do pix-token
        try {
          await mainDio.get('$_baseUrl/recurso');
        } on DioException catch (_) {}

        // Só 1 chamada ao pix-token (sem loop)
        expect(tokenAdapter.requests.length, equals(1));
        expect(sessionExpiredCalled, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // Concorrência: apenas 1 refresh simultâneo
    // -------------------------------------------------------------------------

    group('concorrência', () {
      test(
        'múltiplos refreshes simultâneos disparam apenas 1 chamada ao pix-token',
        () async {
          tokenAdapter.when('POST', '/auth/sdk/pix-token', {
            'token': 'refreshed',
          });

          // Dispara 3 refreshes concorrentes — apenas 1 deve chegar ao adapter.
          await Future.wait([
            interceptor.refreshTokenForTesting(),
            interceptor.refreshTokenForTesting(),
            interceptor.refreshTokenForTesting(),
          ]);

          final pixTokenCalls = tokenAdapter.requests
              .where((r) => r.path.contains('pix-token'))
              .length;
          expect(pixTokenCalls, equals(1));
          expect(SharedPrefsHelper.authToken, equals('refreshed'));
        },
      );
    });

    // -------------------------------------------------------------------------
    // Não interfere com o token endpoint
    // -------------------------------------------------------------------------

    test('requests ao pix-token passam diretamente sem interceptar', () async {
      tokenAdapter.when('POST', '/auth/sdk/pix-token', {'token': 'x'});

      // Chama diretamente o tokenDio (sem interceptor)
      final r = await tokenDio.post(_pixTokenUrl, data: {'orgId': _orgId});
      expect(r.data?['token'], equals('x'));
      // Nenhuma chamada extra foi disparada
      expect(tokenAdapter.requests.length, equals(1));
    });
  });
}
