import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/orders/order.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';

/// Service for managing client orders.
///
/// This service provides methods for retrieving and listing orders
/// associated with the authenticated client user.
///
/// ## Usage
/// ```dart
/// final ordersService = OrdersService.instance;
/// final result = await ordersService.getAllOrders(
///   pagination: Pagination(page: 1, pageCount: 20),
///   client: true,
/// );
/// ```
///
/// ## Singleton Pattern
/// Access the service via [OrdersService.instance].
class OrdersService extends IntraApi {
  /// Singleton instance of [OrdersService].
  static final OrdersService instance = OrdersService();

  /// Creates an [OrdersService] instance with the base URL from [Constants].
  OrdersService() : super(Constants.getBaseUrl());

  /// Retrieves all orders for the authenticated client with optional filtering.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [client]: Whether to include client details in the response
  /// - [orderPaymentInfo]: Whether to include payment info in the response
  /// - Returns: [ValueResult] containing a [PaginatedList] of [OrderModel] objects
  ///
  /// ## Response Handling
  /// This method handles three different response formats:
  /// - Map with 'items' key (standard paginated response)
  /// - List (direct list of orders)
  /// - Map (single order response)
  ///
  /// ## Error Handling
  /// On failure, [ValueResult.isError] will be true and [ValueResult.error]
  /// contains the error message extracted from the API response.
  Future<ValueResult<PaginatedList<OrderModel>>> getAllOrders({
    Pagination? pagination,
    bool? client,
    bool? orderPaymentInfo,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (client != null) 'client': client.toString(),
        if (orderPaymentInfo != null)
          'orderPaymentInfo': orderPaymentInfo.toString(),
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
        final items = data
            .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
            .toList();
        paginated =
            PaginatedList<OrderModel>(items: items, pageCount: items.length);
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
