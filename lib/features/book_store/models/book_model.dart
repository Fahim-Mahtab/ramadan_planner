class BookModel {
  final String title;
  final String author;
  final double price;
  final String? description;
  final String? imageUrl;

  const BookModel({
    required this.title,
    required this.author,
    required this.price,
    this.description,
    this.imageUrl,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) => BookModel(
        title: map['title'] as String,
        author: map['author'] as String,
        price: (map['price'] as num).toDouble(),
        description: map['description'] as String?,
        imageUrl: map['imageUrl'] as String?,
      );
}
