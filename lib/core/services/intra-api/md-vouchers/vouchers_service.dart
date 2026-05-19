import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/vouchers/voucher.model.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';

/// Service for managing client vouchers.
///
/// Use this service to retrieve and list vouchers associated with the
/// authenticated client user. All operations return [ValueResult] for
/// consistent error handling.
///
/// ## Usage
/// ```dart
/// final client = TsdtechClient();
/// final vouchersService = client.vouchers;
/// final result = await vouchersService.getVouchersClient(
///   pagination: Pagination(page: 1, pageCount: 20),
///   status: 'active',
/// );
/// ```
///
/// Prefer scoped access via `TsdtechClient.vouchers`.
/// The legacy [VouchersService.instance] singleton remains available for
/// backward compatibility during the migration period.
class VouchersService extends IntraApi {
  /// Singleton instance of [VouchersService].
  @Deprecated(
    'Use TsdtechClient.vouchers to access a scoped service instance. '
    'This legacy singleton will be removed in a future major version.',
  )
  static final VouchersService instance = VouchersService();

  /// Creates a [VouchersService] instance with the base URL from [Constants].
  VouchersService({BaseApi? baseApi, String? baseUrl})
    : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Retrieves a paginated list of vouchers for the authenticated client.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [clients]: Whether to include client details in the response
  /// - [services]: Whether to include service details in the response
  /// - [orders]: Whether to include order details in the response
  /// - [status]: Optional filter by voucher status (e.g., 'active', 'expired')
  /// - Returns: [ValueResult] containing a [PaginatedList] of [Voucher] objects
  ///
  /// ## Error Handling
  /// On failure, [ValueResult.isError] will be true and [ValueResult.error]
  /// contains the error message extracted from the API response.
  Future<ValueResult<PaginatedList<Voucher>>> getVouchersClient({
    Pagination? pagination,
    bool? clients,
    bool? services,
    bool? orders,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        'status': ?status,
        if (clients != null) 'clients': clients.toString(),
        if (services != null) 'services': services.toString(),
        if (orders != null) 'orders': orders.toString(),
      };

      const path = 'vouchers/client/me/';
      final response = await get(path, queryParameters: queryParams);
      final paginated = PaginatedList<Voucher>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => Voucher.fromJson(item as Map<String, dynamic>),
      );
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
