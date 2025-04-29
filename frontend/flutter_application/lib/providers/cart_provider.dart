import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  // The cart will hold a list of products
  List<Product> _cartItems = [];

  // Getter to retrieve cart items
  List<Product> get cartItems => _cartItems;

  // Add a product to the cart
  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners(); // Notify the UI to rebuild
  }

  // Optional: Remove a product from the cart
  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }
}
