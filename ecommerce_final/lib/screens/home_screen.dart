import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart'; // Import the ProductDetailScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load products once when the HomeScreen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products
        .where((product) => product.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-commerce Website',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0), // Use only 80% of the width
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Products',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text('No products found.', style: TextStyle(fontSize: 18)))
                  : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three items per row
                  childAspectRatio: 0.8, // Further adjusted for compactness
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10, // Spacing between cards
                ),
                itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to ProductDetailScreen when the card is clicked
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: products[i]),
                      ));
                    },
                    child: Card(
                      elevation: 4, // Gives a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image section with padding around it
                          Padding(
                            padding: const EdgeInsets.all(8.0), // Padding around image for spacing
                            child: Container(
                              height: 400, // Reduced image height for compactness
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), // Round image corners
                                image: DecorationImage(
                                  image: NetworkImage(products[i].imageUrl),
                                  fit: BoxFit.contain, // Ensure the image fits properly
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  products[i].title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis, // Prevent overflow
                                ),
                                SizedBox(height: 2),
                                // Price
                                Text(
                                  '\$${products[i].price.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                SizedBox(height: 6), // Spacing before button
                                // Button
                                Align(
                                  alignment: Alignment.center, // Center the button
                                  child: ElevatedButton(
                                    onPressed: () {
                                      productProvider.addToCart(products[i]);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${products[i].title} added to cart!')),
                                      );
                                    },
                                    child: Text('Add to Cart', style: TextStyle(fontSize: 12)),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4), // Further reduced padding
                                      backgroundColor: Colors.blueAccent, // Button color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30), // Rounded button
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Cart',
      ),
    );
  }
}
