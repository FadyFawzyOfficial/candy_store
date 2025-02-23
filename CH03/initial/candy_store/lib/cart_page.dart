import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/cart_list_item_view.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final ValueNotifier<Map<String, CartListItem>> items;
  final Function(CartListItem) onRemoveFromCart;
  final Function(CartListItem) onAddToCart;

  const CartPage({
    super.key,
    required this.items,
    required this.onRemoveFromCart,
    required this.onAddToCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ValueListenableBuilder(
        valueListenable: widget.items,
        builder: (context, items, _) {
          final values = items.values.toList();
          final totalPrice = values.fold<double>(
            0,
            (previous, element) =>
                previous + (element.product.price * element.quantity),
          );

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: values.length,
                  itemBuilder: (context, index) => CartListItemView(
                    item: values[index],
                    onRemoveFromCart: widget.onRemoveFromCart,
                    onAddToCart: widget.onAddToCart,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '$totalPrice €',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
