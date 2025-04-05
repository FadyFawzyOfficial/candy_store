import 'package:candy_store/product.dart';
import 'package:candy_store/product_repository.dart';
import 'package:hive/hive.dart';

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
}
