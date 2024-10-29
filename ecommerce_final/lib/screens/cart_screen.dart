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
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (ctx, i) {
          final cartItem = cart.values.elementAt(i);
          return ListTile(
            title: Text(cartItem.name), // Updated to 'name'
            subtitle: Text('Price: \$${cartItem.price} x ${cartItem.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
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
          );
        },
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
