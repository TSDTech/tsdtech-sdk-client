import 'package:dio/dio.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-administrators/administrators_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/api_keys/api_keys_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/client-users/auth_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/memberships/memberships_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-clients/clients_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-orders/orders_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-providers/provider_requests_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-services/services/service_types_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-services/services/services_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-vouchers/vouchers_service.dart';
import '../gateway-client/gateway_client.dart';
import '../../services/gateway-services/gateway_service.dart';

class TsdtechClient {
  final BaseApi baseApi;
  final GatewayService? gateway;

  late final AdministratorsService administrators;
  late final ApiKeysService apiKeys;
  late final AuthServiceClientUser auth;
  late final CheckoutsService checkouts;
  late final ClientsService clients;
  late final MembershipsService memberships;
  late final OrdersService orders;
  late final ProviderRequestsService providerRequests;
  late final ServicesService services;
  late final ServiceTypesService serviceTypes;
  late final VouchersService vouchers;

  TsdtechClient({
    String? baseUrl,
    Dio? dio,
    BaseApi? baseApi,
    TokenProvider? tokenProvider,
    String? authToken,
    String? gatewayBaseUrl,
    String? gatewayApiKey,
  })  : baseApi = baseApi ??
            BaseApiImpl(
              dio: dio,
              tokenProvider: tokenProvider,
              token: authToken,
            ),
        gateway = gatewayBaseUrl != null && gatewayBaseUrl.isNotEmpty
            ? GatewayService(
                GatewayClient(
                  gatewayBaseUrl: gatewayBaseUrl,
                  apiKey: gatewayApiKey,
                ),
              )
            : null {
    final resolvedBaseUrl = baseUrl ?? Constants.getBaseUrl();

    administrators = AdministratorsService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    apiKeys = ApiKeysService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    auth = AuthServiceClientUser(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    checkouts = CheckoutsService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    clients = ClientsService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    memberships = MembershipsService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    orders = OrdersService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    providerRequests = ProviderRequestsService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    services = ServicesService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    serviceTypes = ServiceTypesService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
    vouchers = VouchersService(
      baseApi: this.baseApi,
      baseUrl: resolvedBaseUrl,
    );
  }

  void setAuthToken(String? token) {
    baseApi.applyToken(token);
  }

  void clearAuthToken() {
    baseApi.clearToken();
  }
}
