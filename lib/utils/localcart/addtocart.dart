import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/product.dart';

class CartService {
  Future<List<Product>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJsonList = prefs.getStringList('cart') ?? [];

    return cartJsonList
        .map((item) => Product.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart') ?? [];
    cart.add(jsonEncode(product.toJson()));
    await prefs.setStringList('cart', cart);
    await updateCartCount();
  }

  Future<void> removeFromCart({required int productid}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cart = prefs.getStringList('cart') ?? [];

      final updatedCart = cart.where((item) {
        final itemMap = jsonDecode(item);
        final itemId = itemMap['id'];
        return itemId != productid;
      }).toList();

      await prefs.setStringList('cart', updatedCart);
      await updateCartCount();
      debugPrint("Product removed successfully.");
    } catch (e) {
      debugPrint("Error removing product from cart: $e");
    }
  }

  Future<bool> isProductInCart(Product product) async {
    final cartItems = await getCartItems();
    return cartItems.any((item) => item.id == product.id);
  }

  Future<void> updateCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart') ?? [];
    final cartCount = cart.length;
    await prefs.setInt('cartCount', cartCount);
  }

  Future<int> getCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cartCount') ?? 0;
  }
}
