import 'package:flutter/material.dart';

import 'cart_notifier.dart';
import 'cart_notifier_provider.dart';
import 'main_page.dart';

// At this point, all of the code is in the `lib` folder and we will structure it in Part 3
void main() {
  runApp(
    //! Because we will need CartNotifierProvider on almost every page of our app,
    //! it makes sense to have it at the very root, So we wrap MaterialApp in
    //! CartNotifierProvider.
    CartNotifierProvider(
      cartNotifier: CartNotifier(),
      child: MaterialApp(
        title: 'Candy store',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: const MainPage(),
      ),
    ),
  );
}
