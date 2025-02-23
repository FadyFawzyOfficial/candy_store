import 'package:flutter/material.dart';

import 'cart_list_item.dart';

class CartNotifier extends ChangeNotifier {
  final Map<String, CartListItem> _items = {};
  final double _totalPrice = 0;
  final int _totalItems = 0;

  List<CartListItem> get items => _items.values.toList();
  double get totalPrice => _totalPrice;
  int get totalItems => _totalItems;
}
