import 'dart:async';

import 'package:candy_store/cart/cart.dart';
import 'package:candy_store/cart/domain/model/cart_info.dart';
import 'package:candy_store/cart/domain/model/cart_list_item.dart';
import 'package:candy_store/cart/presentation/bloc/cart_state.dart';
import 'package:candy_store/common/model/delayed_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data.dart';
import 'cart_repository.mocks.dart';

void main() {
  group('CartBloc Unit Tests with Mockito', () {
    //! Variable declarations
    //* These variables will be used in the tests. Here, mockCartRepository is a
    //* mock of CartRepository, cartBloc is the bloc we are testing, and cartInfoController
    //* is a StreamController class that's used to manage the stream of CartInfo updates.
    late MockCartRepository mockCartRepository;
    late CartBloc cartBloc;
    late StreamController<CartInfo> cartInfoController;

    //! This function runs before each test. It initializes the mock repository
    //! and StreamController, sets up the mock behavior for cartInfoStream,
    //! and create an instance of CartBloc using the mocked repository:
    setUp(() {
      mockCartRepository = MockCartRepository();
      cartInfoController = StreamController<CartInfo>.broadcast();

      when(mockCartRepository.cartInfoStream)
          .thenAnswer((_) => cartInfoController.stream);

      cartBloc = CartBloc(cartRepository: mockCartRepository);
    });

    //! This function runs after each test. It ensures that StreamController is
    //! closed properly so that resources can be cleaned up and memory leaks can be avoided
    tearDown(() => cartInfoController.close());

    //! This test checks that the initial state of CartBloc is correct. It ensures that
    //! when cartBloc is first created, its state has no items, a total price of 0,
    //! a total item count of 0, and an idle loading result.
    test(
      'Initial state is correct',
      () => expect(
        cartBloc.state,
        const CartState(
          items: {},
          totalPrice: 0,
          totalItems: 0,
          loadingResult: DelayedResult.idle(),
        ),
      ),
    );

    //* This test setup and execution ensures that CartBloc correctly handles
    //* the removal of an item from the cart. By using mockito to mock CartRepository,
    //* the test isolates the behavior of CartBloc and verifies its interactions
    //* with the repository, ensuring that the bloc emits the correct states throughout the process.
    test('Remove item form cart', () async {
      // We can begin the test setup for removing an item from the cart.
      // It initializes the product and cartItem, which represents a product and
      // its instance in the cart. It also sets up initialCartInfo to represent the
      // cart's state before the removal and emptyCartInfo to represent the cart's
      // state after the removal.
      final product = TestData.testProductListItem;
      final cartItem = CartListItem(product: product, quantity: 1);
      final initialCartInfo = CartInfo(
        items: {product.id: cartItem},
        totalPrice: product.price.toDouble(),
        totalItems: 1,
      );
      final emptyCartInfo = CartInfo(
        items: {},
        totalPrice: 0,
        totalItems: 0,
      );

      //! Now, we must set up mock behavior for CartRepository. Initially,
      //! cartInfoFuture returns the initialCartInfo. When removeFromCart is called,
      //! it simulates a network delay, then updates the cartInfoFuture so that it
      //! returns emptyCartInfo and adds emptyCartInfo to the cartInfoController stream:
      when(mockCartRepository.cartInfoFuture)
          .thenAnswer((_) async => initialCartInfo);
      when(mockCartRepository.removeFromCart(cartItem)).thenAnswer((_) async {
        // simulate network delay
        await Future.delayed(const Duration(milliseconds: 50));
        when(mockCartRepository.cartInfoFuture)
            .thenAnswer((_) async => emptyCartInfo);
        cartInfoController.add(emptyCartInfo);
      });

      //! We must pre-populate the cart with the product to set up the initial
      //! state for the test. This involves calling addToCart ont he repository
      //! and dispatching a Load event to CartBloc:
      await mockCartRepository.addToCart(product);
      cartBloc.add(const Load());
      await Future.delayed(const Duration(milliseconds: 200));

      //* We can also add a list to collect state changes and start listening to
      //* the CartBloc stream, adding each state to the list as it changes:
      final states = <CartState>[];
      final subscription = cartBloc.stream.listen(states.add);

      //! With this snippet, we're dispatching a RemoveItem event to CartBloc,
      //! and waiting for the event to be processed. After a delay, cancel the
      //! subscription to stop listening to state changes:
      cartBloc.add(RemoveItem(cartItem));
      await Future.delayed(const Duration(seconds: 1));
      await subscription.cancel();

      //! Verify state changes
      //! As a result, we check every step, ensure there are at least three states,
      //! check the loading states, and verify that the final state reflects that
      //! the item has been removed form the cart.
      // Should have at least 3 states
      expect(states.length, greaterThanOrEqualTo(3));
      expect(states[0].loadingResult.isInProgress, isTrue);
      expect(states[1].loadingResult.isInProgress, isFalse);
      expect(states[2].items.length, equals(0));
      expect(states[2].totalPrice, equals(0));
    });
  });
}
