import 'package:flutter/material.dart';

import 'cart_view_model.dart';

class CartViewModelProvider extends InheritedWidget {
  final CartViewModel cartViewModel;

  const CartViewModelProvider({
    super.key,
    required this.cartViewModel,
    required Widget child,
  }) : super(child: child);

  //! This is important!
  //* When accessing InheritedWidget, you have two options:

  //* You can rebuild the calling widget any time there are updates to the underlying InheritedWidget.
  //* In this case, make sure you use the getter that calls
  //! context.dependOnInheritedWidgetOfExactType<CartViewModelProvider>().
  //* This can only be called in the methods that are invoked multiple times
  //* per life cycle, such as build or didChangeDependencies.

  //* You only access InheritedWidget once and don’t receive updates.
  //* In this case, make sure you use the getter that calls
  //! context.getInheritedWidgetOfExactType<CartViewModelProvider>().
  //* It is safe to call this method from initState.

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

  static CartViewModel read(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<CartViewModelProvider>();

    if (provider == null) {
      throw Exception('No CartViewModelProvider found in context');
    }

    return provider.cartViewModel;
  }

  @override
  bool updateShouldNotify(CartViewModelProvider oldWidget) =>
      cartViewModel != oldWidget.cartViewModel;
}
