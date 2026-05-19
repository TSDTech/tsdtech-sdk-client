import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/services/service_type.model.dart';

/// Service for managing service types.
///
/// This service provides methods for retrieving service type definitions
/// that categorize services in the TsdTech platform.
///
/// ## Usage
/// ```dart
/// final serviceTypesService = ServiceTypesService.instance;
///
/// // List public service types
/// final types = await serviceTypesService.getPublicServiceTypes(
///   pagination: Pagination(page: 1, pageCount: 20),
///   names: ['consultation', 'installation'],
/// );
///
/// // Search service types
/// final search = await serviceTypesService.getPublicServiceTypes(
///   searchTerm: 'plumbing',
///   administrator: true,
/// );
/// ```
///
/// ## Singleton Pattern
/// Access the service via [ServiceTypesService.instance].
class ServiceTypesService extends IntraApi {
  /// Singleton instance of [ServiceTypesService].
  static final ServiceTypesService instance = ServiceTypesService();

  /// Creates a [ServiceTypesService] instance with the base URL from [Constants].
  ServiceTypesService({BaseApi? baseApi, String? baseUrl})
    : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Retrieves a list of public service types with optional filtering.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [ids]: Filter by service type IDs (optional)
  /// - [names]: Filter by service type names (optional)
  /// - [administratorIds]: Filter by administrator IDs (optional)
  /// - [searchTerm]: Search by name (optional)
  /// - [administrator]: Include administrator details (optional)
  /// - [providers]: Include provider details (optional)
  /// - Returns: [ValueResult] containing a [PaginatedList] of [ServiceType] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await serviceTypesService.getPublicServiceTypes(
  ///   searchTerm: 'maintenance',
  ///   administrator: true,
  ///   providers: true,
  /// );
  /// ```
  Future<ValueResult<PaginatedList<ServiceType>>> getPublicServiceTypes({
    Pagination? pagination,
    List<String>? ids,
    List<String>? names,
    List<String>? administratorIds,
    String? searchTerm,
    bool? administrator,
    bool? providers,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (ids != null && ids.isNotEmpty) 'ids': ids,
        if (names != null && names.isNotEmpty) 'names': names,
        if (administratorIds != null && administratorIds.isNotEmpty)
          'administratorIds': administratorIds,
        'searchTerm': ?searchTerm,
        'administrator': ?administrator,
        'providers': ?providers,
      };

      const path = '/service-types/public';
      final response = await get(path, queryParameters: queryParams);

      final paginated = PaginatedList<ServiceType>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => ServiceType.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
