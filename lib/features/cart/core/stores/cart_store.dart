import 'package:mobx/mobx.dart';
import 'dart:async';

import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/core/local_storage/cart/cart.prefs.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  final ObservableList<CartItem> _items = ObservableList<CartItem>();
  @observable
  bool isDrawerOpen = false;

  @action
  void setDrawerOpen(bool v) {
    isDrawerOpen = v;
  }

  _CartStore() {
    // load persisted cart if any
    final saved = CartPrefs.get();
    if (saved != null) {
      try {
        for (final m in saved) {
          _items.add(CartItem.fromJson(m.toJson()));
        }
      } catch (_) {
        // ignore restore errors
      }
    }
  }

  @computed
  List<CartItem> get items => List.unmodifiable(_items);

  @action
  void add(Service service) {
    final idx = _items.indexWhere((i) => i.service.id == service.id);
    if (idx >= 0) {
      final existing = _items[idx];
      _items[idx] = CartItem(service: existing.service, quantity: existing.quantity + 1);
    } else {
      _items.add(CartItem(service: service, quantity: 1));
    }
    _persist();
  }

  @action
  void remove(Service service) {
  _items.removeWhere((i) => i.service.id == service.id);
    _persist();
  }

  @action
  void increment(Service service) {
    final idx = _items.indexWhere((i) => i.service.id == service.id);
    if (idx >= 0) {
      final existing = _items[idx];
  _items[idx] = CartItem(service: existing.service, quantity: existing.quantity + 1);
      _persist();
    }
  }

  @action
  void decrement(Service service) {
    final idx = _items.indexWhere((i) => i.service.id == service.id);
    if (idx >= 0) {
      final existing = _items[idx];
      if (existing.quantity > 1) {
        _items[idx] = CartItem(service: existing.service, quantity: existing.quantity - 1);
        _persist();
      } else {
        _items.removeAt(idx);
        _persist();
      }
    }
  }

  bool contains(Service service) {
    return _items.any((i) => i.service.id == service.id);
  }

  int quantityOf(Service service) {
    return _items.firstWhere((i) => i.service.id == service.id, orElse: () => CartItem(service: service, quantity: 0)).quantity;
  }

  @computed
  double get total {
    double sum = 0;
    for (final i in _items) {
      final price = i.service.price ?? 0.0;
      sum += (price * i.quantity);
    }
    return sum;
  }

  

  @action
  void clear() {
    _items.clear();
    _persist();
  }

  Future<void> _persist() async {
    try {
  await CartPrefs.set(_items.toList());
    } catch (_) {
      // ignore persistence errors
    }
  }
}
