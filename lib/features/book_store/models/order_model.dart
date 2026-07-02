class OrderModel {
  final String name;
  final String phone;
  final String? address;
  final String bookTitle;
  final int quantity;
  final double totalPrice;
  final String orderType;

  const OrderModel({
    required this.name,
    required this.phone,
    this.address,
    required this.bookTitle,
    required this.quantity,
    required this.totalPrice,
    required this.orderType,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'address': address,
        'book_title': bookTitle,
        'quantity': quantity,
        'total_price': totalPrice,
        'order_type': orderType,
      };
}
