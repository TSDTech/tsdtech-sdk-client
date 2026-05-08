// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomeStore.isLoading', context: context);

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

  late final _$errorAtom = Atom(name: '_HomeStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_HomeStore.searchQuery', context: context);

  @override
  String? get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String? value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$selectedCategoryAtom =
      Atom(name: '_HomeStore.selectedCategory', context: context);

  @override
  String? get selectedCategory {
    _$selectedCategoryAtom.reportRead();
    return super.selectedCategory;
  }

  @override
  set selectedCategory(String? value) {
    _$selectedCategoryAtom.reportWrite(value, super.selectedCategory, () {
      super.selectedCategory = value;
    });
  }

  late final _$serviceTypesAtom =
      Atom(name: '_HomeStore.serviceTypes', context: context);

  @override
  List<ServiceType> get serviceTypes {
    _$serviceTypesAtom.reportRead();
    return super.serviceTypes;
  }

  @override
  set serviceTypes(List<ServiceType> value) {
    _$serviceTypesAtom.reportWrite(value, super.serviceTypes, () {
      super.serviceTypes = value;
    });
  }

  late final _$servicesAtom =
      Atom(name: '_HomeStore.services', context: context);

  @override
  List<Service> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(List<Service> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  late final _$loadInitialAsyncAction =
      AsyncAction('_HomeStore.loadInitial', context: context);

  @override
  Future<void> loadInitial() {
    return _$loadInitialAsyncAction.run(() => super.loadInitial());
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  void setSearchQuery(String q) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setSearchQuery');
    try {
      return super.setSearchQuery(q);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectCategory(String? id) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.selectCategory');
    try {
      return super.selectCategory(id);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
searchQuery: ${searchQuery},
selectedCategory: ${selectedCategory},
serviceTypes: ${serviceTypes},
services: ${services}
    ''';
  }
}
