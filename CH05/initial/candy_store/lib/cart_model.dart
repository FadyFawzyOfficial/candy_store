import 'dart:async';

import 'cart_info.dart';
import 'cart_list_item.dart';
import 'product_list_item.dart';

class CartModel {
  //! 1. First, we created a singleton constructor so that it is possible to create
  //! only a single instance of CartModel. We did this so that the information in
  //! this model is consistent across the whole application.
  CartModel._internal();

  static final CartModel _instance = CartModel._internal();

  factory CartModel() => _instance;

  final CartInfo _cartInfo = CartInfo(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartInfo get cartInfo => _cartInfo;

  //! 2. Then, we updated StreamController to broadcast. This is a special
  //! functionality of a stream in Dart, which allows the stream to be listened
  //! to by many listeners, instead of one. This is required if we create several
  //! instances of the same cubit.
  final StreamController<CartInfo> _cartInfoController =
      StreamController<CartInfo>.broadcast();

  Stream<CartInfo> get cartInfoStream => _cartInfoController.stream;

  Future<CartInfo> get cartInfoFuture async =>
      _cartInfo.copyWith(items: Map.unmodifiable(_cartInfo.items));

  void dispose() => _cartInfoController.close();

  //! 1. We changed the void type to Future<void> to introduce delay that imitates
  //! a request to the real API.
  Future<void> addToCart(ProductListItem item) async {
    //* 2. We add a 3-seconds delay to that we can see it in the UI when we handle it.
    await Future.delayed(const Duration(seconds: 3));
    //? 3.In this case, the code is commented, but to test error handling,
    //? we will uncomment the code that throws exceptions
    // throw Exception('Could not add item to the cart');
    CartListItem? existingItem = _cartInfo.items[item.id];
    if (existingItem != null) {
      existingItem = CartListItem(
        product: existingItem.product,
        quantity: existingItem.quantity + 1,
      );
      _cartInfo.items[item.id] = existingItem;
    } else {
      _cartInfo.items[item.id] = CartListItem(
        product: item,
        quantity: 1,
      );
    }

    _cartInfo.totalItems++;
    _cartInfo.totalPrice += item.price;

    final cartInfo =
        _cartInfo.copyWith(items: Map.unmodifiable(_cartInfo.items));

    _cartInfoController.add(cartInfo);
  }

  Future<void> removeFromCart(CartListItem item) async {
    await Future.delayed(const Duration(seconds: 3));
    // throw Exception('Could not remove item from cart')
    CartListItem? existingItem = _cartInfo.items[item.product.id];
    if (existingItem != null) {
      if (existingItem.quantity > 1) {
        existingItem = CartListItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        );
        _cartInfo.items[item.product.id] = existingItem;
      } else {
        _cartInfo.items.remove(item.product.id);
      }
    }

    _cartInfo.totalItems--;
    _cartInfo.totalPrice -= item.product.price;

    final cartInfo =
        _cartInfo.copyWith(items: Map.unmodifiable(_cartInfo.items));

    _cartInfoController.add(cartInfo);
  }
}
