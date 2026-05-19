import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/memberships/membership.model.dart';

/// Service for managing client memberships and subscriptions.
///
/// This service provides methods for retrieving memberships associated
/// with the authenticated client user, with support for filtering by
/// user IDs, organization IDs, and roles.
///
/// ## Usage
/// ```dart
/// final client = TsdtechClient();
/// final membershipsService = client.memberships;
/// final result = await membershipsService.getMemberships(
///   pagination: Pagination(page: 1, pageCount: 20),
///   clientUserIds: ['user-id-1', 'user-id-2'],
/// );
/// ```
///
/// Prefer scoped access via `TsdtechClient.memberships`.
/// The legacy [MembershipsService.instance] singleton remains available for
/// backward compatibility during the migration period.
class MembershipsService extends IntraApi {
  /// Singleton instance of [MembershipsService].
  @Deprecated(
    'Use TsdtechClient.memberships to access a scoped service instance. '
    'This legacy singleton will be removed in a future major version.',
  )
  static final MembershipsService instance = MembershipsService();

  /// Creates a [MembershipsService] instance with the base URL from [Constants].
  MembershipsService({BaseApi? baseApi, String? baseUrl})
    : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Retrieves memberships with optional filtering parameters.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [ids]: Filter by membership IDs (optional)
  /// - [clientUserIds]: Filter by client user IDs (optional)
  /// - [organizationIds]: Filter by organization IDs (optional)
  /// - [roles]: Filter by membership roles (optional)
  /// - [clientUser]: Whether to include client user details (optional)
  /// - [organization]: Whether to include organization details (optional)
  /// - Returns: [ValueResult] containing a [PaginatedList] of [Membership] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await membershipsService.getMemberships(
  ///   roles: [1, 2],
  ///   clientUser: true,
  ///   organization: true,
  /// );
  /// ```
  Future<ValueResult<PaginatedList<Membership>>> getMemberships({
    Pagination? pagination,
    List<String>? ids,
    List<String>? clientUserIds,
    List<String>? organizationIds,
    List<int>? roles,
    bool? clientUser,
    bool? organization,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (ids != null && ids.isNotEmpty) 'ids': ids,
        if (clientUserIds != null && clientUserIds.isNotEmpty)
          'clientUserIds': clientUserIds,
        if (organizationIds != null && organizationIds.isNotEmpty)
          'organizationIds': organizationIds,
        if (roles != null && roles.isNotEmpty) 'roles': roles,
        'clientUser': ?clientUser,
        'organization': ?organization,
      };

      final response = await get(
        '/memberships/client',
        queryParameters: queryParams,
      );

      final paginated = PaginatedList<Membership>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => Membership.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
