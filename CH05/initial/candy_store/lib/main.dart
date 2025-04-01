import 'package:flutter/material.dart';

import 'cart_view_model.dart';
import 'cart_view_model_provider.dart';
import 'main_page.dart';

// At this point, all of the code is in the `lib` folder and we will structure it in Part 3
void main() {
  runApp(
    //! Because we will need CartNotifierProvider on almost every page of our app,
    //! it makes sense to have it at the very root, So we wrap MaterialApp in
    //! CartNotifierProvider.
    CartViewModelProvider(
      cartViewModel: CartViewModel(),
      child: MaterialApp(
        title: 'Candy Store',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: const MainPage(),
      ),
    ),
  );
}
