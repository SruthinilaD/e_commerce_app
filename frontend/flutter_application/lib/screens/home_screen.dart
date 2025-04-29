// ... other imports
import 'package:flutter/material.dart';
import 'package:flutter_application/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  Future<void> _refreshProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProductScreen()),
          );

          if (result == true) {
            _refreshProducts();
          }
        },
        child: const Icon(Icons.add),
      ),
      body:
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.63,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (ctx, i) {
                    final product = products[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.image,
                                  height: 98,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "\$${product.price}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(height: 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditProductScreen(
                                                product: product,
                                              ),
                                        ),
                                      );
                                      if (result == true) {
                                        _refreshProducts();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Provider.of<ProductProvider>(
                                        context,
                                        listen: false,
                                      ).deleteProduct(product.id);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 1),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).addToCart(product);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.teal,
                                      content: Text(
                                        '${product.name} added to cart',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  minimumSize: const Size(double.infinity, 35),
                                ),
                                child: const Text("Add to Cart"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
