import 'dart:convert';

import 'package:http/http.dart';

import 'product.dart';

class ApiService {
  final String _baseUrl = 'https://api.example.com/candystore';

  Future<List<Product>> fetchProducts() async {
    final response = await get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      return productData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load candies');
    }
  }
}
