import 'package:equatable/equatable.dart';

import '../../domain/model/cart_list_item.dart';
import '../../../delayed_result.dart';

class CartState extends Equatable {
  final Map<String, CartListItem> items;
  final double totalPrice;
  final int totalItems;
  //! Now, instead of the isProcessing and error fields, we have one - the loadingResult filed.
  //! Instead of setting different fields for progress and errors, we now manipulate the status
  //! with just one, and it's always consistent with the actual state of things.
  final DelayedResult<void> loadingResult;

  const CartState({
    required this.items,
    required this.totalPrice,
    required this.totalItems,
    required this.loadingResult,
  });

  CartState copyWith({
    Map<String, CartListItem>? items,
    double? totalPrice,
    int? totalItems,
    DelayedResult<void>? loadingResult,
  }) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
      loadingResult: loadingResult ?? this.loadingResult,
    );
  }

  @override
  List<Object?> get props => [items, totalPrice, totalItems, loadingResult];
}
