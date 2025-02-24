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
    return context
        .dependOnInheritedWidgetOfExactType<CartNotifierProvider>()!
        .cartNotifier;
  }

  @override
  bool updateShouldNotify(covariant CartNotifierProvider oldWidget) =>
      cartNotifier != oldWidget.cartNotifier;
}
