import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/delayed_result.dart';
import '../../domain/repository/checkout_repository.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepository _checkoutRepository;

  CheckoutCubit({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository,
        super(const CheckoutState(
          paymentMethods: [],
          checkoutResult: DelayedResult.idle(),
        ));

  void loadPaymentMethods() async {
    final paymentMethods = await _checkoutRepository.getPaymentMethods();
    emit(state.copyWith(paymentMethods: paymentMethods));
  }

  void checkout(String paymentMethodId) async {
    emit(state.copyWith(checkoutResult: const DelayedResult.inProgress()));
    try {
      await _checkoutRepository.checkout(paymentMethodId);
      emit(state.copyWith(checkoutResult: const DelayedResult.fromValue(true)));
    } on Exception catch (e, st) {
      if (kDebugMode) {
        print('Failed to checkout: $e, $st');
      }
      emit(state.copyWith(checkoutResult: DelayedResult.fromError(e)));
    }
  }
}
