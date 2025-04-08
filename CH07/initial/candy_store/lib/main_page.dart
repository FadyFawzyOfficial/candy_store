import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_bloc.dart';
import 'cart_button.dart';
import 'cart_event.dart';
import 'products_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Widget witBloc() {
    return BlocProvider(
      create: (context) => CartBloc()..add(const Load()),
      child: const MainPage(),
    );
  }

  @override
  Widget build(context) {
    final totalItemsCount =
        context.select<CartBloc, int>((CartBloc bloc) => bloc.state.totalItems);
    return Stack(
      children: [
        const ProductsPage(),
        Positioned(
          right: 16,
          bottom: 16,
          child: GestureDetector(
            onTap: () => openCart(context),
            child: CartButton(count: totalItemsCount),
          ),
        ),
      ],
    );
  }

  //! This is the imperative style navigation with anonymous routing.
  void openCart(BuildContext context) =>
      Navigator.of(context).pushNamed('/cart');
}
