import 'package:flutter/services.dart';

import '../../../product/domain/repository/products_data.dart';
import '../../../product/domain/model/product_list_item.dart';
import '../../domain/repository/favorite_repository.dart';

class LocalFavoriteRepository extends FavoriteRepository {
  static const _platform = MethodChannel('com.example.candy_store/favorite');

  @override
  Future<void> addFavorite(ProductListItem item) async {
    //! 1. As the first parameter to the invokeMethod method of MethodChannel,
    //! we pass addFavorite, as string that represents the name of the method
    //! to be called on the native side.
    //* 2. To pass parameters, we create a map and add an item.id single value for the 'id' key.
    _platform.invokeMethod('addFavorite', {'id': item.id});
  }

  @override
  Future<List<ProductListItem>> getFavorites() async {
    final favorites =
        await _platform.invokeListMethod<String>('getFavorites') ?? [];
    return productItems.where((item) => favorites.contains(item.id)).toList();
  }

  @override
  Future<bool> isFavorite(String id) async {
    final isFavorite =
        await _platform.invokeMethod<bool>('isFavorite', {'id': id});
    return isFavorite ?? false;
  }

  @override
  Future<void> removeFavorite(String id) async {
    _platform.invokeMethod('removeFavorite', {'id': id});
  }
}
