import 'package:flutter/material.dart';

import 'cart_button.dart';
import 'cart_page.dart';
import 'cart_view_model_provider.dart';
import 'products_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(context) {
    final cartViewModel = CartViewModelProvider.of(context);
    return ListenableBuilder(
      listenable: cartViewModel,
      builder: (context, _) => Stack(
        children: [
          ProductsPage(),
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () => openCart(context),
              child: CartButton(count: cartViewModel.state.totalItems),
            ),
          ),
        ],
      ),
    );
  }

  void openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage.withBloc(),
      ),
    );
  }
}
