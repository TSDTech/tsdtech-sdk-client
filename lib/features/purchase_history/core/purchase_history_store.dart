import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'package:voucherize/core/services/intra-api/md-orders/orders_service.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/orders/order.model.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/value_result.dart';

part 'purchase_history_store.g.dart';

class PurchaseHistoryStore = _PurchaseHistoryStore with _$PurchaseHistoryStore;

abstract class _PurchaseHistoryStore with Store {
  @observable
  ObservableList<Map<String, dynamic>> purchases = ObservableList<Map<String, dynamic>>();

  @observable
  bool isLoading = false;

  @observable
  int currentPage = 0;

  @observable
  int pageSize = 20;

  @observable
  bool hasMore = true;

  @observable
  String? errorMessage;

  @observable
  ValueResult<PaginatedList<OrderModel>>? lastFetchResult;

  @observable
  String paymentFilter = 'Todos';

  @observable
  String statusFilter = 'Todos';

  @observable
  DateTime? startDate;

  @observable
  DateTime? endDate;

  @computed
  List<Map<String, dynamic>> get filteredPurchases {
    return purchases.where((p) {
      // Pagamento
      if (paymentFilter != 'Todos' && p['paymentMethod'] != paymentFilter) return false;
      // Status
      if (statusFilter != 'Todos' && p['status'] != statusFilter) return false;
      // Data
      if (startDate != null || endDate != null) {
        DateTime purchaseDate = DateTime.tryParse(_parseDate(p['date'])) ?? DateTime(2000);
        if (startDate != null && purchaseDate.isBefore(startDate!)) return false;
        if (endDate != null && purchaseDate.isAfter(endDate!)) return false;
      }
      return true;
    }).toList();
  }

  // Função utilitária para converter data dd/MM/yyyy para yyyy-MM-dd
  String _parseDate(String? date) {
    if (date == null) return '';
    final parts = date.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }
    return date;
  }

  @action
  Future<void> loadOrdersFromApi({int page = 1, int pageSize = 20}) async {
    try {
      // Prevent fetching beyond available pages
      if (page > 1 && !hasMore) return;
      isLoading = true;
      errorMessage = null;

  final pagination = Pagination(page: page, pageCount: pageSize);
      final result = await OrdersService.instance.getAllOrders(
        pagination: pagination,
        client: true,
        orderPaymentInfo: true,
      );

      lastFetchResult = result;
      if (result.isError) {
        purchases.clear();
        errorMessage = result.error;
      } else {
        final pageResult = result.value;
        final items = pageResult?.items.cast<OrderModel>() ?? [];
        if (page == 1) {
          purchases.clear();
        }

        for (final o in items) {
          final date = o.updatedAt;
          final formattedDate = date != null
              ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
              : '';

          // map status from backend to UI Portuguese labels
          String statusLabel = (o.status ?? '').toLowerCase();
          if (statusLabel == 'pending' || statusLabel == 'pendente') {
            statusLabel = 'Pendente';
          } else if (statusLabel == 'confirmed' || statusLabel == 'confirmado' || statusLabel == 'paid') {
            statusLabel = 'Confirmado';
          } else if (statusLabel == 'cancelled' || statusLabel == 'cancelado') {
            statusLabel = 'Cancelado';
          } else if (statusLabel == 'failed' || statusLabel == 'falhado') {
            statusLabel = 'Falhado';
          } else {
            statusLabel = (o.status ?? '');
          }

          final payment = o.orderPaymentInfo;
          final paymentMethod = payment?.paymentMethod ?? '';
          final amount = payment?.cartTotalValue != null ? 'R\$ ${payment!.cartTotalValue!.toStringAsFixed(2)}' : '';

          purchases.add({
            'transactionId': o.hash ?? o.id,
            'date': formattedDate,
            'serviceName': '—', // not provided by this endpoint in current model
            'serviceCode': '—',
            'paymentMethod': paymentMethod,
            'amount': amount,
            'status': statusLabel,
            'actionLabel': statusLabel == 'Confirmado' ? 'Baixar comprovante' : 'Ver detalhes',
          });
        }

        // update paging info
        currentPage = page;
        hasMore = items.length >= pageSize;
        this.pageSize = pageSize;
      }
    } catch (e) {
      if (e is DioError) {
        final status = e.response?.statusCode;
        final data = e.response?.data;
        String serverMessage = 'Ocorreu um erro desconhecido.';
        try {
          if (data is Map && data['message'] != null) serverMessage = data['message'].toString();
          else if (data is String) serverMessage = data;
        } catch (_) {}
        lastFetchResult = ValueResult.failure('HTTP ${status ?? '-'} - $serverMessage');
        errorMessage = lastFetchResult?.error;
        // ignore: avoid_print
        print('loadOrdersFromApi DioError: status=$status, data=$data');
      } else {
        lastFetchResult = ValueResult.fromError(e);
        errorMessage = lastFetchResult?.error;
        // ignore: avoid_print
        print('loadOrdersFromApi error: $e');
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  void setPaymentFilter(String filter) {
    paymentFilter = filter;
  }

  @action
  void setStatusFilter(String filter) {
    statusFilter = filter;
  }

  @action
  void setStartDate(DateTime? date) {
    startDate = date;
  }

  @action
  void setEndDate(DateTime? date) {
    endDate = date;
  }

  @action
  void clearFilters() {
    paymentFilter = 'Todos';
    statusFilter = 'Todos';
    startDate = null;
    endDate = null;
  }
}
