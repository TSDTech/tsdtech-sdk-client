import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/api_keys/api_key.model.dart';

/// Service for managing API keys for organizations.
///
/// This service provides methods for listing, creating, and deleting
/// API keys associated with a specific organization.
///
/// ## Usage
/// ```dart
/// final apiKeysService = ApiKeysService.instance;
///
/// // List API keys
/// final keys = await apiKeysService.getApiKeys(
///   organizationId: 'org-123',
///   pagination: Pagination(page: 1, pageCount: 20),
/// );
///
/// // Create new API key
/// final created = await apiKeysService.createApiKeys(
///   organizationId: 'org-123',
///   items: [{'name': 'My Key', 'permissions': ['read']}],
/// );
///
/// // Delete API keys
/// await apiKeysService.deleteApiKeys(
///   organizationId: 'org-123',
///   ids: ['key-id-1', 'key-id-2'],
/// );
/// ```
///
/// ## Singleton Pattern
/// Access the service via [ApiKeysService.instance].
class ApiKeysService extends IntraApi {
  /// Singleton instance of [ApiKeysService].
  static final ApiKeysService instance = ApiKeysService();

  /// Creates an [ApiKeysService] instance with the base URL from [Constants].
  ApiKeysService({BaseApi? baseApi, String? baseUrl})
      : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Retrieves a list of API keys for the specified organization.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [ids]: Optional filter by specific API key IDs
  /// - [organizationId]: The organization ID (required, used as header 'org-id')
  /// - Returns: [ValueResult] containing a [PaginatedList] of [ApiKey] objects
  ///
  /// ## Error Handling
  /// On failure, [ValueResult.isError] will be true and [ValueResult.error]
  /// contains the error message.
  Future<ValueResult<PaginatedList<ApiKey>>> getApiKeys({
    Pagination? pagination,
    List<String>? ids,
    required String organizationId,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (ids != null && ids.isNotEmpty) 'ids': ids,
      };

      final Map<String, dynamic> headers = {'org-id': organizationId};

      final response = await get(
        '/api-keys/client',
        queryParameters: queryParams,
        headers: headers,
      );

      final paginated = PaginatedList<ApiKey>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => ApiKey.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Creates new API keys for the specified organization.
  ///
  /// - [organizationId]: The organization ID (required, used as header 'org-id')
  /// - [items]: List of key creation items containing name and permissions
  /// - Returns: [ValueResult] containing a list of created [ApiKey] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await apiKeysService.createApiKeys(
  ///   organizationId: 'org-123',
  ///   items: [
  ///     {'name': 'Production Key', 'permissions': ['read', 'write']},
  ///     {'name': 'Read Only Key', 'permissions': ['read']},
  ///   ],
  /// );
  /// ```
  Future<ValueResult<List<ApiKey>>> createApiKeys({
    required String organizationId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final Map<String, dynamic> headers = {'org-id': organizationId};
      final response = await post(
        '/api-keys/client',
        data: {'items': items},
        headers: headers,
      );
      final data = (response.data as List)
          .map((e) => ApiKey.fromJson(e as Map<String, dynamic>))
          .toList();
      return ValueResult.success(data);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Deletes API keys for the specified organization.
  ///
  /// - [organizationId]: The organization ID (required, used as header 'org-id')
  /// - [ids]: List of API key IDs to delete (required)
  /// - Returns: [ValueResult] containing a list of deleted key IDs
  ///
  /// ## Example
  /// ```dart
  /// final result = await apiKeysService.deleteApiKeys(
  ///   organizationId: 'org-123',
  ///   ids: ['key-id-1', 'key-id-2'],
  /// );
  /// if (result.isSuccess) {
  ///   print('Deleted: ${result.value}');
  /// }
  /// ```
  Future<ValueResult<List<String>>> deleteApiKeys({
    required String organizationId,
    required List<String> ids,
  }) async {
    try {
      final Map<String, dynamic> headers = {'org-id': organizationId};
      final response = await delete(
        '/api-keys/client',
        data: {'ids': ids},
        headers: headers,
      );
      final data = (response.data as List).map((e) => e as String).toList();
      return ValueResult.success(data);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
