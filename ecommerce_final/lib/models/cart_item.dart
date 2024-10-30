class CartItem {
  final String productId;
  final String name; // Assuming you want to keep this
  final String imageUrl; // Make sure this is present
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.name, // Update this line if you change the name property
    required this.imageUrl, // Ensure this is present
    required this.price,
    this.quantity = 1,
  });
}
