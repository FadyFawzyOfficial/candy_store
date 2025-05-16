import 'package:flutter/services.dart';

import '../../../product/domain/model/product_list_item.dart';
import '../../domain/repository/favorite_repository.dart';

class LocalFavoriteRepository extends FavoriteRepository {
  static const _platform = MethodChannel('com.example.candy_store/favorite');

  @override
  Future<void> addFavorite(ProductListItem item) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductListItem>> getFavorites() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavorite(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(String id) {
    throw UnimplementedError();
  }
}
