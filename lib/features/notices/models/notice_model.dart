/// Represents a single notice from the Supabase `notices` table.
class NoticeModel {
  final String id;
  final String title;
  final String? message;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;

  const NoticeModel({
    required this.id,
    required this.title,
    this.message,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
  });

  /// Constructs a [NoticeModel] from a Supabase row map.
  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      message: map['message'] as String?,
      imageUrl: map['image_url'] as String?,
      isActive: map['is_active'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Converts this [NoticeModel] to a map for Supabase insertion/updates.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}
