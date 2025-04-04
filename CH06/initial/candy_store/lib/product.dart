import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;

  /// Stock Keeping Unit
  final String sku;
  final int stock;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sku,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      sku: json['sku'],
      stock: json['stock'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
  List<Object?> get props =>
      [id, sku, stock, name, description, price, imageUrl];
}
