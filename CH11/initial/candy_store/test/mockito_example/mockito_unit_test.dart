import 'dart:async';

import 'package:candy_store/cart/cart.dart';
import 'package:candy_store/cart/domain/model/cart_info.dart';
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
  });
}
