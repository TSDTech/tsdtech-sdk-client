import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/api_keys/api_key.model.dart';

class ApiKeysService extends IntraApi {
  static final ApiKeysService instance = ApiKeysService();

  ApiKeysService() : super(Constants.getBaseUrl());

  Future<ValueResult<PaginatedList<ApiKey>>> getApiKeys({
    Pagination? pagination,
    List<String>? ids,
    required organizationId,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (ids != null && ids.isNotEmpty) 'ids': ids,
      };

      // If a single organizationId is provided in query params, forward as header 'org-id'
      Map<String, dynamic>? headers = {'org-id': organizationId};

      final response = await get('/api-keys/client',
          queryParameters: queryParams, headers: headers);

      final paginated = PaginatedList<ApiKey>.fromJson(
        response.data,
        (item) => ApiKey.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<List<ApiKey>>> createApiKeys({
    required String organizationId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      Map<String, dynamic>? headers = {'org-id': organizationId};
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

  Future<ValueResult<List<String>>> deleteApiKeys({
    required String organizationId,
    required List<String> ids,
  }) async {
    try {
      Map<String, dynamic>? headers = {'org-id': organizationId};
      final response =
          await delete('/api-keys/client', data: {
            "ids": ids
          }, headers: headers);
      final data = (response.data as List).map((e) => e as String).toList();
      return ValueResult.success(data);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
