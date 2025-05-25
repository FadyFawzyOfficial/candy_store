import '../../../product/domain/model/product_list_item.dart';
import '../../domain/repository/favorite_repository.dart';

class InMemoryFavoriteRepository implements FavoriteRepository {
  final List<ProductListItem> _favorites = [];

  @override
  Future<void> addFavorite(ProductListItem item) async {
    _favorites.add(item);
  }

  @override
  Future<List<ProductListItem>> getFavorites() async {
    return _favorites;
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _favorites.any((favorite) => favorite.id == id);
  }

  @override
  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((favorite) => favorite.id == id);
  }
}
