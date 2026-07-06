class OrderModel {
  final String? userId;
  final String name;
  final String phone;
  final String? address;
  final String bookTitle;
  final int quantity;
  final double totalPrice;
  final String orderType;

  const OrderModel({
    this.userId,
    required this.name,
    required this.phone,
    this.address,
    required this.bookTitle,
    required this.quantity,
    required this.totalPrice,
    required this.orderType,
  });

  OrderModel copyWith({
    String? userId,
    String? name,
    String? phone,
    String? address,
    String? bookTitle,
    int? quantity,
    double? totalPrice,
    String? orderType,
  }) {
    return OrderModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bookTitle: bookTitle ?? this.bookTitle,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      orderType: orderType ?? this.orderType,
    );
  }

  Map<String, dynamic> toMap() => {
        if (userId != null) 'user_id': userId,
        'name': name,
        'phone': phone,
        'address': address,
        'book_title': bookTitle,
        'quantity': quantity,
        'total_price': totalPrice,
        'order_type': orderType,
      };
}
