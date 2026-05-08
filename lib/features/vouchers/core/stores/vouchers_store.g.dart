// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vouchers_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VouchersStore on _VouchersStore, Store {
  Computed<List<Voucher>>? _$availableVouchersComputed;

  @override
  List<Voucher> get availableVouchers => (_$availableVouchersComputed ??=
          Computed<List<Voucher>>(() => super.availableVouchers,
              name: '_VouchersStore.availableVouchers'))
      .value;
  Computed<List<Voucher>>? _$inProgressVouchersComputed;

  @override
  List<Voucher> get inProgressVouchers => (_$inProgressVouchersComputed ??=
          Computed<List<Voucher>>(() => super.inProgressVouchers,
              name: '_VouchersStore.inProgressVouchers'))
      .value;
  Computed<List<Voucher>>? _$filteredVouchersComputed;

  @override
  List<Voucher> get filteredVouchers => (_$filteredVouchersComputed ??=
          Computed<List<Voucher>>(() => super.filteredVouchers,
              name: '_VouchersStore.filteredVouchers'))
      .value;
  Computed<int>? _$availableCountComputed;

  @override
  int get availableCount =>
      (_$availableCountComputed ??= Computed<int>(() => super.availableCount,
              name: '_VouchersStore.availableCount'))
          .value;

  late final _$selectedTabAtom =
      Atom(name: '_VouchersStore.selectedTab', context: context);

  @override
  int get selectedTab {
    _$selectedTabAtom.reportRead();
    return super.selectedTab;
  }

  @override
  set selectedTab(int value) {
    _$selectedTabAtom.reportWrite(value, super.selectedTab, () {
      super.selectedTab = value;
    });
  }

  late final _$vouchersAtom =
      Atom(name: '_VouchersStore.vouchers', context: context);

  @override
  ObservableList<Voucher> get vouchers {
    _$vouchersAtom.reportRead();
    return super.vouchers;
  }

  @override
  set vouchers(ObservableList<Voucher> value) {
    _$vouchersAtom.reportWrite(value, super.vouchers, () {
      super.vouchers = value;
    });
  }

  late final _$formDataAtom =
      Atom(name: '_VouchersStore.formData', context: context);

  @override
  Map<String, dynamic> get formData {
    _$formDataAtom.reportRead();
    return super.formData;
  }

  @override
  set formData(Map<String, dynamic> value) {
    _$formDataAtom.reportWrite(value, super.formData, () {
      super.formData = value;
    });
  }

  late final _$formValuesAtom =
      Atom(name: '_VouchersStore.formValues', context: context);

  @override
  Map<String, String> get formValues {
    _$formValuesAtom.reportRead();
    return super.formValues;
  }

  @override
  set formValues(Map<String, String> value) {
    _$formValuesAtom.reportWrite(value, super.formValues, () {
      super.formValues = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_VouchersStore.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$startDateFilterAtom =
      Atom(name: '_VouchersStore.startDateFilter', context: context);

  @override
  String get startDateFilter {
    _$startDateFilterAtom.reportRead();
    return super.startDateFilter;
  }

  @override
  set startDateFilter(String value) {
    _$startDateFilterAtom.reportWrite(value, super.startDateFilter, () {
      super.startDateFilter = value;
    });
  }

  late final _$endDateFilterAtom =
      Atom(name: '_VouchersStore.endDateFilter', context: context);

  @override
  String get endDateFilter {
    _$endDateFilterAtom.reportRead();
    return super.endDateFilter;
  }

  @override
  set endDateFilter(String value) {
    _$endDateFilterAtom.reportWrite(value, super.endDateFilter, () {
      super.endDateFilter = value;
    });
  }

  late final _$tagFilterAtom =
      Atom(name: '_VouchersStore.tagFilter', context: context);

  @override
  String? get tagFilter {
    _$tagFilterAtom.reportRead();
    return super.tagFilter;
  }

  @override
  set tagFilter(String? value) {
    _$tagFilterAtom.reportWrite(value, super.tagFilter, () {
      super.tagFilter = value;
    });
  }

  late final _$populateClientsAtom =
      Atom(name: '_VouchersStore.populateClients', context: context);

  @override
  bool get populateClients {
    _$populateClientsAtom.reportRead();
    return super.populateClients;
  }

  @override
  set populateClients(bool value) {
    _$populateClientsAtom.reportWrite(value, super.populateClients, () {
      super.populateClients = value;
    });
  }

  late final _$populateServiceIdsAtom =
      Atom(name: '_VouchersStore.populateServiceIds', context: context);

  @override
  bool get populateServiceIds {
    _$populateServiceIdsAtom.reportRead();
    return super.populateServiceIds;
  }

  @override
  set populateServiceIds(bool value) {
    _$populateServiceIdsAtom.reportWrite(value, super.populateServiceIds, () {
      super.populateServiceIds = value;
    });
  }

  late final _$populateOrderIdsAtom =
      Atom(name: '_VouchersStore.populateOrderIds', context: context);

  @override
  bool get populateOrderIds {
    _$populateOrderIdsAtom.reportRead();
    return super.populateOrderIds;
  }

  @override
  set populateOrderIds(bool value) {
    _$populateOrderIdsAtom.reportWrite(value, super.populateOrderIds, () {
      super.populateOrderIds = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_VouchersStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_VouchersStore.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$pageSizeAtom =
      Atom(name: '_VouchersStore.pageSize', context: context);

  @override
  int get pageSize {
    _$pageSizeAtom.reportRead();
    return super.pageSize;
  }

  @override
  set pageSize(int value) {
    _$pageSizeAtom.reportWrite(value, super.pageSize, () {
      super.pageSize = value;
    });
  }

  late final _$hasMoreAtom =
      Atom(name: '_VouchersStore.hasMore', context: context);

  @override
  bool get hasMore {
    _$hasMoreAtom.reportRead();
    return super.hasMore;
  }

  @override
  set hasMore(bool value) {
    _$hasMoreAtom.reportWrite(value, super.hasMore, () {
      super.hasMore = value;
    });
  }

  late final _$isLoadingProvidersAtom =
      Atom(name: '_VouchersStore.isLoadingProviders', context: context);

  @override
  bool get isLoadingProviders {
    _$isLoadingProvidersAtom.reportRead();
    return super.isLoadingProviders;
  }

  @override
  set isLoadingProviders(bool value) {
    _$isLoadingProvidersAtom.reportWrite(value, super.isLoadingProviders, () {
      super.isLoadingProviders = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_VouchersStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchMyVouchersAsyncAction =
      AsyncAction('_VouchersStore.fetchMyVouchers', context: context);

  @override
  Future<void> fetchMyVouchers({int page = 1, int pageSizeParam = 10}) {
    return _$fetchMyVouchersAsyncAction.run(
        () => super.fetchMyVouchers(page: page, pageSizeParam: pageSizeParam));
  }

  late final _$fetchProvidersForServiceAsyncAction =
      AsyncAction('_VouchersStore.fetchProvidersForService', context: context);

  @override
  Future<ValueResult<PaginatedList<ProviderModel>>> fetchProvidersForService(
      String serviceId,
      {int page = 1,
      int pageSize = 10}) {
    return _$fetchProvidersForServiceAsyncAction.run(() => super
        .fetchProvidersForService(serviceId, page: page, pageSize: pageSize));
  }

  late final _$_VouchersStoreActionController =
      ActionController(name: '_VouchersStore', context: context);

  @override
  void setSelectedTab(int index) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.setSelectedTab');
    try {
      return super.setSelectedTab(index);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveFormData(Map<String, dynamic> data) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.saveFormData');
    try {
      return super.saveFormData(data);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFormValue(String key, String value) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.setFormValue');
    try {
      return super.setFormValue(key, value);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDateFilter(String date) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.setStartDateFilter');
    try {
      return super.setStartDateFilter(date);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDateFilter(String date) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.setEndDateFilter');
    try {
      return super.setEndDateFilter(date);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTagFilter(String? tag) {
    final _$actionInfo = _$_VouchersStoreActionController.startAction(
        name: '_VouchersStore.setTagFilter');
    try {
      return super.setTagFilter(tag);
    } finally {
      _$_VouchersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTab: ${selectedTab},
vouchers: ${vouchers},
formData: ${formData},
formValues: ${formValues},
searchQuery: ${searchQuery},
startDateFilter: ${startDateFilter},
endDateFilter: ${endDateFilter},
tagFilter: ${tagFilter},
populateClients: ${populateClients},
populateServiceIds: ${populateServiceIds},
populateOrderIds: ${populateOrderIds},
isLoading: ${isLoading},
currentPage: ${currentPage},
pageSize: ${pageSize},
hasMore: ${hasMore},
isLoadingProviders: ${isLoadingProviders},
errorMessage: ${errorMessage},
availableVouchers: ${availableVouchers},
inProgressVouchers: ${inProgressVouchers},
filteredVouchers: ${filteredVouchers},
availableCount: ${availableCount}
    ''';
  }
}
