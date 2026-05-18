import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/models/checkouts/payment_method.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/mock_dio.dart';

void main() {
  group('CheckoutsService', () {
    late MockHttpClientAdapter adapter;
    late Dio dio;
    late BaseApi api;
    late CheckoutsService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefsHelper.init();
      adapter = MockHttpClientAdapter();
      dio = createDioWithAdapter(adapter);
      api = BaseApiImpl(dio: dio);
      service = CheckoutsService(
        baseApi: api,
        baseUrl: 'https://example.com',
      );
      BaseApi.setDioForTesting(dio);
    });

    test('accepts injected BaseApi instances', () async {
      adapter.when('GET', '/checkouts/client/methods', [
        {'paymentMethod': 'pix', 'isActive': true}
      ]);

      final result = await service.getPaymentMethods();

      expect(result.isSuccess, isTrue);
      expect(result.value!.single.paymentMethod, 'pix');
      expect(adapter.requests.single.path, contains('https://example.com'));
    });

    test('getPaymentMethods retorna lista de PaymentMethodModel válida', () async {
      final payload = [
        {'paymentMethod': 'pix', 'isActive': true},
        {'paymentMethod': 'card', 'isActive': true, 'installmentNumber': 3}
      ];
      adapter.when('GET', '/checkouts/client/methods', payload);

      final result = await CheckoutsService.instance.getPaymentMethods();
      expect(result.isSuccess, isTrue);
      expect(result.value, isA<List<PaymentMethodModel>>());
      expect(result.value!.length, 2);
      expect(result.value!.first.paymentMethod, 'pix');
    });

    test('calculateCart retorna CalculateResponse calculado', () async {
      final responseJson = {'totalValue': 123.45, 'cart': []};
      adapter.when('POST', '/checkouts/client/calculate', responseJson);

      final request = CalculateRequest(
          cart: [CalculateItem(serviceId: 's1', value: 10.0, quantity: 1)]);
      final result = await CheckoutsService.instance.calculateCart(request);

      expect(result.isSuccess, isTrue);
      expect(result.value!.totalValue, 123.45);
    });

    test('createCheckout returns CheckoutResponse', () async {
      final responseJson = {
        'paymentMethod': 'pix',
        'paymentId': 'p1',
        'status': 'pending'
      };
      adapter.when('POST', '/checkouts/client', responseJson);

      final request =
          CheckoutRequest(cart: [], paymentMethod: 'pix', totalValue: 10.0);
      final result = await CheckoutsService.instance.createCheckout(request);

      expect(result.isSuccess, isTrue);
      expect(result.value!.paymentId, 'p1');
      expect(result.value!.status, 'pending');
    });

    test('getPixStatus returns status string', () async {
      adapter.when(
          'GET', '/checkouts/client/pix/status/p1', {'status': 'completed'});

      final result = await CheckoutsService.instance.getPixStatus('p1');

      expect(result.isSuccess, isTrue);
      expect(result.value, 'completed');
    });

    test('API error results in ValueResult.failure', () async {
      final requestOptions =
          RequestOptions(path: 'https://example.com/checkouts/client/methods');
      final response = Response(
          requestOptions: requestOptions,
          data: {
            'error': {'message': 'api error'}
          },
          statusCode: 400);
      final ex = DioException(
          requestOptions: requestOptions,
          response: response,
          type: DioExceptionType.badResponse);
      adapter.whenThrow('GET', '/checkouts/client/methods', ex);

      final result = await CheckoutsService.instance.getPaymentMethods();
      expect(result.isError, isTrue);
      // Verifica se o parser do ValueResult pegou a mensagem interna correta
      expect(result.error, contains('api error'));
    });
  });
}