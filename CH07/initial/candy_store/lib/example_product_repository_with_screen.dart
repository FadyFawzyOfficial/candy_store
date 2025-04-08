import 'package:flutter/material.dart';

import 'simple_product_repository.dart';

final SimpleProductRepository productRepository = SimpleProductRepository();

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(context) {
    final products = productRepository.fetchProducts();
    return Scaffold(
      appBar: AppBar(title: const Text('Candy Store')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ListTile(title: Text(products[index])),
      ),
    );
  }
}

//! Run this quick, simple example from here
void main() => runApp(const MaterialApp(home: ProductListScreen()));
