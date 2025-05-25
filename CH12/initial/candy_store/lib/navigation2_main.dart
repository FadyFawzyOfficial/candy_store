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

class DessertRouteInformationParser
    extends RouteInformationParser<DessertRoutePath> {
  //! The primary method, parseRouteInformation, begins by extracting the URI from
  //! the RouteInformation object to get the URL components.
  //! This step is essential because it breaks down the URL into manageable parts
  //! for further analysis.
  @override
  Future<DessertRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    // Handle '/'
    //! The method then checks whether the path segments are empty,
    //! which indicates the home page (/). If this condition is met, it returns a
    //! DessertRoutePath.home() object, directing the app to the home page where all desserts are listed.
    if (uri.pathSegments.isEmpty) return const DessertRoutePath.home();

    // Handle '/dessert/:id'
    //! For URLs with two path segments,
    if (uri.pathSegments.length == 2) {
      //! the method first ensures that the initial segment is dessert.
      //! This check helps verify that the URL is intended for a dessert details page.
      if (uri.pathSegments[0] != 'dessert') {
        //! If the first segment is not dessert, it returns DessertRoutePath.unknown(),
        //! signaling an invalid or unknown route.
        return const DessertRoutePath.unknown();
      }

      //! If the initial segment is correct, the method attempts to parse the
      //! second segment as an integer, representing the dessert ID.
      final id = int.tryParse(uri.pathSegments[1]);
      //* If parsing fails, it again returns DessertRoutePath.unknown().
      //* Any other URL pattern that does not match these conditions is also
      //* treated as unknown, with the method returning DessertRoutePath.unknown().
      if (id == null) return const DessertRoutePath.unknown();
      //! Successfully parsing this segment allows the method to return a
      //! DessertRoutePath.details(id) object, guiding the app to display
      //! details for the specified dessert.
      return DessertRoutePath.details(id);
    }

    // Handle unknown routes
    return const DessertRoutePath.unknown();
  }

  //! The restoreRouteINformation method complements this by converting a
  //! DessertRoutePath back into RouteInformation.
  @override
  RouteInformation? restoreRouteInformation(DessertRoutePath configuration) {
    //! If the path configuration indicates an unknown route, it generates a RouteInformation object with the /404 URI.
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse('/404'));
    }

    //! ensuring the browser's address bar reflects navigation to the home page.
    if (configuration.isHome) {
      return RouteInformation(uri: Uri.parse('/'));
    }

    //* When dealing with details pages, it creates a RouteInformation object with
    //* the /dessert/{id} URI, accurately representing the dessert details being viewed.
    if (configuration.isDetails) {
      return RouteInformation(
        uri: Uri.parse('/dessert/${configuration.id}'),
      );
    }

    //! If the path configuration doesn't match and known patters, it returns null
    //! indicating no valid route.
    return null;

    //! By implementing these methods, the DessertRouteInformationParser ensures
    //! that the app can correctly interpret and respond to various URL structures,
    //! maintaining a smooth and intuitive user navigation experience.
  }
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

  //? The setNewRoutePath function is called by the Router when there’s a change
  //? in the app’s navigation route. It’s an opportunity for the app to adjust
  //? its state based on the new route information. We put all that into practice
  //? in the following code block:
  @override
  Future<void> setNewRoutePath(DessertRoutePath configuration) async {
    //! If the route leads to an unknown destination, the app resets the selected
    //! dessert and flags it to show a 404-error page,
    //! indicating that the requested page couldn’t be found.
    if (configuration.isUnknown) {
      _selectedDessert = null;
      _show404 = true;
      return;
    }

    //! If the route points to a dessert’s details page
    if (configuration.isDetails) {
      //! the app checks whether the dessert ID from the route is valid.
      //! If it’s not (such as if the ID is out of range), the app prepares to show a 404 page.
      if (configuration.id! < 0 || configuration.id! >= desserts.length) {
        _show404 = true;
        return;
      }
      //! Otherwise, it updates the selected dessert to match the ID from the route.
      _selectedDessert = desserts[configuration.id!];

      //! If the route is for the home page, the app resets the selected dessert,
      //! as no specific dessert is being viewed.
    } else {
      _selectedDessert = null;
    }

    _show404 = false;
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
  final DessertRouteInformationParser _routeInformationParser =
      DessertRouteInformationParser();

  @override
  Widget build(context) {
    return MaterialApp.router(
      title: 'Candy Store',
      routerDelegate: _routeDelegate,
      routeInformationParser: _routeInformationParser,
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
