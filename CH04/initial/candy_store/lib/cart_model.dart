import 'dart:async';

import 'cart_info.dart';
import 'cart_list_item.dart';
import 'product_list_item.dart';

class CartModel {
  final CartInfo _cartInfo = CartInfo(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartInfo get cartInfo => _cartInfo;

  //! 1. we have created Stream and StreamController.
  //* Here, Stream is what stores the data and StreamController is what helps us
  //* manage how new data, as well as subscriptions, is emitted.
  final StreamController<CartInfo> _cartInfoController =
      StreamController<CartInfo>();

  Stream<CartInfo> get cartInfoStream => _cartInfoController.stream;

  //* We created a Future that returns a single instance of CartInfo.
  //* This can be used for single reads when we don't need to listen to the updates.
  Future<CartInfo> get CartInfoFuture async => _cartInfo;

  //! 3. To notify our listener that there will be no more events, we need to call
  // ! the close() method of StreamController. We encapsulated this in the dispose()
  //! method of CartModel so that we don't leak the details of the implementation to the outside.
  void dispose() => _cartInfoController.close();

  void addToCart(ProductListItem item) {
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

    //! 2. Use the add() method ot StreamController to ad new data to our stream.
    //? What we passed there is _cartInfo.
    _cartInfoController.add(_cartInfo);

    // notifyListeners();
  }

  void removeFromCart(CartListItem item) {
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

    _cartInfoController.add(_cartInfo);

    // notifyListeners();
  }
}
