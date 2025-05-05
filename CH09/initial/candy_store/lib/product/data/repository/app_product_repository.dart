import 'local_product_repository.dart';
import 'network_product_repository.dart';
import '../../domain/model/product.dart';
import '../../domain/repository/product_repository.dart';

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
}
