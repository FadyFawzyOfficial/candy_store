import 'package:flutter/material.dart';

import 'cart_view_model.dart';

class CartViewModelProvider extends InheritedWidget {
  final CartViewModel cartViewModel;

  const CartViewModelProvider({
    super.key,
    required this.cartViewModel,
    required Widget child,
  }) : super(child: child);

  static CartViewModel of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CartViewModelProvider>();

    //! Here, we added a null check. If the provider is null, we throw a specific error.
    //! This way, the user of the widget will at least have an idea of what the problem is.
    if (provider == null) {
      throw Exception('No CartViewModelProvider found in context');
    }

    return provider.cartViewModel;
  }

  @override
  bool updateShouldNotify(covariant CartViewModelProvider oldWidget) =>
      cartViewModel != oldWidget.cartViewModel;
}
