import 'package:flutter/material.dart';

void main() => runApp(const CandyStoreApp());

class Dessert {
  final String name;
  final String description;
  final String imageUrl;

  const Dessert(this.name, this.description, this.imageUrl);
}

class CandyStoreApp extends StatefulWidget {
  const CandyStoreApp({super.key});

  @override
  State<CandyStoreApp> createState() => _CandyStoreAppState();
}

class _CandyStoreAppState extends State<CandyStoreApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Candy Store',
      home: Navigator(
        pages: const [
          MaterialPage(
            child: Scaffold(
              body: Center(
                child: Text('Welcome to Candy Store'),
              ),
            ),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }
}
