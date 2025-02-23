import 'package:flutter/material.dart';

import 'cart_list_item_view.dart';
import 'cart_notifier.dart';

class CartPage extends StatefulWidget {
  final CartNotifier cartNotifier;

  const CartPage({super.key, required this.cartNotifier});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    widget.cartNotifier.addListener(_updateCart);
  }

  @override
  void dispose() {
    //! Since CartPageState did not create cartNotifier and instead received it
    //! as an argument in the constructor, we only need to remove the listener
    //! rather than dispose of the entire notifier.
    widget.cartNotifier.removeListener(_updateCart);
    super.dispose();
  }

  void _updateCart() => setState(() {});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: widget.cartNotifier.totalItems,
              itemBuilder: (context, index) => CartListItemView(
                item: widget.cartNotifier.items[index],
                onRemoveFromCart: widget.cartNotifier.removeFromCart,
                onAddToCart: (item) =>
                    widget.cartNotifier.addToCart(item.product),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
                    '${widget.cartNotifier.totalPrice} €',
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
      ),
    );
  }
}
