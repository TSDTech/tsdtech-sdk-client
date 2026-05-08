// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStore, Store {
  Computed<List<CartItem>>? _$itemsComputed;

  @override
  List<CartItem> get items => (_$itemsComputed ??=
          Computed<List<CartItem>>(() => super.items, name: '_CartStore.items'))
      .value;
  Computed<double>? _$totalComputed;

  @override
  double get total => (_$totalComputed ??=
          Computed<double>(() => super.total, name: '_CartStore.total'))
      .value;

  late final _$isDrawerOpenAtom =
      Atom(name: '_CartStore.isDrawerOpen', context: context);

  @override
  bool get isDrawerOpen {
    _$isDrawerOpenAtom.reportRead();
    return super.isDrawerOpen;
  }

  @override
  set isDrawerOpen(bool value) {
    _$isDrawerOpenAtom.reportWrite(value, super.isDrawerOpen, () {
      super.isDrawerOpen = value;
    });
  }

  late final _$_CartStoreActionController =
      ActionController(name: '_CartStore', context: context);

  @override
  void setDrawerOpen(bool v) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.setDrawerOpen');
    try {
      return super.setDrawerOpen(v);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void add(Service service) {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.add');
    try {
      return super.add(service);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(Service service) {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.remove');
    try {
      return super.remove(service);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment(Service service) {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.increment');
    try {
      return super.increment(service);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement(Service service) {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.decrement');
    try {
      return super.decrement(service);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.clear');
    try {
      return super.clear();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDrawerOpen: ${isDrawerOpen},
items: ${items},
total: ${total}
    ''';
  }
}
