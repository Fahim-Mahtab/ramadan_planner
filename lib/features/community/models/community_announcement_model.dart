class CommunityAnnouncementModel {
  final String id;
  final String title;
  final String? description;
  final String priority; // normal, important, urgent
  final DateTime? createdAt;

  const CommunityAnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
  });

  factory CommunityAnnouncementModel.fromMap(Map<String, dynamic> map) {
    return CommunityAnnouncementModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: map['description']?.toString(),
      priority: map['priority']?.toString() ?? 'normal',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}
