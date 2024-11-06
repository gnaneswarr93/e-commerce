import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
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

    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate number of columns based on screen size
    int crossAxisCount = 2; // Default for mobile
    if (screenWidth >= 600 && screenWidth < 900) {
      crossAxisCount = 2; // Tablet size
    } else if (screenWidth >= 900) {
      crossAxisCount = 3; // Desktop size
    }

    // Calculate childAspectRatio based on screen width
    double childAspectRatio = (screenWidth < 600)
        ? 0.75 // Mobile
        : (screenWidth < 900)
        ? 0.85 // Tablet
        :(screenWidth<500)
        ?0.6a
        : 1.2; // Desktop

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
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
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
            // Use Flexible to manage available space and make the layout adaptive
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text('No products found.', style: TextStyle(fontSize: 18)))
                  : GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: products[i]),
                      ));
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Adjust image height for different screen sizes
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              height: (screenWidth < 600) ? 80 : (screenWidth < 900) ? 200 : 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(products[i].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  products[i].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth < 600 ? 14 : screenWidth < 900 ? 16 : 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                // Price
                                Text(
                                  '\$${products[i].price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: screenWidth < 600 ? 12 : screenWidth < 900 ? 14 : 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Button
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      productProvider.addToCart(products[i]);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${products[i].title} added to cart!')),
                                      );
                                    },
                                    child: Text('Add to Cart', style: TextStyle(fontSize: 14)),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
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
