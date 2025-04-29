const express = require('express');
const router = express.Router();
const Product = require('../models/productModel');

// Get all products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });
    res.status(200).json(products);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get single product
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });
    res.json(product);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Create new product
router.post('/', async (req, res) => {
  try {
    const product = new Product(req.body);
    await product.save();
    res.status(201).json(product);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Update product
router.put('/:id', async (req, res) => {
  try {
    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedProduct) return res.status(404).json({ message: 'Product not found' });
    res.json(updatedProduct);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Delete product
router.delete('/:id', async (req, res) => {
  try {
    const deletedProduct = await Product.findByIdAndDelete(req.params.id);
    if (!deletedProduct) return res.status(404).json({ message: 'Product not found' });
    res.json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Seed sample products (development only)
router.post('/seed', async (req, res) => {
  if (process.env.NODE_ENV === 'production') {
    return res.status(403).json({ message: 'Not allowed in production' });
  }

  try {
    await Product.deleteMany();
    const sampleProducts = [
      {
        name: 'Premium Laptop',
        price: 1299.99,
        image: 'https://example.com/laptop.jpg',
        description: '16GB RAM, 1TB SSD, Intel i7 Processor'
      },
      {
        name: 'Wireless Headphones',
        price: 249.99,
        image: 'https://example.com/headphones.jpg',
        description: 'Noise cancelling with 30hr battery life'
      }
    ];
    const createdProducts = await Product.insertMany(sampleProducts);
    res.json(createdProducts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
