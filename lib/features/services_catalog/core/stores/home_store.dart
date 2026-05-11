import 'package:mobx/mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-services/services/services_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-services/services/service_types_service.dart';
import 'package:tsdtech_client_sdk/models/services/service_type.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/core/local_storage/administrator/administrator_id.prefs.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  String? searchQuery;

  @observable
  // dropdownQuery removed: Guia de Operações UI was removed

  @observable
  String? selectedCategory;

  @observable
  List<ServiceType> serviceTypes = [];

  @observable
  List<Service> services = [];

  @action
  void setSearchQuery(String q) {
    searchQuery = q;
    loadInitial();
  }

  // setDropdownQuery removed

  // filteredServices now simply returns the services loaded from backend
  List<Service> get filteredServices => services;

  @action
  Future<void> loadInitial() async {
    isLoading = true;
    error = null;
    try {
      // fetch services from backend
      final sl = GetIt.instance;
      final svc = sl<ServicesService>();
      final typesSvc = sl<ServiceTypesService>();
      final adminId = AdministratorIdPrefs.get();
      if (adminId == null || adminId.isEmpty) return;

      // load service types
      final typesRes = await typesSvc.getPublicServiceTypes(
          pagination: Pagination(page: 1, pageCount: 50),
          administratorIds: [adminId]);
      if (typesRes.isSuccess) {
        final pag = typesRes.value;
        if (pag != null) serviceTypes = pag.items;
      }

      // load services (filtered by selectedCategory/serviceType id if set and searchTerm)
      final result = await svc.getPublicServices(
        administratorIds: [adminId],
        serviceTypeIds: selectedCategory != null && selectedCategory!.isNotEmpty
            ? [selectedCategory!]
            : null,
        searchTerm: searchQuery,
      );

      if (result.isSuccess) {
        final pag = result.value;
        if (pag != null) {
          services = pag.items;
        }
      } else {
        error = result.error;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void selectCategory(String? id) {
    selectedCategory = id;
    // refresh services when category changes
    loadInitial();
  }
}
