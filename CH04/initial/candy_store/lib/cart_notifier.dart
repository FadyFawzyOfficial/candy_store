import 'package:flutter/material.dart';

import 'cart_list_item.dart';
import 'cart_model.dart';
import 'product_list_item.dart';

class CartNotifier extends ChangeNotifier {
  final CartModel _cartModel = CartModel();

  CartNotifier() {
    //! 1. We subscribe to the stream fo CartInfo from CartModel in the constructor of CartNotifier.
    //! Now, every time there is a change in cartInfoStream, we will update our
    //! locale fields & notify listeners as before via the notifyListeners() method.
    _cartModel.cartInfoStream.listen((cartInfo) {
      _items.clear();
      _totalItems = cartInfo.totalItems;
      _totalPrice = cartInfo.totalPrice;
      cartInfo.items.forEach((key, value) => _items[key] = value);
      notifyListeners();
    });
  }

  final Map<String, CartListItem> _items = {};
  double _totalPrice = 0;
  int _totalItems = 0;

  List<CartListItem> get items => _items.values.toList();
  double get totalPrice => _totalPrice;
  int get totalItems => _totalItems;

  //! 2. In our addToCart() and removeFromCart() methods, we now have no logic,
  //! and are just calling the methods of CartModel.
  void addToCart(ProductListItem item) => _cartModel.addToCart(item);

  void removeFromCart(CartListItem item) => _cartModel.removeFromCart(item);

  @override
  void dispose() {
    _cartModel.dispose();
    super.dispose();
  }
}
