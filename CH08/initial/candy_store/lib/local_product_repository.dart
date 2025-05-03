import 'package:hive/hive.dart';

import 'product/domain/model/product.dart';
import 'product/domain/repository/product_repository.dart';

class LocalProductRepository implements ProductRepository {
  final Box<Product> _productBox;

  LocalProductRepository(this._productBox);

  @override
  Future<List<Product>> fetchProduct() async => _productBox.values.toList();

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

  Future<void> cacheProducts(List<Product> products) async =>
      await _productBox.addAll(products);

  Future<void> clearProducts() async => await _productBox.clear();
}
