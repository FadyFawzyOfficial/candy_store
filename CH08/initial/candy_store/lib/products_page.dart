import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_bloc.dart';
import 'cart_event.dart';
import 'product_list_item_view.dart';
import 'product_repository.dart';
import 'products_bloc.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) =>
          ProductsBloc(productRepository: context.read<ProductRepository>())
            ..add(const FetchProducts()),
      child: const ProductsView(),
    );
  }
}

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(context) {
    final items = context.select((ProductsBloc bloc) => bloc.state.items);
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ProductListItemView(
            item: item,
            onAddToCart: (item) => context.read<CartBloc>().add(AddItem(item)),
          );
        },
      ),
    );
  }
}
