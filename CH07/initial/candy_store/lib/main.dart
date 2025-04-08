import 'package:flutter/material.dart';

import 'api_service.dart';
import 'cart_page.dart';
import 'hive_service.dart';
import 'main_page.dart';

final hiveService = HiveService();
final apiService = ApiService();

// At this point, all of the code is in the `lib` folder and we will structure it in Part 3
Future<void> main() async {
  await hiveService.initializeHive();
  runApp(
    MaterialApp(
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
  );
}
