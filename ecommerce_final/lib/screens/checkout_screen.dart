import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  CheckoutScreen({required this.cartItems});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Payment mode options
  String _selectedPaymentMode = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checkout Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              // Product details section
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    leading: Image.network(item.imageUrl, width: 50),
                    title: Text(item.name),
                    subtitle: Text('Price: \$${item.price} x ${item.quantity}'),
                  );
                },
              ),
              Divider(),
              Text('Total: \$${calculateTotal(widget.cartItems)}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),

              // Customer details form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Payment mode dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMode,
                      decoration: InputDecoration(labelText: 'Payment Mode'),
                      items: ['Credit Card', 'Debit Card', 'Cash on Delivery', 'UPI']
                          .map((String mode) {
                        return DropdownMenuItem<String>(
                          value: mode,
                          child: Text(mode),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPaymentMode = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Confirm order button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Handle form submission and order confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Order confirmed!')),
                          );
                          // Clear cart or navigate as needed
                        }
                      },
                      child: Text('Confirm Order'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Calculate total for all cart items
  double calculateTotal(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
