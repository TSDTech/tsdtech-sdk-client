// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_request_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProviderRequestStore on _ProviderRequestStore, Store {
  Computed<List<ProviderRequest>>? _$completedRequestsComputed;

  @override
  List<ProviderRequest> get completedRequests =>
      (_$completedRequestsComputed ??= Computed<List<ProviderRequest>>(
              () => super.completedRequests,
              name: '_ProviderRequestStore.completedRequests'))
          .value;
  Computed<List<ProviderRequest>>? _$scheduledRequestsComputed;

  @override
  List<ProviderRequest> get scheduledRequests =>
      (_$scheduledRequestsComputed ??= Computed<List<ProviderRequest>>(
              () => super.scheduledRequests,
              name: '_ProviderRequestStore.scheduledRequests'))
          .value;
  Computed<List<ProviderRequest>>? _$filteredScheduledRequestsComputed;

  @override
  List<ProviderRequest> get filteredScheduledRequests =>
      (_$filteredScheduledRequestsComputed ??= Computed<List<ProviderRequest>>(
              () => super.filteredScheduledRequests,
              name: '_ProviderRequestStore.filteredScheduledRequests'))
          .value;
  Computed<List<ProviderRequest>>? _$filteredCompletedRequestsComputed;

  @override
  List<ProviderRequest> get filteredCompletedRequests =>
      (_$filteredCompletedRequestsComputed ??= Computed<List<ProviderRequest>>(
              () => super.filteredCompletedRequests,
              name: '_ProviderRequestStore.filteredCompletedRequests'))
          .value;
  Computed<int>? _$scheduledCountComputed;

  @override
  int get scheduledCount =>
      (_$scheduledCountComputed ??= Computed<int>(() => super.scheduledCount,
              name: '_ProviderRequestStore.scheduledCount'))
          .value;
  Computed<int>? _$completedCountComputed;

  @override
  int get completedCount =>
      (_$completedCountComputed ??= Computed<int>(() => super.completedCount,
              name: '_ProviderRequestStore.completedCount'))
          .value;

  late final _$providerRequestsAtom =
      Atom(name: '_ProviderRequestStore.providerRequests', context: context);

  @override
  ObservableList<ProviderRequest> get providerRequests {
    _$providerRequestsAtom.reportRead();
    return super.providerRequests;
  }

  @override
  set providerRequests(ObservableList<ProviderRequest> value) {
    _$providerRequestsAtom.reportWrite(value, super.providerRequests, () {
      super.providerRequests = value;
    });
  }

  late final _$populateClientsAtom =
      Atom(name: '_ProviderRequestStore.populateClients', context: context);

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
      Atom(name: '_ProviderRequestStore.populateServiceIds', context: context);

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

  late final _$populateVoucherIdsAtom =
      Atom(name: '_ProviderRequestStore.populateVoucherIds', context: context);

  @override
  bool get populateVoucherIds {
    _$populateVoucherIdsAtom.reportRead();
    return super.populateVoucherIds;
  }

  @override
  set populateVoucherIds(bool value) {
    _$populateVoucherIdsAtom.reportWrite(value, super.populateVoucherIds, () {
      super.populateVoucherIds = value;
    });
  }

  late final _$populateProviderIdsAtom =
      Atom(name: '_ProviderRequestStore.populateProviderIds', context: context);

  @override
  bool get populateProviderIds {
    _$populateProviderIdsAtom.reportRead();
    return super.populateProviderIds;
  }

  @override
  set populateProviderIds(bool value) {
    _$populateProviderIdsAtom.reportWrite(value, super.populateProviderIds, () {
      super.populateProviderIds = value;
    });
  }

  late final _$populateAdministratorIdsAtom = Atom(
      name: '_ProviderRequestStore.populateAdministratorIds', context: context);

  @override
  bool get populateAdministratorIds {
    _$populateAdministratorIdsAtom.reportRead();
    return super.populateAdministratorIds;
  }

  @override
  set populateAdministratorIds(bool value) {
    _$populateAdministratorIdsAtom
        .reportWrite(value, super.populateAdministratorIds, () {
      super.populateAdministratorIds = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ProviderRequestStore.isLoading', context: context);

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
      Atom(name: '_ProviderRequestStore.currentPage', context: context);

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
      Atom(name: '_ProviderRequestStore.pageSize', context: context);

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
      Atom(name: '_ProviderRequestStore.hasMore', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_ProviderRequestStore.errorMessage', context: context);

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

  late final _$searchQueryAtom =
      Atom(name: '_ProviderRequestStore.searchQuery', context: context);

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
      Atom(name: '_ProviderRequestStore.startDateFilter', context: context);

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
      Atom(name: '_ProviderRequestStore.endDateFilter', context: context);

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
      Atom(name: '_ProviderRequestStore.tagFilter', context: context);

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

  late final _$selectedProviderRequestIdAtom = Atom(
      name: '_ProviderRequestStore.selectedProviderRequestId',
      context: context);

  @override
  String? get selectedProviderRequestId {
    _$selectedProviderRequestIdAtom.reportRead();
    return super.selectedProviderRequestId;
  }

  @override
  set selectedProviderRequestId(String? value) {
    _$selectedProviderRequestIdAtom
        .reportWrite(value, super.selectedProviderRequestId, () {
      super.selectedProviderRequestId = value;
    });
  }

  late final _$selectedServiceIdAtom =
      Atom(name: '_ProviderRequestStore.selectedServiceId', context: context);

  @override
  String? get selectedServiceId {
    _$selectedServiceIdAtom.reportRead();
    return super.selectedServiceId;
  }

  @override
  set selectedServiceId(String? value) {
    _$selectedServiceIdAtom.reportWrite(value, super.selectedServiceId, () {
      super.selectedServiceId = value;
    });
  }

  late final _$fetchProviderRequestsAsyncAction = AsyncAction(
      '_ProviderRequestStore.fetchProviderRequests',
      context: context);

  @override
  Future<void> fetchProviderRequests({int page = 1, int pageSizeParam = 10}) {
    return _$fetchProviderRequestsAsyncAction.run(() =>
        super.fetchProviderRequests(page: page, pageSizeParam: pageSizeParam));
  }

  late final _$_ProviderRequestStoreActionController =
      ActionController(name: '_ProviderRequestStore', context: context);

  @override
  void setSelected(
      {required String providerRequestId, required String serviceId}) {
    final _$actionInfo = _$_ProviderRequestStoreActionController.startAction(
        name: '_ProviderRequestStore.setSelected');
    try {
      return super.setSelected(
          providerRequestId: providerRequestId, serviceId: serviceId);
    } finally {
      _$_ProviderRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelected() {
    final _$actionInfo = _$_ProviderRequestStoreActionController.startAction(
        name: '_ProviderRequestStore.clearSelected');
    try {
      return super.clearSelected();
    } finally {
      _$_ProviderRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_ProviderRequestStoreActionController.startAction(
        name: '_ProviderRequestStore.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_ProviderRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDateFilter(String date) {
    final _$actionInfo = _$_ProviderRequestStoreActionController.startAction(
        name: '_ProviderRequestStore.setStartDateFilter');
    try {
      return super.setStartDateFilter(date);
    } finally {
      _$_ProviderRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDateFilter(String date) {
    final _$actionInfo = _$_ProviderRequestStoreActionController.startAction(
        name: '_ProviderRequestStore.setEndDateFilter');
    try {
      return super.setEndDateFilter(date);
    } finally {
      _$_ProviderRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTagFilter(String? tag) {
    final _$actionInfo = _$_ProviderRequestStoreActionController.startAction(
        name: '_ProviderRequestStore.setTagFilter');
    try {
      return super.setTagFilter(tag);
    } finally {
      _$_ProviderRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
providerRequests: ${providerRequests},
populateClients: ${populateClients},
populateServiceIds: ${populateServiceIds},
populateVoucherIds: ${populateVoucherIds},
populateProviderIds: ${populateProviderIds},
populateAdministratorIds: ${populateAdministratorIds},
isLoading: ${isLoading},
currentPage: ${currentPage},
pageSize: ${pageSize},
hasMore: ${hasMore},
errorMessage: ${errorMessage},
searchQuery: ${searchQuery},
startDateFilter: ${startDateFilter},
endDateFilter: ${endDateFilter},
tagFilter: ${tagFilter},
selectedProviderRequestId: ${selectedProviderRequestId},
selectedServiceId: ${selectedServiceId},
completedRequests: ${completedRequests},
scheduledRequests: ${scheduledRequests},
filteredScheduledRequests: ${filteredScheduledRequests},
filteredCompletedRequests: ${filteredCompletedRequests},
scheduledCount: ${scheduledCount},
completedCount: ${completedCount}
    ''';
  }
}
