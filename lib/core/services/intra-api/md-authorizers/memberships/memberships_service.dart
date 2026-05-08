import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/memberships/membership.model.dart';

class MembershipsService extends IntraApi {
  static final MembershipsService instance = MembershipsService();

  MembershipsService() : super(Constants.getBaseUrl());

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
        if (clientUserIds != null && clientUserIds.isNotEmpty) 'clientUserIds': clientUserIds,
        if (organizationIds != null && organizationIds.isNotEmpty) 'organizationIds': organizationIds,
        if (roles != null && roles.isNotEmpty) 'roles': roles,
        if (clientUser != null) 'clientUser': clientUser,
        if (organization != null) 'organization': organization,
      };

      final response = await get('/memberships/client', queryParameters: queryParams);

      final paginated = PaginatedList<Membership>.fromJson(
        response.data,
        (item) => Membership.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
