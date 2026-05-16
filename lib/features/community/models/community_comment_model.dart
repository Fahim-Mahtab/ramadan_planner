class CommunityCommentModel {
  final String id;
  final String eventRequestId;
  final String userId;
  final String comment;
  final String? authorName;
  final String? authorPhoto;
  final DateTime? createdAt;

  const CommunityCommentModel({
    required this.id,
    required this.eventRequestId,
    required this.userId,
    required this.comment,
    required this.authorName,
    required this.authorPhoto,
    required this.createdAt,
  });

  factory CommunityCommentModel.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'];
    return CommunityCommentModel(
      id: (map['id'] ?? '').toString(),
      eventRequestId: (map['event_request_id'] ?? '').toString(),
      userId: (map['user_id'] ?? '').toString(),
      comment: (map['comment'] ?? '').toString(),
      authorName:
          profile is Map<String, dynamic> ? profile['full_name']?.toString() : null,
      authorPhoto:
          profile is Map<String, dynamic> ? profile['avatar_url']?.toString() : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}
