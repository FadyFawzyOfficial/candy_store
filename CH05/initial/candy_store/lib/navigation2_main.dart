import 'package:flutter/material.dart';

void main() => runApp(const CandyStoreApp());

class Dessert {
  final String name;
  final String description;
  final String imageUrl;

  const Dessert(this.name, this.description, this.imageUrl);
}

//! Represents the current state of the app navigation.
//* We will handle all routes in the app with a single class. For advanced apps,
//* you can use different classes to implement a superclass or manage route
//* informations in you won way. This setup not only simplifies the management
//* of navigation states but also align the app's internal navigation with web UrL
//* standards, supporting direct navigation to pages via URLs.
class DessertRoutePath {
  final int? id;
  final bool isUnknown;

  const DessertRoutePath.home()
      : id = null,
        isUnknown = false;

  const DessertRoutePath.details(this.id) : isUnknown = false;

  const DessertRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHome => id == null && !isUnknown;
  bool get isDetails => id != null;
}

//! This Delegate is responsible for the following:
//* 1. Rendering the current route as a widget.
//* 2. Reacting to changes in the route path and updating the app's state and UI accordingly.
//* 3. Managing the navigator key, which is essential for identifying the Navigator widget this delegate is working with.
class DessertRouteDelegate extends RouterDelegate<DessertRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<DessertRoutePath> {
  //! navigatorKey: Essential for keeping track of the Navigator state,
  //! allowing the router to preform navigation actions such as pushing and popping routes.
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  //! _selectedDessert: Maintains the state of the currently selected dessert;
  //! when a user selects a dessert from the list, this property is updated, which
  //! then influences the route displayed to the user.
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

  DessertRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  // ToDo: We will handle those in next commit.
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Future<void> setNewRoutePath(DessertRoutePath configuration) {
    throw UnimplementedError();
  }
}

class CandyStoreApp extends StatefulWidget {
  const CandyStoreApp({super.key});

  @override
  State<CandyStoreApp> createState() => _CandyStoreAppState();
}

class _CandyStoreAppState extends State<CandyStoreApp> {
  Dessert? _selectedDessert;
  //! To manage error states, such as navigation to a non-existent dessert or
  //! an invalid URL, we introduce show404 flag.
  //! This flag is set to true when the app encounters an unknown route,
  bool _show404 = false;

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
          if (_selectedDessert != null)
            MaterialPage(
              key: ValueKey(_selectedDessert),
              child: DessertDetailsScreen(dessert: _selectedDessert!),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          setState(() {
            _selectedDessert = null;
            _show404 = false;
          });

          return true;
        },
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

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              '404 NOT FOUND',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'The desert you are looking for is eaten or it was never here! 👀',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
