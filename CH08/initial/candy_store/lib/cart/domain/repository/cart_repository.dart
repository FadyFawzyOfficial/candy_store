import '../model/cart_info.dart';
import '../model/cart_list_item.dart';
import '../../../product_list_item.dart';

//! First, we will create an interface called CartRepository that includes all
//! the public methods and getters from the CartModel.
//! We have now extracted everything public from the CartModel into the abstract
//! CartRepository.
abstract interface class CartRepository {
  Stream<CartInfo> get cartInfoStream;
  Future<CartInfo> get cartInfoFuture;
  Future<void> addToCart(ProductListItem item);
  Future<void> removeFromCart(CartListItem item);
}
