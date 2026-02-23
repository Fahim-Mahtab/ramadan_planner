/// Represents a single advertisement from the Supabase `ads` table.
class AdModel {
  final String id;
  final String title;
  final String imageUrl;
  final String redirectUrl;
  final bool isActive;
  final DateTime createdAt;

  const AdModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.redirectUrl,
    required this.isActive,
    required this.createdAt,
  });

  /// Constructs an [AdModel] from a Supabase row map.
  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      redirectUrl: map['redirect_url'] as String? ?? '',
      isActive: map['is_active'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
