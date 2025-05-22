import '../../../product/domain/model/product_list_item.dart';
import '../../../product/domain/repository/products_data.dart';
import '../../domain/repository/favorite_repository.dart';
import '../api/local_storage_api.g.dart';

class LocalFavoriteRepository extends FavoriteRepository {
  final LocalStorageApi _localStorageApi;

  const LocalFavoriteRepository({required LocalStorageApi localStorageApi})
      : _localStorageApi = localStorageApi;

  @override
  Future<void> addFavorite(ProductListItem item) async =>
      _localStorageApi.addFavorite(item.id);

  @override
  Future<List<ProductListItem>> getFavorites() async {
    final favorites =
        (await _localStorageApi.getFavorites()).map((item) => item.id).toList();
    return productItems.where((item) => favorites.contains(item.id)).toList();
  }

  @override
  Future<bool> isFavorite(String id) async => _localStorageApi.isFavorite(id);

  @override
  Future<void> removeFavorite(String id) async =>
      _localStorageApi.removeFavorite(id);
}
