import 'package:test/test.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:dio/dio.dart';

void main() {
  group('ValueResult', () {
    test('success -> isSuccess true, value accessible', () {
      final r = ValueResult.success(42);
      expect(r.isSuccess, isTrue);
      expect(r.isError, isFalse);
      expect(r.value, isNotNull);
      expect(r.value!, 42);
    });

    test('failure -> isError true, error accessible', () {
      final r = ValueResult.failure('oops', title: 'T');
      expect(r.isError, isTrue);
      expect(r.isSuccess, isFalse);
      expect(r.error, 'oops');
      expect(r.title, 'T');
      expect(() => r.value, throwsA(isA<StateError>()));
    });

    test('fromError with DioException uses exception message fallback', () {
      final requestOptions = RequestOptions(path: '/test');
      final e = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        message: 'network failed',
      );

      final r = ValueResult.fromError(e);
      expect(r.isError, isTrue);
      expect(r.error, contains('network failed'));
      expect(r.title, isNull);
    });

    test('fromError with nested error.message parses response payload', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response(
          requestOptions: requestOptions,
          data: {
            'error': {'message': 'detailed', 'title': 'MyTitle'}
          },
          statusCode: 400);
      final e = DioException(
          requestOptions: requestOptions,
          response: response,
          type: DioExceptionType.badResponse);

      final r = ValueResult.fromError(e);
      expect(r.isError, isTrue);
      expect(r.error, 'detailed');
      expect(r.title, 'MyTitle');
    });

    test('fromError with nested data.detail list extracts first detail', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response(
          requestOptions: requestOptions,
          data: {
            'detail': ['first detail', 'second']
          },
          statusCode: 400);
      final e = DioException(
          requestOptions: requestOptions,
          response: response,
          type: DioExceptionType.badResponse);

      final r = ValueResult.fromError(e);
      expect(r.isError, isTrue);
      expect(r.error, 'first detail');
    });

    test('fold calls correct callbacks', () {
      final success = ValueResult.success('ok');
      final folded = success.fold((v) => 'S:$v', (err) => 'E:$err');
      expect(folded, 'S:ok');

      final fail = ValueResult.failure('err');
      final folded2 = fail.fold((v) => 'S:$v', (err) => 'E:$err');
      expect(folded2, 'E:err');
    });

    test('equality and hashCode', () {
      final a = ValueResult.success(1);
      final b = ValueResult.success(1);
      final c = ValueResult.failure('x');
      final d = ValueResult.failure('x');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(c, equals(d));
      expect(c.hashCode, equals(d.hashCode));
    });
  });
}
