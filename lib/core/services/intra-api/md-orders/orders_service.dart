import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/orders/order.model.dart';
import 'package:voucherize/models/value_result.dart';

class OrdersService extends IntraApi {
  static final OrdersService instance = OrdersService();

  OrdersService() : super(Constants.getBaseUrl());

  Future<ValueResult<PaginatedList<OrderModel>>> getAllOrders (
    {
      Pagination? pagination,
      bool? client,
      bool? orderPaymentInfo,
    }
  ) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (client != null) 'client': client.toString(),
        if (orderPaymentInfo != null) 'orderPaymentInfo': orderPaymentInfo.toString(),
      };
      const path = 'orders/client/me';
      final response = await get(path, queryParameters: queryParams);
      final data = response.data;
      PaginatedList<OrderModel> paginated;

      if (data is Map && data.containsKey('items')) {
        paginated = PaginatedList<OrderModel>.fromJson(
          data as Map<String, dynamic>,
          (item) => OrderModel.fromJson(item as Map<String, dynamic>),
        );
      } else if (data is List) {
        final items = data.map((item) => OrderModel.fromJson(item as Map<String, dynamic>)).toList();
        paginated = PaginatedList<OrderModel>(items: items, pageCount: items.length);
      } else if (data is Map) {
        final item = OrderModel.fromJson(data as Map<String, dynamic>);
        paginated = PaginatedList<OrderModel>(items: [item], pageCount: 1);
      } else {
        throw Exception('Unexpected response format from orders endpoint');
      }
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
