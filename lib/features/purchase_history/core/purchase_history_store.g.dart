// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PurchaseHistoryStore on _PurchaseHistoryStore, Store {
  Computed<List<Map<String, dynamic>>>? _$filteredPurchasesComputed;

  @override
  List<Map<String, dynamic>> get filteredPurchases =>
      (_$filteredPurchasesComputed ??= Computed<List<Map<String, dynamic>>>(
              () => super.filteredPurchases,
              name: '_PurchaseHistoryStore.filteredPurchases'))
          .value;

  late final _$purchasesAtom =
      Atom(name: '_PurchaseHistoryStore.purchases', context: context);

  @override
  ObservableList<Map<String, dynamic>> get purchases {
    _$purchasesAtom.reportRead();
    return super.purchases;
  }

  @override
  set purchases(ObservableList<Map<String, dynamic>> value) {
    _$purchasesAtom.reportWrite(value, super.purchases, () {
      super.purchases = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_PurchaseHistoryStore.isLoading', context: context);

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
      Atom(name: '_PurchaseHistoryStore.currentPage', context: context);

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
      Atom(name: '_PurchaseHistoryStore.pageSize', context: context);

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
      Atom(name: '_PurchaseHistoryStore.hasMore', context: context);

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
      Atom(name: '_PurchaseHistoryStore.errorMessage', context: context);

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

  late final _$lastFetchResultAtom =
      Atom(name: '_PurchaseHistoryStore.lastFetchResult', context: context);

  @override
  ValueResult<PaginatedList<OrderModel>>? get lastFetchResult {
    _$lastFetchResultAtom.reportRead();
    return super.lastFetchResult;
  }

  @override
  set lastFetchResult(ValueResult<PaginatedList<OrderModel>>? value) {
    _$lastFetchResultAtom.reportWrite(value, super.lastFetchResult, () {
      super.lastFetchResult = value;
    });
  }

  late final _$paymentFilterAtom =
      Atom(name: '_PurchaseHistoryStore.paymentFilter', context: context);

  @override
  String get paymentFilter {
    _$paymentFilterAtom.reportRead();
    return super.paymentFilter;
  }

  @override
  set paymentFilter(String value) {
    _$paymentFilterAtom.reportWrite(value, super.paymentFilter, () {
      super.paymentFilter = value;
    });
  }

  late final _$statusFilterAtom =
      Atom(name: '_PurchaseHistoryStore.statusFilter', context: context);

  @override
  String get statusFilter {
    _$statusFilterAtom.reportRead();
    return super.statusFilter;
  }

  @override
  set statusFilter(String value) {
    _$statusFilterAtom.reportWrite(value, super.statusFilter, () {
      super.statusFilter = value;
    });
  }

  late final _$startDateAtom =
      Atom(name: '_PurchaseHistoryStore.startDate', context: context);

  @override
  DateTime? get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(DateTime? value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  late final _$endDateAtom =
      Atom(name: '_PurchaseHistoryStore.endDate', context: context);

  @override
  DateTime? get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(DateTime? value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  late final _$loadOrdersFromApiAsyncAction =
      AsyncAction('_PurchaseHistoryStore.loadOrdersFromApi', context: context);

  @override
  Future<void> loadOrdersFromApi({int page = 1, int pageSize = 20}) {
    return _$loadOrdersFromApiAsyncAction
        .run(() => super.loadOrdersFromApi(page: page, pageSize: pageSize));
  }

  late final _$_PurchaseHistoryStoreActionController =
      ActionController(name: '_PurchaseHistoryStore', context: context);

  @override
  void setPaymentFilter(String filter) {
    final _$actionInfo = _$_PurchaseHistoryStoreActionController.startAction(
        name: '_PurchaseHistoryStore.setPaymentFilter');
    try {
      return super.setPaymentFilter(filter);
    } finally {
      _$_PurchaseHistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatusFilter(String filter) {
    final _$actionInfo = _$_PurchaseHistoryStoreActionController.startAction(
        name: '_PurchaseHistoryStore.setStatusFilter');
    try {
      return super.setStatusFilter(filter);
    } finally {
      _$_PurchaseHistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDate(DateTime? date) {
    final _$actionInfo = _$_PurchaseHistoryStoreActionController.startAction(
        name: '_PurchaseHistoryStore.setStartDate');
    try {
      return super.setStartDate(date);
    } finally {
      _$_PurchaseHistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDate(DateTime? date) {
    final _$actionInfo = _$_PurchaseHistoryStoreActionController.startAction(
        name: '_PurchaseHistoryStore.setEndDate');
    try {
      return super.setEndDate(date);
    } finally {
      _$_PurchaseHistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_PurchaseHistoryStoreActionController.startAction(
        name: '_PurchaseHistoryStore.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_PurchaseHistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
purchases: ${purchases},
isLoading: ${isLoading},
currentPage: ${currentPage},
pageSize: ${pageSize},
hasMore: ${hasMore},
errorMessage: ${errorMessage},
lastFetchResult: ${lastFetchResult},
paymentFilter: ${paymentFilter},
statusFilter: ${statusFilter},
startDate: ${startDate},
endDate: ${endDate},
filteredPurchases: ${filteredPurchases}
    ''';
  }
}
