import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/services/service_type.model.dart';

class ServiceTypesService extends IntraApi {
  static final ServiceTypesService instance = ServiceTypesService();

  ServiceTypesService() : super(Constants.getBaseUrl());

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
        if (administratorIds != null && administratorIds.isNotEmpty) 'administratorIds': administratorIds,
        if (searchTerm != null) 'searchTerm': searchTerm,
        if (administrator != null) 'administrator': administrator,
        if (providers != null) 'providers': providers,
      };

      const path = '/service-types/public';
      final response = await get(path, queryParameters: queryParams);

      final paginated = PaginatedList<ServiceType>.fromJson(
        response.data,
        (item) => ServiceType.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
