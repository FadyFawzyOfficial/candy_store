import 'package:flutter/material.dart';

import 'cart_list_item_view.dart';
import 'cart_view_model.dart';
import 'cart_view_model_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //* 1. We extracted CartViewModel so that it's an instance field of _CartPageState.
  //! By doing this, we can access it outside of the build method.
  late final CartViewModel _cartViewModel;

  @override
  void initState() {
    super.initState();

    //! This is important!
    //* When accessing InheritedWidget, you have two options:

    //* You can rebuild the calling widget any time there are updates to the underlying InheritedWidget.
    //* In this case, make sure you use the getter that calls
    //! context.dependOnInheritedWidgetOfExactType<CartViewModelProvider>().
    //* This can only be called in the methods that are invoked multiple times
    //* per life cycle, such as build or didChangeDependencies.

    //* You only access InheritedWidget once and don’t receive updates.
    //* In this case, make sure you use the getter that calls
    //! context.getInheritedWidgetOfExactType<CartViewModelProvider>().
    //* It is safe to call this method from initState.

    //? 2. We read CartViewModel in initState. As you may recall, previously,
    //? we accessed CartViewModelProvider via the .of method and now it's .read.
    //! The difference in the implementation is that in the of method, we accessed
    //! InheritedWidget via the depend method by running
    //! 'context.dependOnInheritedWidgetOfExactType<CartViewModelProvider>()'.
    //! Remember, besides giving us a reference to the widget in question,
    //! it also subscribes the calling widget to the changes in InheritedWidget.
    //! We can’t do that in initState because it is called only once per life cycle.
    //! So, to just read InheritedWidget without subscribing to its changes,
    //! BuildContext has another method:
    //! 'context.getInheritedWidgetOfExactType<CartViewModelProvider>()'.
    //! This is why we’re using it in the read method of CartViewModelProvider.
    _cartViewModel = CartViewModelProvider.read(context);

    //* 3. We add a listener to CartViewModel (remember, it's a ChangeNotifier
    //* class and we can also add listener to observe changes in int).
    _cartViewModel.addListener(_onCartViewModelStateChanged);
  }

  @override
  void dispose() {
    //! 6. To make sure that we didn't leak any resources, we dispose of our ViewModel
    //! in the state's dispose method. Under the hood, this method removes any listeners
    //! that we have added to ChangeNotifier.
    _cartViewModel.removeListener(_onCartViewModelStateChanged);
    _cartViewModel.dispose();
    super.dispose();
  }

  void _onCartViewModelStateChanged() {
    //* 4. We currently handle only the error state. We did this by showing a
    //* snack bar with the error text.
    if (_cartViewModel.state.error != null) {
      //* 5. Once we consumed the error, we cleared it up via the clearError() method
      _cartViewModel.clearError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to preform this action')),
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ListenableBuilder(
        listenable: _cartViewModel,
        builder: (context, _) => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: _cartViewModel.state.items.length,
                itemBuilder: (context, index) => CartListItemView(
                  item: _cartViewModel.state.items.values.toList()[index],
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
                    //! 7. Finally, we used the isProcessing flag to decide what
                    //! kind of UI we wanted to build. If we want, we can even
                    //! show the full-screen error if our error field in not null.
                    //! This is up to the designs, but we now have all of the
                    //! business logic to do that.
                    _cartViewModel.state.isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            '${_cartViewModel.state.totalPrice} €',
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
      ),
    );
  }
}
