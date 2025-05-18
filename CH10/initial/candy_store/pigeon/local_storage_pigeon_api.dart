//! It is worth to mentioning that the only allowed import in this file is this:
import 'package:pigeon/pigeon.dart';
//* which allows us to use the annotations. If any other import statement are added, the generator won't work.

//! 1. Pigeon operates based on code annotations. This means that as developers,
//! we annotate the code that we want to generate and then use the code generation
//! tool to generate code based on these annotations.
//! In our case, we are creating an interface for calling code from the client (Flutter)
//! to the host (native), which is why we annotate our interface with the @HostApi() annotation.
@HostApi()
//* 2. We create a regular Dart interface, just like we would in a typical Flutter app.
abstract class LocalStorageApi {
  void addFavorite(String id);
  //! 3. This is where the peculiarities of pigeon come into play.
  //* The current limitation of pigeon (as of version 12.0) is that
  //* we cannot import any files or libraries into this files; otherwise, the
  //* generator will throw an error. So, if we want to use any custom classes
  //* that are not already present in Dart, we need to define them within this exact file.
  List<FavoriteProduct> getFavorites();
  bool isFavorite(String id);
  void removeFavorite(String id);
}

//* 4. Let's consider our FavoriteProduct class as an example of a complex class.
//! Since it is a custom class, we define it in the locale_storage_pigeon_api.dart file.
//* This may not be convenient, especially if we have many custom classes,
//* but it is a  trade-off for the sake of type safety.
//! In my opinion, the benefits of type safety outweigh this inconvenience by a large margin.
class FavoriteProduct {
  final String id;

  FavoriteProduct(this.id);
}
