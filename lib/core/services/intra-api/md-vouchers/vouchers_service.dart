import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/vouchers/voucher.model.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/value_result.dart';

class VouchersService extends IntraApi {
  static final VouchersService instance = VouchersService();

  VouchersService() : super(Constants.getBaseUrl());

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
        if (status != null) 'status': status,
        if (clients != null) 'clients': clients.toString(),
        if (services != null) 'services': services.toString(),
        if (orders != null) 'orders': orders.toString(),
      };

      const path = 'vouchers/client/me/';
      final response = await get(path, queryParameters: queryParams);
      final paginated = PaginatedList<Voucher>.fromJson(
        response.data,
        (item) => Voucher.fromJson(item as Map<String, dynamic>),
      );
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
