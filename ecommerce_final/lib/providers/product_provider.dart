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
    final data = await rootBundle.loadString('assets/products.csv');
    List<List<dynamic>> csvData = CsvToListConverter().convert(data);

    // Assuming the first row is the header
    _products = csvData.skip(1).map((product) {
      return Product(
        id: product[0].toString(), // Ensure it's a string
        title: product[1].toString(),
        description: product[2].toString(),
        price: double.parse(product[3].toString()), // Parse price to double
        imageUrl: product[4].toString(), // Assuming there's an imageUrl as the 5th column
      );
    }).toList();

    notifyListeners();
  }

  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) { // Change from name to id
      _cart[product.id]!.quantity += 1;
    } else {
      _cart[product.id] = CartItem(
        productId: product.id,
        name: product.title, // Use title for the name
        price: product.price,
      );
    }
    notifyListeners();
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
