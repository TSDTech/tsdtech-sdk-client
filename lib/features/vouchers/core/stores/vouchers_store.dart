import 'package:mobx/mobx.dart';
import 'package:tsdtech_client_sdk/models/vouchers/voucher.model.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-vouchers/vouchers_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-providers/provider_requests_service.dart';
import 'package:tsdtech_client_sdk/models/providers/provider.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';

part 'vouchers_store.g.dart';

class VouchersStore = _VouchersStore with _$VouchersStore;

abstract class _VouchersStore with Store {
  @observable
  int selectedTab = 0;

  @observable
  ObservableList<Voucher> vouchers = ObservableList<Voucher>();

  @observable
  Map<String, dynamic> formData = {};

  @observable
  Map<String, String> formValues = {};

  @observable
  String searchQuery = '';

  @observable
  String startDateFilter = '';

  @observable
  String endDateFilter = '';

  @observable
  String? tagFilter;

  @observable
  bool populateClients = true;

  @observable
  bool populateServiceIds = true;

  @observable
  bool populateOrderIds = true;

  @observable
  bool isLoading = false;

  @observable
  int currentPage = 0;

  @observable
  int pageSize = 10;

  @observable
  bool hasMore = true;

  @observable
  bool isLoadingProviders = false;

  @observable
  String? errorMessage;

  @computed
  List<Voucher> get availableVouchers => vouchers.where((v) {
        final s = v.status.toLowerCase();
        return s == 'available' || s == 'valid';
      }).toList();

  @computed
  List<Voucher> get inProgressVouchers => vouchers.where((v) => v.status == 'scheduled').toList();

  @computed
  List<Voucher> get filteredVouchers {
    List<Voucher> baseList;
    switch (selectedTab) {
      case 0:
        baseList = availableVouchers;
        break;
      case 1:
        return <Voucher>[]; // Scheduled uses provider requests
      case 2:
        return <Voucher>[]; // Completed uses provider requests
      default:
        baseList = vouchers;
    }

    // Apply filters
    List<Voucher> filtered = baseList;

    // Search filter: by service name
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((v) =>
        (v.service?.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        v.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
        v.serviceId.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (formValues['plate'] ?? '').toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Date range filter: by createdAt or order.createdAt
    if (startDateFilter.isNotEmpty || endDateFilter.isNotEmpty) {
      DateTime? start;
      DateTime? end;
      try {
        if (startDateFilter.isNotEmpty) {
          final s = DateTime.parse(startDateFilter).toLocal();
          start = DateTime(s.year, s.month, s.day); // start of day
        }
        if (endDateFilter.isNotEmpty) {
          final e = DateTime.parse(endDateFilter).toLocal();
          end = DateTime(e.year, e.month, e.day, 23, 59, 59, 999); // end of day
        }
      } catch (_) {
        // If parsing fails, ignore date filter
        start = null;
        end = null;
      }

      filtered = filtered.where((v) {
        DateTime? voucherDate;
        try {
          // First, try service.validTimestamp (matches VoucherCard._formatValidity)
          final ts = v.service?.validTimestamp;
          if (ts != null) {
            DateTime? expiry;
            String? baseDateStr;
            try {
              baseDateStr = v.order != null && v.order!['createdAt'] != null
                  ? v.order!['createdAt'] as String
                  : v.createdAt ?? v.service?.createdAt?.toIso8601String();
            } catch (_) {
              baseDateStr = null;
            }

            if (baseDateStr != null) {
              try {
                final base = DateTime.parse(baseDateStr);
                expiry = base.add(Duration(seconds: ts));
              } catch (_) {
                expiry = null;
              }
            }

            if (expiry == null) {
              if (ts > 1000000000000) {
                // milliseconds epoch
                expiry = DateTime.fromMillisecondsSinceEpoch(ts);
              } else if (ts > 1000000000) {
                // seconds epoch
                expiry = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
              } else {
                expiry = null;
              }
            }

            if (expiry != null) {
              voucherDate = expiry.toLocal();
            }
          }

          // If no voucherDate from validTimestamp, try voucher.validity string
          if (voucherDate == null) {
            if (v.validity != null && v.validity!.isNotEmpty) {
              voucherDate = DateTime.parse(v.validity!).toLocal();
            } else if (v.createdAt != null) {
              voucherDate = DateTime.parse(v.createdAt!).toLocal();
            } else if (v.order != null && v.order!['createdAt'] != null) {
              voucherDate = DateTime.parse(v.order!['createdAt']).toLocal();
            }
          }
        } catch (_) {}
        if (voucherDate == null) return false;

        final matchesStart = start == null || !voucherDate.isBefore(start);
        final matchesEnd = end == null || !voucherDate.isAfter(end);
        return matchesStart && matchesEnd;
      }).toList();
    }

    // Tag filter: by service.tags
    if (tagFilter != null && tagFilter!.isNotEmpty) {
      filtered = filtered.where((v) =>
        (v.service?.tags ?? []).contains(tagFilter)
      ).toList();
    }

    return filtered;
  }

  @computed
  int get availableCount => availableVouchers.length;

  @action
  void setSelectedTab(int index) {
    selectedTab = index;
  }



  @action
  void saveFormData(Map<String, dynamic> data) {
    formData = Map.from(data);
  }

  @action
  void setFormValue(String key, String value) {
    formValues[key] = value;
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

  @action
  Future<void> fetchMyVouchers({int page = 1, int pageSizeParam = 10}) async {
    try {
      // Debug log to confirm fetch invocation
      // ignore: avoid_print
  final pageSize = pageSizeParam;
  print('[VouchersStore] fetchMyVouchers called page=$page pageSize=$pageSize populateClients=$populateClients populateServiceIds=$populateServiceIds populateOrderIds=$populateOrderIds');
  // Prevent fetching beyond available pages
  if (page > 1 && !hasMore) return;
  isLoading = true;
  errorMessage = null;
  final pagination = Pagination(page: page, pageCount: pageSize);
      final result = await VouchersService.instance.getVouchersClient(
        pagination: pagination,
        clients: populateClients,
        services: populateServiceIds,
        orders: populateOrderIds,
        status: 'VALID',
      );
      if (result.isError) {
        print('[VouchersStore] fetch error: ${result.error}');
        errorMessage = result.error;
      } else {
        final pageResult = result.value;
        if (page == 1) {
          vouchers.clear();
        }
        if (pageResult != null) {
          for (final item in pageResult.items) {
            vouchers.add(item);
          }
          // update paging info
          currentPage = page;
          hasMore = pageResult.items.length >= pageSize;
          this.pageSize = pageSize;
        } else {
          // no results
          hasMore = false;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  /// Fetch providers that match a service id. Returns the raw ValueResult so callers
  /// can inspect pagination/items. Keeps network logic inside the store.
  @action
  Future<ValueResult<PaginatedList<ProviderModel>>> fetchProvidersForService(String serviceId, {int page = 1, int pageSize = 10}) async {
    try {
      isLoadingProviders = true;
      final pagination = Pagination(page: page, pageCount: pageSize);
      final result = await ProviderRequestsService.instance.getAllProvider(
        pagination: pagination,
        serviceType: true,
        providerBool: true,
        serviceId: serviceId,
      );
      return result;
    } catch (e) {
      return ValueResult.fromError(e);
    } finally {
      isLoadingProviders = false;
    }
  }

  void resetFormValues() {
    formValues.clear();
  }
}
