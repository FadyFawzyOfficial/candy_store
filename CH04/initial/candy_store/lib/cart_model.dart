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

    // notifyListeners();
  }
}
