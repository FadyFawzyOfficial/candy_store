import 'package:flutter/material.dart';

import 'cart_button.dart';
import 'cart_notifier_provider.dart';
import 'cart_page.dart';
import 'products_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(context) {
    final cartNotifier = CartNotifierProvider.of(context);
    return ListenableBuilder(
      listenable: cartNotifier,
      builder: (context, _) => Stack(
        children: [
          ProductsPage(),
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () => openCart(context),
              child: CartButton(count: cartNotifier.totalItems),
            ),
          ),
        ],
      ),
    );
  }

  void openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );
  }
}
