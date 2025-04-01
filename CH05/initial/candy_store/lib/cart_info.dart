import 'cart_list_item.dart';

//! Combine the fields related to the cart information into a single class (this),
//! which will be responsible for describing the current state of the cart.
class CartInfo {
  Map<String, CartListItem> items;
  double totalPrice;
  int totalItems;

  CartInfo({
    required this.items,
    required this.totalPrice,
    required this.totalItems,
  });

  CartInfo copyWith({
    Map<String, CartListItem>? items,
    double? totalPrice,
    int? totalItems,
  }) {
    return CartInfo(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}
