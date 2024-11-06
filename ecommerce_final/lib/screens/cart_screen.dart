import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'checkout_screen.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ProductProvider>(context).cart;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Cart'),
          actions: [
          if (cart.isNotEmpty)
        IconButton(
        icon: Icon(Icons.receipt_long),
    tooltip: 'Proceed to Checkout',
    onPressed: () {
    // Navigate to CheckoutScreen with all cart items
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CheckoutScreen(cartItems: cart.values.toList()),
    ));
    },
    ),
    ],
    ),


      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: List.generate(cart.length, (i) {
              final cartItem = cart.values.elementAt(i);
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    // Navigate to CheckoutScreen and pass only this cart item's details
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          cartItems: [cartItem], // Wrap single item in a list
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section
                        Container(
                          height: screenWidth < 600 ? 150 : 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(cartItem.imageUrl),
                              fit: BoxFit.cover,
                            ),
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
                        SizedBox(height: 8),
                        // Remove Button
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
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
