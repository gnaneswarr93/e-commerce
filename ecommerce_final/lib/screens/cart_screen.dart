import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ProductProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Three items per row
            childAspectRatio: 1.2, // Adjust aspect ratio for card size
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: cart.length,
          itemBuilder: (ctx, i) {
            final cartItem = cart.values.elementAt(i);
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding for the card content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section
                    Container(
                      height: 200, // Height for the image
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(cartItem.imageUrl), // Ensure you have this field in your cart item
                          fit: BoxFit.contain, // Fit the image
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Title
                    Text(
                      cartItem.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    // Price and Quantity
                    Text('Price: \$${cartItem.price} x ${cartItem.quantity}'),
                    Spacer(), // Pushes the buttons to the bottom
                    // Remove and Delete Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            Provider.of<ProductProvider>(context, listen: false)
                                .removeFromCart(cartItem.productId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<ProductProvider>(context, listen: false)
                                .removeFromCart(cartItem.productId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ProductProvider>(context, listen: false).clearCart();
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}
