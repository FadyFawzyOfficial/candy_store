import 'package:candy_store/product/data/service/api_service.dart';
import 'package:candy_store/product/domain/model/product.dart';
import 'package:candy_store/product/domain/repository/product_repository.dart';

class NetworkProductRepository implements ProductRepository {
  final ApiService _apiService;

  NetworkProductRepository(this._apiService);

  @override
  Future<List<Product>> fetchProduct() => _apiService.fetchProducts();

  @override
  Future<Product> fetchProductById(int id) {
    // TODO: implement fetchProductById
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }
}
