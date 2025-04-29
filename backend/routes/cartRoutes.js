const express = require('express');
const router = express.Router();
const CartItem = require('../models/cartModel');

// Get all cart items with product details
router.get('/', async (req, res) => {
  try {
    const cartItems = await CartItem.find().populate('productId');
    res.json(cartItems);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Add item to cart
router.post('/', async (req, res) => {
  try {
    const { productId, quantity = 1 } = req.body;
    
    // Check if item already exists in cart
    const existingItem = await CartItem.findOne({ productId });
    
    if (existingItem) {
      existingItem.quantity += quantity;
      await existingItem.save();
      return res.json(existingItem);
    }

    const newItem = new CartItem({ productId, quantity });
    await newItem.save();
    res.status(201).json(await newItem.populate('productId'));
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Update cart item quantity
router.put('/:id', async (req, res) => {
  try {
    const { quantity } = req.body;
    const updatedItem = await CartItem.findByIdAndUpdate(
      req.params.id,
      { quantity },
      { new: true }
    ).populate('productId');
    
    if (!updatedItem) {
      return res.status(404).json({ message: 'Item not found' });
    }
    
    res.json(updatedItem);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Remove item from cart
router.delete('/:id', async (req, res) => {
  try {
    const deletedItem = await CartItem.findByIdAndDelete(req.params.id);
    
    if (!deletedItem) {
      return res.status(404).json({ message: 'Item not found' });
    }
    
    res.json({ message: 'Item removed successfully' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;