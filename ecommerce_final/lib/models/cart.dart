class CartItem {
  final String productId;
  final String title;
  final String imageUrl; // Add this line
  final double price;
  int quantity; // Quantity can change, so it should not be final

  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl, // Add this line
    required this.price,
    this.quantity = 1, // Default quantity is 1
  });
}
