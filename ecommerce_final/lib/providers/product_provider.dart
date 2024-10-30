import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  final Map<String, CartItem> _cart = {};

  List<Product> get products => _products;
  Map<String, CartItem> get cart => _cart;

  Future<void> loadProducts() async {
    try {
      // Load the CSV file from assets
      final data = await rootBundle.loadString('assets/products.csv');

      // Convert CSV data into a List<List<dynamic>>
      List<List<dynamic>> csvData = CsvToListConverter().convert(data);

      // Assuming the first row is the header and data starts from row 1
      _products = csvData.skip(1).map((product) {
        // Parse price by removing commas, then converting to double
        double price = double.tryParse(
            product[1].toString().replaceAll(',', '')) ?? 0.0;

        return Product(
          id: product[0].toString(), // Using name as ID here
          title: product[0].toString(), // Product title from name column
          description: '', // Default empty description
          price: price, // Parsed price
          imageUrl: product[2].toString(), // imageUrl from CSV
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading CSV data: $error');
    }
  }

  void addToCart(Product product) {
    if (cart.containsKey(product.id)) {
      cart.update(
        product.id,
            (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          name: existingCartItem.name, // Ensure this matches your CartItem model
          imageUrl: existingCartItem.imageUrl,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      cart.putIfAbsent(
        product.id,
            () => CartItem(
          productId: product.id,
          name: product.title, // Match the product title to name
          imageUrl: product.imageUrl, // Add the imageUrl here
          price: product.price,
          quantity: 1,
        ),
      );
    }
  }

  void removeFromCart(String productId) {
    if (_cart.containsKey(productId)) {
      if (_cart[productId]!.quantity > 1) {
        _cart[productId]!.quantity -= 1;
      } else {
        _cart.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  int get cartItemCount {
    return _cart.values.fold(0, (sum, item) => sum + item.quantity);
  }
}
