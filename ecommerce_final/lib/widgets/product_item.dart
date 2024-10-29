import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ));
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
          children: [
            Image.network(
              product.imageUrl,
              height: 150, // Adjusted height for better visibility
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title, // Changed from product.name to product.title
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${product.price}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ProductProvider>(context, listen: false).addToCart(product);
                },
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
