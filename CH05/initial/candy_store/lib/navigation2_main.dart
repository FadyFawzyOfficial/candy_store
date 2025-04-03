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

//! Now, our DessertRouteDelegate is more than just a simple class; it's a
//! ChangeNotifier. This change allows us to use notifyListeners instead of setState
//! for updating the app's state.
//! notifyListeners tells everyone listening (such as our Router widget) that something
//! has changed, so they should look again and update what they're showing.
//! This ensures that the app reacts properly. It updates the displayed page and
//! the URL in the browser, keeping everything in sync.

//! This is part of moving from managing states within a widget to using broader
//! app-level state management. It makes our app smarter about when to update
//! and redraw screens, improving performance and user experience.
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

  DessertRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  //! override the currentConfiguration getter in DessertRouterDelegate to
  //! accurately reflect the app’s current state in the URL.
  //! This involves returning a DessertRoutePath.unknown() when show404 is true,
  //! a DessertRoutePath.home() when no dessert is selected,
  //! and a DessertRoutePath.details() with the correct index when a dessert is selected.
  @override
  DessertRoutePath? get currentConfiguration {
    if (_show404) return const DessertRoutePath.unknown();
    return _selectedDessert == null
        ? const DessertRoutePath.home()
        : DessertRoutePath.details(desserts.indexOf(_selectedDessert!));
  }

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Candy Store',
      //! We have a Navigator widget in our app that uses a special key, navigatorKey,
      //! to keep track of the navigation history and state.
      //! This Navigator widget decides what screen or page to show based on the
      //! current app state.
      //* It starts with showing a list of desserts on the DessertsListScreen.
      //* Here you can choose any dessert to see more details.
      //* If there's an error or the page can't be found (such as when a wrong URL is entered),
      //* it shows the UnknownScreen to let you know that something went wrong.
      //* When you select a dessert, it shows the DessertDetailsScreen to give
      //* you more info about the chosen dessert.
      home: Navigator(
        key: navigatorKey,
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
          //! Update your navigation logic to include the UnknownScreen when the show404 flag is true.
          if (_show404)
            const MaterialPage(
              key: ValueKey('UnknownScreen'),
              child: UnknownScreen(),
            )
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          // Update the list of pages by setting _selectedDessert to null

          _selectedDessert = null;
          _show404 = false;
          notifyListeners();

          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(DessertRoutePath configuration) {
    throw UnimplementedError();
  }

  void _handleDessertTapped(Dessert dessert) {
    _selectedDessert = dessert;
    notifyListeners();
  }
}

class CandyStoreApp extends StatefulWidget {
  const CandyStoreApp({super.key});

  @override
  State<CandyStoreApp> createState() => _CandyStoreAppState();
}

class _CandyStoreAppState extends State<CandyStoreApp> {
  final DessertRouteDelegate _routeDelegate = DessertRouteDelegate();

  @override
  Widget build(context) {
    return MaterialApp.router(
      title: 'Candy Store',
      routerDelegate: _routeDelegate,
    );
  }
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
