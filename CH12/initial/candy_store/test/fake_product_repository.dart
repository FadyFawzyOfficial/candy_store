import 'package:candy_store/product/domain/model/product.dart';
import 'package:candy_store/product/domain/repository/product_repository.dart';

import 'test_data.dart';

class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> fetchProduct() async => TestData.testProducts;

  @override
  Future<List<Product>> searchProducts(String query) async {
    return TestData.testProducts
        // .where( (product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .where((product) => product.name.contains(query))
        .toList();
  }

  @override
  Future<Product> fetchProductById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(Product product) {
    throw UnimplementedError();
  }
}
