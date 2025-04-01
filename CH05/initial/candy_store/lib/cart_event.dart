import 'cart_list_item.dart';
import 'product_list_item.dart';

//! We will have the parent as a sealed class, which will act as the umbrella type
//! for all of the events of this bloc, and a specific event per specific action,
//! such as load, add, or remove.
sealed class CartEvent {
  const CartEvent();
}

final class Load extends CartEvent {
  const Load();
}

final class AddItem extends CartEvent {
  final ProductListItem item;

  const AddItem(this.item);
}

final class RemoveItem extends CartEvent {
  final CartListItem item;

  const RemoveItem(this.item);
}

final class ClearError extends CartEvent {
  const ClearError();
}
