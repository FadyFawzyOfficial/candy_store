import 'package:flutter/material.dart';

import 'cart_list_item.dart';
import 'cart_model.dart';
import 'cart_state.dart';
import 'product_list_item.dart';

class CartViewModel extends ChangeNotifier {
  // ToDo: Inject this in the DI chapter
  final CartModel _cartModel = CartModel();

  CartState _state = CartState(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartViewModel() {
    //! 1. We subscribe to the stream fo CartInfo from CartModel in the constructor of CartNotifier.
    //! Now, every time there is a change in cartInfoStream, we will update our
    //! locale fields & notify listeners as before via the notifyListeners() method.
    _cartModel.cartInfoStream.listen((cartInfo) {
      // ToDo: Should actually copy the Map and not just the reference.
      _state = _state.copyWith(
        items: cartInfo.items,
        totalPrice: cartInfo.totalPrice,
        totalItems: cartInfo.totalItems,
      );
      notifyListeners();
    });
  }

  CartState get state => _state;

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
