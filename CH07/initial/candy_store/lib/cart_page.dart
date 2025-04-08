import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_bloc.dart';
import 'cart_event.dart';
import 'cart_list_item_view.dart';
import 'cart_repository.dart';
import 'cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();

  static Widget withBloc() {
    return BlocProvider<CartBloc>(
      create: (context) =>
          CartBloc(cartRepository: context.read<CartRepository>()),
      child: const CartPage(),
    );
  }
}

class _CartPageState extends State<CartPage> {
  //* 1. First, we have swapped our ViewModel for Cubit.
  late final CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    //* 2. Next, we get the reference to this Cubit by calling a read method on the context.
    //* This method comes from the flutter_bloc library and removes the need to create
    //* our own InheritedWidget widget that provides cubits to the widget tree.
    //* We will see this in more detail right after this snippet.
    _cartBloc = context.read<CartBloc>();
    _cartBloc.add(const Load());
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      //* 3. The next big thing is the widget that we use to observe our Cubit state:
      //* the flutter_bloc library offers several of them for different use cases,
      //* but the most robust of them is BlocConsumer. First of all, we need to
      //* specify the type of cubit and the type of state we’re working on in the
      //* constructor so that Dart can infer those types in the callbacks.
      body: BlocConsumer<CartBloc, CartState>(
        //* 4. Next, there are two interesting parameters. The first is listener,
        //* which has context and state as parameters. It is invoked when any
        //* change to the state occurs, so we don’t have to attach custom listeners
        //* as we did before. This is pretty convenient and all in one place.
        //* The second is builder, which has the same parameters but expects a
        //* widget to be returned from it – which can build based on the state.
        //! What’s more, in cases when we don’t want to rebuild the whole widget
        //! tree on any change, we can override the listenWhen and buildWhen
        //! parameters and control them from there, whether we want listener or
        //! builder to be invoked! For example, you don’t want to rebuild when an
        //! error event happens, but you do want to react to it in the listener.
        listener: (context, state) {
          if (state.loadingResult.isError) {
            _cartBloc.add(const ClearError());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to preform this action')),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) => CartListItemView(
                    item: state.items.values.toList()[index],
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
                  child: Column(
                    children: [
                      Row(
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
                          state.loadingResult.isInProgress
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  '${state.totalPrice} €',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Go Back!'),
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
