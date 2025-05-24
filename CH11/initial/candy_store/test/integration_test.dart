import 'package:candy_store/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_cart_repository.dart';
import 'test_data.dart';

void main() {
  testWidgets('should display an item in the cart',
      (WidgetTester tester) async {
    final fakeCartRepository = FakeCartRepository();
    final cartBloc = CartBloc(cartRepository: fakeCartRepository);

    // Adding items to the fake repository
    final product = TestData.testProductListItem;

    await fakeCartRepository.addToCart(product);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => cartBloc,
          child: const CartPage(),
        ),
      ),
    );

    // Ensure the widget tree is built
    await tester.pump();

    //! Verify that the product's name and price are displayed correctly in the cart
    expect(find.text('Test Bean'), findsOneWidget);
    expect(find.text('Total:'), findsOneWidget);
    expect(find.text('2.0 €'), findsOneWidget);
  });
}
