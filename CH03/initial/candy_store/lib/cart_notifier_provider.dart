import 'package:candy_store/cart_notifier.dart';
import 'package:flutter/material.dart';

class CartNotifierProvider extends InheritedWidget {
  final CartNotifier cartNotifier;

  const CartNotifierProvider({
    super.key,
    required this.cartNotifier,
    required Widget child,
  }) : super(child: child);

  static CartNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CartNotifierProvider>();

    //! Here, we added a null check. If the provider is null, we throw a specific error.
    //! This way, the user of the widget will at least have an idea of what the problem is.
    if (provider == null) {
      throw Exception('No CartNotifierProvider found in context');
    }

    return provider.cartNotifier;
  }

  @override
  bool updateShouldNotify(covariant CartNotifierProvider oldWidget) =>
      cartNotifier != oldWidget.cartNotifier;
}
