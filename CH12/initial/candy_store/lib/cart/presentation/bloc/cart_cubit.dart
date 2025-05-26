import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/delayed_result.dart';
import '../../../product/domain/model/product_list_item.dart';
import '../../domain/model/cart_list_item.dart';
import '../../domain/repository/cart_repository.dart';
import 'cart_state.dart';

//* 1. First of all, instead of extending ChangeNotifier, we now extend Cubit.
//* Pay attention to how we also specify CartState in the angle bracket that
//* we will be working with. Here, Cubit supports the state out of the box.
class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  //* 2. It also expects the state from the moment of its creation so that it always
  //* has relevant information and the consumer of this state can rely on it.
  //* To do that, we need to pass the initial state to the super constructor.
  //* We can do this internally, or if we want, we can allow the callers of our
  //* constructor to pass their own value. This is up to us and our use case.
  CartCubit({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(
          const CartState(
            items: {},
            totalPrice: 0,
            totalItems: 0,
            loadingResult: DelayedResult.idle(),
          ),
        ) {
    _cartRepository.cartInfoStream.listen(
      //* 3. Here, Cubit has a special function that we need to call to notify
      //* our subscribers of state changes. Similarly, we called notifyListeners
      //* on ChangeNotifier, but now, we need to call emit and also pass the state to this emitter.
      //* It will soon come in handy when we need to distinguish whether there were any actual state changes or not.
      (cartInfo) => emit(
        state.copyWith(
          items: cartInfo.items,
          totalPrice: cartInfo.totalPrice,
          totalItems: cartInfo.totalItems,
        ),
      ),
    );
  }

  Future<void> loadCart() async {
    try {
      //* 4. Just to emphasize, every time we make changes to our state,
      //* we just call emit and pass the new state as the parameter.
      //* We don’t need to call notifyListeners after any internal state changes
      //* as the emit function does everything.
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      final cartInfo = await _cartRepository.cartInfoFuture;
      // ToDo: Should actually copy the Map and not just the reference, which
      // we will do at the end of this chapter.

      emit(state.copyWith(
          items: cartInfo.items,
          totalPrice: cartInfo.totalPrice,
          totalItems: cartInfo.totalItems,
      ));

      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }

  Future<void> addToCart(ProductListItem item) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      await _cartRepository.addToCart(item);
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }

  Future<void> removeFromCart(CartListItem item) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      await _cartRepository.removeFromCart(item);
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }

  void clearError() =>
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));

  // @override
  // Future<void> close() async {
  //   //* 5. Finally, Cubit has its own close function where we can dispose of any resources that we have acquired.
  //   _cartRepository.dispose();
  //   super.close();
  // }
}
