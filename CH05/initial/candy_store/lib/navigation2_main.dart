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
  Dessert? _selectedDessert;

  List<Dessert> desserts = [
    const Dessert(
      'Cupcake',
      'A delicious cupcake with a variety of flavors and toppings',
      'resources/images/cupcake.webp',
    ),
    const Dessert(
      'Donut',
      'A soft and sweet donut, glazed or filled with your favorite flavors',
      'resources/images/donut.webp',
    ),
    const Dessert(
      'Eclair',
      'A long pastry filled with cream and topped with chocolate icing',
      'resources/images/eclair.webp',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Candy Store',
      home: Navigator(
        pages: [
          MaterialPage(
            key: const ValueKey('DessertsListScreen'),
            child: DessertsListScreen(
              desserts: desserts,
              onTapped: _handleDessertTapped,
            ),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }

  void _handleDessertTapped(Dessert dessert) =>
      setState(() => _selectedDessert = dessert);
}

class DessertsListScreen extends StatelessWidget {
  final List<Dessert> desserts;
  final ValueChanged<Dessert> onTapped;

  const DessertsListScreen({
    super.key,
    required this.desserts,
    required this.onTapped,
  });

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Desserts')),
      body: ListView.builder(
        itemCount: desserts.length,
        itemBuilder: (context, index) {
          final dessert = desserts[index];
          return ListTile(
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.asset(dessert.imageUrl),
              ),
            ),
            title: Text(dessert.name),
            subtitle: Text(dessert.description),
            onTap: () => onTapped(dessert),
          );
        },
      ),
    );
  }
}

class DessertDetailsScreen extends StatelessWidget {
  final Dessert dessert;

  const DessertDetailsScreen({super.key, required this.dessert});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail page for ${dessert.name}')),
      body: Center(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(dessert.imageUrl),
              ),
            ),
            Text(dessert.name, style: Theme.of(context).textTheme.titleLarge),
            Text(dessert.description,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
