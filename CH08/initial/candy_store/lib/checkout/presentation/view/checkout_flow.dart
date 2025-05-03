import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/stub_checkout_repository.dart';
import '../../domain/repository/checkout_repository.dart';
import 'checkout_page.dart';

class CheckoutFlow extends StatefulWidget {
  const CheckoutFlow({super.key});

  @override
  State<CheckoutFlow> createState() => _CheckoutFlowState();
}

class _CheckoutFlowState extends State<CheckoutFlow> {
  @override
  Widget build(context) {
    return RepositoryProvider<CheckoutRepository>(
      create: (context) => StubCheckoutRepository(),
      child: CheckoutPage.withBloc(),
    );
  }
}
