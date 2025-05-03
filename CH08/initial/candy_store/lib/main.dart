import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_service.dart';
import 'app_product_repository.dart';
import 'cart/presentation/view/cart_page.dart';
import 'cart_repository.dart';
import 'hive_service.dart';
import 'in_memory_cart_repository.dart';
import 'local_product_repository.dart';
import 'main_page.dart';
import 'network_product_repository.dart';
import 'product_repository.dart';

// At this point, all of the code is in the `lib` folder and we will structure it in Part 3
Future<void> main() async {
  final hiveService = HiveService();
  final apiService = ApiService();
  await hiveService.initializeHive();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (_) => AppProductRepository(
            remoteDataSource: NetworkProductRepository(apiService),
            localProductRepository: LocalProductRepository(
              hiveService.getProductBox(),
            ),
          ),
        ),
        RepositoryProvider<CartRepository>(
          create: (_) => InMemoryCartRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Candy Store',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage.witBloc(),
          '/cart': (context) => CartPage.withBloc(),
        },
      ),
    ),
  );
}
