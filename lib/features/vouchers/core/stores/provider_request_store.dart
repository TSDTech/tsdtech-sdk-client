import 'package:mobx/mobx.dart';
import 'package:voucherize/models/vouchers/provider_request.model.dart';
import 'package:voucherize/core/services/intra-api/md-providers/provider_requests_service.dart';
import 'package:voucherize/models/common/pagination.model.dart';

part 'provider_request_store.g.dart';

class ProviderRequestStore = _ProviderRequestStore with _$ProviderRequestStore;

abstract class _ProviderRequestStore with Store {
  @observable
  ObservableList<ProviderRequest> providerRequests = ObservableList<ProviderRequest>();

  // populate flags controlled by the store
  @observable
  bool populateClients = true;

  @observable
  bool populateServiceIds = true;

  @observable
  bool populateVoucherIds = true;

  @observable
  bool populateProviderIds = true;

  @observable
  bool populateAdministratorIds = true;

  @observable
  bool isLoading = false;

  @observable
  int currentPage = 0;

  @observable
  int pageSize = 10;

  @observable
  bool hasMore = true;

  @observable
  String? errorMessage;

  // Filters
  @observable
  String searchQuery = '';

  @observable
  String startDateFilter = '';

  @observable
  String endDateFilter = '';

  @observable
  String? tagFilter;

  // currently selected provider request / service for QR flow
  @observable
  String? selectedProviderRequestId;

  @observable
  String? selectedServiceId;

  @action
  void setSelected({required String providerRequestId, required String serviceId}) {
    selectedProviderRequestId = providerRequestId;
    selectedServiceId = serviceId;
  }

  @action
  void clearSelected() {
    selectedProviderRequestId = null;
    selectedServiceId = null;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void setStartDateFilter(String date) {
    startDateFilter = date;
  }

  @action
  void setEndDateFilter(String date) {
    endDateFilter = date;
  }

  @action
  void setTagFilter(String? tag) {
    tagFilter = tag;
  }

  @computed
  List<ProviderRequest> get completedRequests => providerRequests.where((r) {
        final st = r.status.toUpperCase();
        return st == 'FINISHED' || st == 'REJECTED' || st == 'COMPLETED';
      }).toList();

  @computed
  List<ProviderRequest> get scheduledRequests => providerRequests.where((r) => r.status.toUpperCase() == 'PENDING').toList();

  @computed
  List<ProviderRequest> get filteredScheduledRequests {
    List<ProviderRequest> filtered = scheduledRequests;

    // Search filter: by service name, provider request id, voucher id
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((pr) =>
        (pr.service?.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        pr.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (pr.voucherId ?? '').toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Date range filter: by createdAt (validity date for provider requests)
    if (startDateFilter.isNotEmpty || endDateFilter.isNotEmpty) {
      filtered = filtered.where((pr) {
        DateTime? prDate;
        try {
          if (pr.createdAt != null) {
            prDate = DateTime.parse(pr.createdAt!);
          }
        } catch (_) {}
        if (prDate == null) return false;

        bool matchesStart = startDateFilter.isEmpty || prDate.isAfter(DateTime.parse(startDateFilter).subtract(const Duration(days: 1)));
        bool matchesEnd = endDateFilter.isEmpty || prDate.isBefore(DateTime.parse(endDateFilter).add(const Duration(days: 1)));
        return matchesStart && matchesEnd;
      }).toList();
    }

    // Tag filter: by service.tags
    if (tagFilter != null && tagFilter!.isNotEmpty) {
      filtered = filtered.where((pr) =>
        (pr.service?.tags ?? []).contains(tagFilter)
      ).toList();
    }

    return filtered;
  }

  @computed
  List<ProviderRequest> get filteredCompletedRequests {
    List<ProviderRequest> filtered = completedRequests;

    // Search filter: by service name, provider request id, voucher id
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((pr) =>
        (pr.service?.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        pr.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (pr.voucherId ?? '').toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Date range filter: by createdAt (validity date for provider requests)
    if (startDateFilter.isNotEmpty || endDateFilter.isNotEmpty) {
      filtered = filtered.where((pr) {
        DateTime? prDate;
        try {
          if (pr.createdAt != null) {
            prDate = DateTime.parse(pr.createdAt!);
          }
        } catch (_) {}
        if (prDate == null) return false;

        bool matchesStart = startDateFilter.isEmpty || prDate.isAfter(DateTime.parse(startDateFilter).subtract(const Duration(days: 1)));
        bool matchesEnd = endDateFilter.isEmpty || prDate.isBefore(DateTime.parse(endDateFilter).add(const Duration(days: 1)));
        return matchesStart && matchesEnd;
      }).toList();
    }

    // Tag filter: by service.tags
    if (tagFilter != null && tagFilter!.isNotEmpty) {
      filtered = filtered.where((pr) =>
        (pr.service?.tags ?? []).contains(tagFilter)
      ).toList();
    }

    return filtered;
  }

  @computed
  int get scheduledCount => scheduledRequests.length;

  @computed
  int get completedCount => completedRequests.length;



  @action
  Future<void> fetchProviderRequests({int page = 1, int pageSizeParam = 10}) async {
    try {
      // Debug log to confirm fetch invocation
      // ignore: avoid_print
      final pageSize = pageSizeParam;
      print('[ProviderRequestStore] fetchProviderRequests called page=$page pageSize=$pageSize populateClients=$populateClients populateServiceIds=$populateServiceIds populateVoucherIds=$populateVoucherIds populateProviderIds=$populateProviderIds populateAdministratorIds=$populateAdministratorIds');
      if (page > 1 && !hasMore) return;
      isLoading = true;
      errorMessage = null;
      final pagination = Pagination(page: page, pageCount: pageSize);
      final result = await ProviderRequestsService.instance.getProviderRequestsClient(
        pagination: pagination,
        clients: populateClients,
        service: populateServiceIds,
        voucher: populateVoucherIds,
        provider: populateProviderIds,
        administrator: populateAdministratorIds,
      );
      if (result.isError) {
        print('[ProviderRequestStore] fetch error: ${result.error}');
        errorMessage = result.error;
      } else {
        final pageResult = result.value;
        if (page == 1) {
          providerRequests.clear();
        }
        if (pageResult != null) {
          for (final item in pageResult.items) {
            providerRequests.add(item);
          }
          currentPage = page;
          hasMore = pageResult.items.length >= pageSize;
          this.pageSize = pageSize;
        } else {
          hasMore = false;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
