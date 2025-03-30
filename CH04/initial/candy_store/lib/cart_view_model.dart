import 'package:flutter/material.dart';

import 'cart_list_item.dart';
import 'cart_model.dart';
import 'cart_state.dart';
import 'product_list_item.dart';

class CartViewModel extends ChangeNotifier {
  // ToDo: Inject this in the DI chapter
  final CartModel _cartModel = CartModel();

  CartState _state = const CartState(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartViewModel() {
    _cartModel.cartInfoStream.listen((cartInfo) {
      // ToDo: Should actually copy the Map and not just the reference.
      //! 1. Instead of updating separate fields, we now always update the state object.
      _state = _state.copyWith(
        items: cartInfo.items,
        totalPrice: cartInfo.totalPrice,
        totalItems: cartInfo.totalItems,
      );
      notifyListeners();
    });
  }

  CartState get state => _state;

  //* 2. In the addToCart() method, we now set the state to isProcessing when we
  //* start some action, as well as catch the error and set it to state if it happens.
  Future<void> addToCart(ProductListItem item) async {
    try {
      _state = _state.copyWith(isProcessing: true);
      notifyListeners();
      await _cartModel.addToCart(item);
      _state = _state.copyWith(isProcessing: false);
    } on Exception catch (e) {
      _state = _state.copyWith(error: e);
    }
    notifyListeners();
  }

  Future<void> removeFromCart(CartListItem item) async {
    try {
      _state = _state.copyWith(isProcessing: true);
      notifyListeners();
      await _cartModel.removeFromCart(item);
      _state = _state.copyWith(isProcessing: false);
    } on Exception catch (e) {
      _state = _state.copyWith(error: e);
    }
    notifyListeners();
  }

  //? 3. We introduced this method to reset the error filed of the state.
  //! We will use it to consume the error once we have addressed it in the UI.
  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  @override
  void dispose() {
    _cartModel.dispose();
    super.dispose();
  }
}
