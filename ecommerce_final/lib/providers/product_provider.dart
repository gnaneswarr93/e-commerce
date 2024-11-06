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
      final data = await rootBundle.loadString('assets/products.csv');
      List<List<dynamic>> csvData = CsvToListConverter().convert(data);
      _products = csvData.skip(1).map((product) {
        double price = double.tryParse(
            product[1].toString().replaceAll(',', '')) ?? 0.0;

        return Product(
          id: product[0].toString(),
          title: product[0].toString(),
          description: '',
          price: price,
          imageUrl: product[2].toString(),
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading CSV data: $error');
    }
  }

  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) {
      _cart.update(
        product.id,
            (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          name: existingCartItem.name,
          imageUrl: existingCartItem.imageUrl,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _cart.putIfAbsent(
        product.id,
            () => CartItem(
          productId: product.id,
          name: product.title,
          imageUrl: product.imageUrl,
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
