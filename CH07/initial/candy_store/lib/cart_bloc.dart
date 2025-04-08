import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_info.dart';
import 'cart_repository.dart';
import 'cart_state.dart';
import 'delayed_result.dart';

//* 1. Now, instead of extending Cubit, we extend Bloc. Note that in the diamond
//* brackets, we also specify the parent class of the events that this bloc will handle.
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(
          const CartState(
            items: {},
            totalPrice: 0,
            totalItems: 0,
            loadingResult: DelayedResult.idle(),
          ),
        ) {
    //* 2. In our constructor, we need to provide the on handlers for every type
    //* of event. This is very important because, as opposed to the cubit,
    //* we won’t be calling methods on the bloc.
    //* The on handlers are implemented by the library and they let us control how to handle the events.
    //! Another feature that comes with these handlers are transformers – while
    //! we won’t be diving into their details, keep in mind that with transformers,
    //! you can control all kinds of things: how events are handled
    //! (sequentially or asynchronously), whether to debounce the events or not, and so on.
    on<Load>(_onLoad);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ClearError>(_onClearError);
  }

  Future<void> _onLoad(Load event, Emitter emit) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      //* 3. When we load our bloc, we will read the initial state of our cart
      //* from the Model that we created previously.
      final cartInfo = await _cartRepository.cartInfoFuture;
      // ToDo: Should actually copy the Map and not just the reference, which we
      // will do at the end ot this chapter
      emit(
        state.copyWith(
          items: cartInfo.items,
          totalPrice: cartInfo.totalPrice,
          totalItems: cartInfo.totalItems,
        ),
      );
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));

      //! 4. After that, we subscribe to changes from the stream by using a
      //! special function of the bloc’s Emitter – that is, emit.onEach.
      //! It handles all of the stream subscriptions and un-subscriptions
      //! for us and lets us deal with the data that we care about.
      await emit.onEach(
        _cartRepository.cartInfoStream,
        onData: (CartInfo cartInfo) => emit(
          state.copyWith(
            items: cartInfo.items,
            totalPrice: cartInfo.totalPrice,
            totalItems: cartInfo.totalItems,
          ),
        ),
        onError: (Object error, StackTrace stackTrace) => emit(
          state.copyWith(
            loadingResult:
                DelayedResult.fromError(Exception('Failed to load cart info')),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter emit) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      await _cartRepository.addToCart(event.item);
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter emit) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      await _cartRepository.removeFromCart(event.item);
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }

  Future<void> _onClearError(ClearError event, Emitter emit) async =>
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));

  /*  @override
  Future<void> close() async {
    _cartModel.dispose();
    super.close();
  }*/
}
