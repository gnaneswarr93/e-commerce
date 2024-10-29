class CartItem {
  final String productId;
  final String title;
  final double price;
  int quantity; // Quantity can change, so it should not be final

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    this.quantity = 1, // Default quantity is 1
  });
}
