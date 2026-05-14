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
      adapter = MockHttpClientAdapter();
      dio = createDioWithAdapter(adapter);
      BaseApi.setDioForTesting(dio);
      // Reset shared prefs mock
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();
    });

    test('joinUrl removes trailing slash and joins path correctly', () {
      final intra = IntraApi('https://api.example.com/');
      final joined = intra.joinUrl('https://api.example.com/', 'path');
      expect(joined, equals('https://api.example.com/path'));

      final joined2 = intra.joinUrl('https://api.example.com', '/path');
      expect(joined2, equals('https://api.example.com/path'));
    });

    test('Auth token added when provider returns token', () async {
      SharedPreferences.setMockInitialValues({'auth_token': 'abc123'});
      await SharedPrefsHelper.init();

      adapter.when('GET', '/test-auth', {});

      await BaseApi.get('https://example.com/test-auth');

      expect(dio.options.headers['Authorization'], 'Bearer abc123');
    });

    test('Auth header not added when token is null', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();

      adapter.when('GET', '/test-noauth', {});

      await BaseApi.get('https://example.com/test-noauth');

      expect(dio.options.headers.containsKey('Authorization'), isFalse);
    });

    test('timeout errors mapped to friendly message', () async {
      final requestOptions =
          RequestOptions(path: 'https://example.com/timeout');
      final dioEx = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout);
      adapter.whenThrow('GET', '/timeout', dioEx);

      try {
        await BaseApi.get('https://example.com/timeout');
        fail('Expected exception');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Serviço indisponível'));
      }
    });

    test('HTTP methods call Dio with correct method and path', () async {
      adapter.when('GET', '/resource', {});
      await BaseApi.get('https://example.com/resource');
      expect(adapter.requests.last.method, 'GET');
      expect(adapter.requests.last.path.endsWith('/resource'), isTrue);

      adapter.when('POST', '/resource', {});
      await BaseApi.post('https://example.com/resource', data: {'a': 1});
      expect(adapter.requests.last.method, 'POST');

      adapter.when('PUT', '/resource', {});
      await BaseApi.put('https://example.com/resource', data: {'a': 1});
      expect(adapter.requests.last.method, 'PUT');

      adapter.when('PATCH', '/resource', {});
      await BaseApi.patch('https://example.com/resource', data: {'a': 1});
      expect(adapter.requests.last.method, 'PATCH');

      adapter.when('DELETE', '/resource', {});
      await BaseApi.delete('https://example.com/resource');
      expect(adapter.requests.last.method, 'DELETE');
    });
  });
}
