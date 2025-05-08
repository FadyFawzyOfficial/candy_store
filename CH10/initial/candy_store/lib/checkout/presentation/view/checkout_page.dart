import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/checkout_repository.dart';
import '../cubit/checkout_cubit.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();

  static Widget withBloc() {
    return BlocProvider(
      create: (context) => CheckoutCubit(
        checkoutRepository: context.read<CheckoutRepository>(),
      )..loadPaymentMethods(),
      child: const CheckoutPage(),
    );
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CheckoutCubit _checkoutCubit;

  @override
  void initState() {
    super.initState();
    _checkoutCubit = context.read<CheckoutCubit>();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) => state.checkoutResult.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Select Payment Method',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    ...state.paymentMethods.map(
                      (method) => Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(method),
                          leading: Radio(
                            value: method,
                            groupValue: state.selectedPaymentMethod,
                            onChanged: (value) => _checkoutCubit
                                .selectPaymentMethod(value as String),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.selectedPaymentMethod != 'none'
                            ? _checkout
                            : null,
                        child: const Text('Checkout'),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void _checkout() {
    final paymentMethod = _checkoutCubit.state.selectedPaymentMethod;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checked out with $paymentMethod...')));
    _checkoutCubit.checkout(paymentMethod);
    Navigator.pop(context);
  }
}
