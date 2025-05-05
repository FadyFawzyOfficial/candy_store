import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product/data/service/api_service.dart';
import 'product/data/repository/app_product_repository.dart';
import 'cart/presentation/view/cart_page.dart';
import 'cart/domain/repository/cart_repository.dart';
import 'product/data/service/hive_service.dart';
import 'cart/data/repository/in_memory_cart_repository.dart';
import 'product/data/repository/local_product_repository.dart';
import 'main_page.dart';
import 'product/data/repository/network_product_repository.dart';
import 'product/domain/repository/product_repository.dart';

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
