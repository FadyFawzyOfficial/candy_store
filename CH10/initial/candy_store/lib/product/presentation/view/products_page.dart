import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/product_repository.dart';
import '../bloc/products_bloc.dart';
import '../widget/product_list_item_view.dart';

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
    final progress = context
        .select((ProductsBloc bloc) => bloc.state.loadingResult)
        .isInProgress;
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (query) =>
                  context.read<ProductsBloc>().add(SearchProducts(query)),
            ),
          ),
          const SizedBox(height: 16),
          if (progress) const CircularProgressIndicator(),
          if (items.isEmpty && !progress) const Text('No items found'),
          if (!progress)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ProductListItemView(item: item);
                },
              ),
            ),
        ],
      ),
    );
  }
}
