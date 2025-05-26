import '../../../product/domain/model/product_list_item.dart';

abstract class FavoriteRepository {
  const FavoriteRepository();
  Future<List<ProductListItem>> getFavorites();
  Future<void> addFavorite(ProductListItem item);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
}
