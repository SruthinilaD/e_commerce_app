import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartProvider>(context).cartItems;
    final teal = Colors.teal;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), backgroundColor: teal),
      body:
          cartItems.isEmpty
              ? Center(
                child: Text(
                  'No items in the cart',
                  style: TextStyle(fontSize: 18, color: teal.shade800),
                ),
              )
              : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: teal.shade900,
                        ),
                      ),
                      subtitle: Text(
                        '\$${product.price}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_shopping_cart, color: teal),
                        onPressed: () {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).removeFromCart(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} removed from cart',
                              ),
                              backgroundColor: teal,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
