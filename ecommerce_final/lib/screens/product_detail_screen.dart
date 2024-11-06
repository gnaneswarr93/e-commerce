import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final relatedProducts = Provider.of<ProductProvider>(context)
        .products
        .where((p) => p.id != product.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 500,
                height: 300,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${product.price}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ProductProvider>(context, listen: false).addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} added to cart!')),
                  );
                },
                child: Text('Buy Now'),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Related Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...relatedProducts.map((p) => ListTile(
              leading: Image.network(p.imageUrl, width: 50),
              title: Text(p.title),
              subtitle: Text('\$${p.price}'),
              onTap: () {
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
