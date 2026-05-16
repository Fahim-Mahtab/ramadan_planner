class CommunityQAModel {
  final String id;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;
  final String title;
  final String question;
  final String? answer;
  final bool isAnswered;
  final String? answeredBy;
  final String? answeredByName;
  final DateTime? answeredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommunityQAModel({
    required this.id,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    required this.title,
    required this.question,
    this.answer,
    required this.isAnswered,
    this.answeredBy,
    this.answeredByName,
    this.answeredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityQAModel.fromMap(Map<String, dynamic> map) {
    // Handling joins for user and admin profiles
    final userProfile = map['user_profile'] as Map<String, dynamic>?;
    final adminProfile = map['admin_profile'] as Map<String, dynamic>?;

    return CommunityQAModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      userName: userProfile?['full_name']?.toString(),
      userPhotoUrl: userProfile?['photo_url']?.toString(),
      title: map['title']?.toString() ?? '',
      question: map['question']?.toString() ?? '',
      answer: map['answer']?.toString(),
      isAnswered: map['is_answered'] == true,
      answeredBy: map['answered_by']?.toString(),
      answeredByName: adminProfile?['full_name']?.toString(),
      answeredAt: map['answered_at'] != null
          ? DateTime.tryParse(map['answered_at'].toString())
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'question': question,
      'answer': answer,
      'is_answered': isAnswered,
      'answered_by': answeredBy,
      'answered_at': answeredAt?.toIso8601String(),
    };
  }
}
