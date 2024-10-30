import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    // Fetch related products (excluding the current product)
    final relatedProducts = Provider.of<ProductProvider>(context)
        .products
        .where((p) => p.id != product.id) // Use 'id' for comparison
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(product.title)), // Change to product.title
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
          children: [
            // Centering the image using Center widget
            Center(
              child: Container(
                width: 300, // Set your desired width here
                height: 300, // Set your desired height here
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover, // Control how the image fits within the container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('\$${product.price}', style: TextStyle(fontSize: 20, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement 'Buy Now' functionality here
                  Provider.of<ProductProvider>(context, listen: false).addToCart(product);
                },
                child: Text('Buy Now'),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Related Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ...relatedProducts.map((p) => ListTile(
              leading: Image.network(p.imageUrl, width: 50),
              title: Text(p.title), // Change to p.title
              subtitle: Text('\$${p.price}'),
              onTap: () {
                // Navigate to the selected product's detail screen
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: p),
                ));
              },
            )),
          ],
        ),
      ),
    );
  }
}
