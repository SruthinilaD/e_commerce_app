import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../config.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String image;
  late double price;

  @override
  void initState() {
    super.initState();
    name = widget.product.name;
    description = widget.product.description;
    image = widget.product.image;
    price = widget.product.price;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    _formKey.currentState?.save();

    final url = Uri.parse('$baseUrl/api/products/${widget.product.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'image': image,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
        Navigator.pop(context, true); // Indicate success
      } else {
        print('Failed to update product: ${response.body}');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final teal = Colors.teal;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Product"), backgroundColor: teal),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Update Product Info",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: teal[800],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: teal[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: teal),
                  ),
                ),
                onSaved: (value) => name = value!,
                validator:
                    (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: teal[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: teal),
                  ),
                ),
                onSaved: (value) => description = value!,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: image,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: TextStyle(color: teal[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: teal),
                  ),
                ),
                onSaved: (value) => image = value!,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter an image URL' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(color: teal[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: teal),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.parse(value!),
                validator:
                    (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.save),
                label: Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
