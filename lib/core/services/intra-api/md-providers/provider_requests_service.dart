import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/models/providers/provider.model.dart';
import 'package:tsdtech_client_sdk/models/vouchers/provider_request.model.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';

/// Service for managing provider requests and providers.
///
/// This service provides methods for retrieving provider requests
/// associated with vouchers, and listing available providers.
///
/// ## Usage
/// ```dart
/// final providerService = ProviderRequestsService.instance;
///
/// // Get provider requests
/// final requests = await providerService.getProviderRequestsClient(
///   pagination: Pagination(page: 1, pageCount: 20),
///   status: 'pending',
/// );
///
/// // Get all providers
/// final providers = await providerService.getAllProvider(
///   pagination: Pagination(page: 1, pageCount: 20),
///   serviceType: true,
/// );
/// ```
///
/// ## Singleton Pattern
/// Access the service via [ProviderRequestsService.instance].
class ProviderRequestsService extends IntraApi {
  /// Singleton instance of [ProviderRequestsService].
  static final ProviderRequestsService instance = ProviderRequestsService();

  /// Creates a [ProviderRequestsService] instance with the base URL from [Constants].
  ProviderRequestsService() : super();

  /// Retrieves provider requests for the authenticated client.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [clients]: Include client details in the response (optional)
  /// - [service]: Include service details in the response (optional)
  /// - [provider]: Include provider details in the response (optional)
  /// - [voucher]: Include voucher details in the response (optional)
  /// - [administrator]: Include administrator details in the response (optional)
  /// - [status]: Filter by request status (optional, e.g., 'pending', 'approved')
  /// - Returns: [ValueResult] containing a [PaginatedList] of [ProviderRequest] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await providerService.getProviderRequestsClient(
  ///   pagination: Pagination(page: 1, pageCount: 20),
  ///   status: 'pending',
  ///   clients: true,
  ///   service: true,
  /// );
  /// ```
  Future<ValueResult<PaginatedList<ProviderRequest>>>
  getProviderRequestsClient({
    Pagination? pagination,
    bool? clients,
    bool? service,
    bool? provider,
    bool? voucher,
    bool? administrator,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        'status': ?status,
        if (clients != null) 'clients': clients.toString(),
        if (service != null) 'service': service.toString(),
        if (provider != null) 'provider': provider.toString(),
        if (voucher != null) 'voucher': voucher.toString(),
        if (administrator != null) 'administrator': administrator.toString(),
      };
      const path = 'provider-request/client';
      final response = await get(path, queryParameters: queryParams);
      final paginated = PaginatedList<ProviderRequest>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => ProviderRequest.fromJson(item as Map<String, dynamic>),
      );
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Retrieves all providers with optional filtering.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [serviceType]: Include service type details in the response (optional)
  /// - [providerBool]: Include provider details in the response (optional)
  /// - [serviceId]: Filter by service ID (optional)
  /// - Returns: [ValueResult] containing a [PaginatedList] of [ProviderModel] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await providerService.getAllProvider(
  ///   pagination: Pagination(page: 1, pageCount: 20),
  ///   serviceType: true,
  ///   providerBool: true,
  ///   serviceId: 'service-123',
  /// );
  /// ```
  Future<ValueResult<PaginatedList<ProviderModel>>> getAllProvider({
    Pagination? pagination,
    bool? serviceType,
    bool? providerBool,
    String? serviceId,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (serviceType != null) 'serviceType': serviceType.toString(),
        if (providerBool != null) 'provider': providerBool.toString(),
        'serviceId': ?serviceId,
      };
      const path = 'provider-service-types/client';
      final response = await get(path, queryParameters: queryParams);
      final paginated = PaginatedList<ProviderModel>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => ProviderModel.fromJson(item as Map<String, dynamic>),
      );
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
