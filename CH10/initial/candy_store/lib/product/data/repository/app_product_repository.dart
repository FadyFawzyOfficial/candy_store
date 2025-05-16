// import 'dart:isolate';

import 'package:flutter/foundation.dart';

import '../../domain/model/product.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/products_data.dart';
import 'local_product_repository.dart';
import 'network_product_repository.dart';

//! In this AppProductRepository class, we inject both the local and API data
//! sources through its constructor. When the fetchProducts method is called,
//! it first tries to retrieve candies from the local data source.
//! If the local data source contains data, it returns that data.
//! If the local data source is empty, it fetches data from the API data source,
//! caches it locally, and then returns it.
class AppProductRepository implements ProductRepository {
  final NetworkProductRepository _remoteDataSource;
  final LocalProductRepository _localProductRepository;

  AppProductRepository({
    required NetworkProductRepository remoteDataSource,
    required LocalProductRepository localProductRepository,
  })  : _remoteDataSource = remoteDataSource,
        _localProductRepository = localProductRepository;

  @override
  Future<List<Product>> fetchProduct() async {
    // Retrieve candies from the local data source
    final localProducts = await _localProductRepository.fetchProduct();

    // Check if local data source has data
    if (localProducts.isNotEmpty) {
      return localProducts;
    } else {
      // If local data source is empty, fetch from API and cache it locally
      final apiProducts = await _remoteDataSource.fetchProduct();
      await _localProductRepository.cacheProducts(apiProducts);
      return apiProducts;
    }
  }

  @override
  Future<Product> fetchProductById(int id) {
    // Fetch a specific Product by ID
    // Transform the raw data if necessary
    // Return the Product object
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(Product product) {
    // Update product data in the data source
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = fakeSearchData;
    if (query.isEmpty) return products;

    //! Note: isolates are note supported on the web. So, if you want to avoid
    //! errors on the web, instead of using the `isolate.run` function, you can
    //! use the special `compute` function. On native platforms, it will use
    //! `Isolate.run`, and on the web, it will run code synchronously.
    //! The updated code would look like this:
    final results = await compute(_search, query);
    // final results = await Isolate.run(() => _search(query));
    return results;
  }

  static List<Product> _search(String query) {
    final products = fakeSearchData;
    final filtered = products.where((product) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) return true;

      final nameDistance = _levenshteinDistance(
        product.name.toLowerCase(),
        query.toLowerCase(),
      );

      final descriptionDistance = _levenshteinDistance(
        product.description.toLowerCase(),
        query.toLowerCase(),
      );

      return nameDistance <= 3 || descriptionDistance <= 3;
    }).toList();

    return filtered;
  }

  static int _levenshteinDistance(String a, String b) {
    if (a == b) return 0;

    if (a.isEmpty) return b.length;

    if (b.isEmpty) return a.length;

    List<List<int>> matrix = List.generate(
      b.length + 1,
      (i) => List.generate(
        a.length + 1,
        (j) => j,
        growable: false,
      ),
      growable: false,
    );

    for (var i = 1; i <= b.length; i++) {
      matrix[i][0] = i;
    }

    for (var i = 1; i <= b.length; i++) {
      for (var j = 1; j <= a.length; j++) {
        int substitutionCost = (a[j - 1] == b[i - 1]) ? 0 : 1;
        matrix[i][j] = _min(
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + substitutionCost, // substitution
        );
      }
    }

    return matrix[b.length][a.length];
  }

  static int _min(int a, int b, int c) =>
      (a < b) ? (a < c ? a : c) : (b < c ? b : c);
}
