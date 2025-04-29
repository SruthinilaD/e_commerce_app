import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../config.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/products'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        _products = jsonData.map((item) => Product.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // You may show a Snackbar or use a loading fallback UI in your screen
      _products = []; // Prevent infinite loading
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'image': product.image,
        'price': product.price,
      }),
    );

    if (response.statusCode == 201) {
      final newProduct = Product.fromJson(json.decode(response.body));
      _products.add(newProduct);
      notifyListeners();
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/products/${updatedProduct.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': updatedProduct.name,
        'description': updatedProduct.description,
        'image': updatedProduct.image,
        'price': updatedProduct.price,
      }),
    );

    if (response.statusCode == 200) {
      final index = _products.indexWhere(
        (product) => product.id == updatedProduct.id,
      );
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/products/$id'));

    if (response.statusCode == 200) {
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
