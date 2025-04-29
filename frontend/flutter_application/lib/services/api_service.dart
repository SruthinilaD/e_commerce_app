import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../config.dart';

class ApiService {
  // Fetch products from Node.js server
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Add to cart
  static Future<void> addToCart(String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'productId': productId, 'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to cart');
    }
  }

  // Add product
  static Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': product.name,
        'description': product.description,
        'image': product.image,
        'price': product.price,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }

  // Update product
  static Future<void> updateProduct(Product updatedProduct) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/products/${updatedProduct.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': updatedProduct.name,
        'description': updatedProduct.description,
        'image': updatedProduct.image,
        'price': updatedProduct.price,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }
}
