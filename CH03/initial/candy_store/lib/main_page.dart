import 'package:flutter/material.dart';

import 'cart_button.dart';
import 'cart_notifier.dart';
import 'cart_page.dart';
import 'products_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CartNotifier cartNotifier = CartNotifier();

  @override
  void initState() {
    super.initState();
    cartNotifier.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    cartNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Stack(
      children: [
        ProductsPage(onAddToCart: cartNotifier.addToCart),
        Positioned(
          right: 16,
          bottom: 16,
          child: GestureDetector(
            onTap: openCart,
            child: CartButton(count: cartNotifier.totalItems),
          ),
        ),
      ],
    );
  }

  void openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(cartNotifier: cartNotifier),
      ),
    );
  }
}
