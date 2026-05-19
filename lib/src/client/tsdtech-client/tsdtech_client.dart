import 'package:dio/dio.dart';

import '../../../core/constants/constants.dart';
import '../../../core/services/base.api.dart';
import '../../../core/services/intra-api/md-administrators/administrators_service.dart';
import '../../../core/services/intra-api/md-authorizers/api_keys/api_keys_service.dart';
import '../../../core/services/intra-api/md-authorizers/client-users/auth_service.dart';
import '../../../core/services/intra-api/md-authorizers/memberships/memberships_service.dart';
import '../../../core/services/intra-api/md-checkout/checkouts_service.dart';
import '../../../core/services/intra-api/md-clients/clients_service.dart';
import '../../../core/services/intra-api/md-orders/orders_service.dart';
import '../../../core/services/intra-api/md-providers/provider_requests_service.dart';
import '../../../core/services/intra-api/md-services/services/service_types_service.dart';
import '../../../core/services/intra-api/md-services/services/services_service.dart';
import '../../../core/services/intra-api/md-vouchers/vouchers_service.dart';
import '../gateway-client/gateway_client.dart';
import '../../services/gateway-services/gateway_service.dart';

class TsdtechClient {
  TsdtechClient({
    String? baseUrl,
    BaseApi? baseApi,
    Dio? dio,
    String? gatewayBaseUrl,
    String? gatewayApiKey,
  }) : baseUrl = baseUrl ?? Constants.getBaseUrl(),
       baseApi = baseApi ?? BaseApiImpl(dio: dio) {
    auth = AuthServiceClientUser(baseApi: this.baseApi, baseUrl: this.baseUrl);
    administrators = AdministratorsService(
      baseApi: this.baseApi,
      baseUrl: this.baseUrl,
    );
    apiKeys = ApiKeysService(baseApi: this.baseApi, baseUrl: this.baseUrl);
    checkouts = CheckoutsService(baseApi: this.baseApi, baseUrl: this.baseUrl);
    clients = ClientsService(baseApi: this.baseApi, baseUrl: this.baseUrl);
    memberships = MembershipsService(
      baseApi: this.baseApi,
      baseUrl: this.baseUrl,
    );
    orders = OrdersService(baseApi: this.baseApi, baseUrl: this.baseUrl);
    providerRequests = ProviderRequestsService(
      baseApi: this.baseApi,
      baseUrl: this.baseUrl,
    );
    serviceTypes = ServiceTypesService(
      baseApi: this.baseApi,
      baseUrl: this.baseUrl,
    );
    services = ServicesService(baseApi: this.baseApi, baseUrl: this.baseUrl);
    vouchers = VouchersService(baseApi: this.baseApi, baseUrl: this.baseUrl);

    if (gatewayBaseUrl != null && gatewayBaseUrl.isNotEmpty) {
      final gatewayClient = GatewayClient(
        gatewayBaseUrl: gatewayBaseUrl,
        apiKey: gatewayApiKey,
      );
      gateway = GatewayService(gatewayClient);
    }
  }

  factory TsdtechClient.withBaseUrl({
    required String baseUrl,
    String? gatewayBaseUrl,
    String? gatewayApiKey,
  }) {
    return TsdtechClient(
      baseUrl: baseUrl,
      gatewayBaseUrl: gatewayBaseUrl,
      gatewayApiKey: gatewayApiKey,
    );
  }

  factory TsdtechClient.withBaseApi({
    required BaseApi baseApi,
    String? baseUrl,
    String? gatewayBaseUrl,
    String? gatewayApiKey,
  }) {
    return TsdtechClient(
      baseUrl: baseUrl,
      baseApi: baseApi,
      gatewayBaseUrl: gatewayBaseUrl,
      gatewayApiKey: gatewayApiKey,
    );
  }

  final String baseUrl;
  final BaseApi baseApi;

  late final AdministratorsService administrators;
  late final ApiKeysService apiKeys;
  late final AuthServiceClientUser auth;
  late final CheckoutsService checkouts;
  late final ClientsService clients;
  late final MembershipsService memberships;
  late final OrdersService orders;
  late final ProviderRequestsService providerRequests;
  late final ServiceTypesService serviceTypes;
  late final ServicesService services;
  late final VouchersService vouchers;
  GatewayService? gateway;

  void setAuthToken(String? token) {
    baseApi.applyToken(token);
  }

  void clearAuthToken() {
    baseApi.clearToken();
  }
}
