import 'dart:async';

import 'package:candy_store/cart/cart.dart';
import 'package:candy_store/cart/domain/model/cart_info.dart';
import 'package:candy_store/cart/presentation/bloc/cart_state.dart';
import 'package:candy_store/common/model/delayed_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
  });
}
