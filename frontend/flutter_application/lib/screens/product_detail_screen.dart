import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'edit_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teal = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: product),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: teal.shade50,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              product.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: teal.shade900,
              ),
            ),

            const SizedBox(height: 10),

            // Price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // Description Title
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: teal[800],
              ),
            ),
            const SizedBox(height: 6),

            // Description Body
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'ADD TO CART',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).addToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: teal,
                      content: Text('${product.name} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
