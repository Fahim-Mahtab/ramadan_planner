class QuranLectureModel {
  final int id;
  final String title;
  final String videoUrl;
  final String? description;
  final DateTime? date;
  final int sortOrder;
  final bool isActive;

  const QuranLectureModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.description,
    this.date,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory QuranLectureModel.fromMap(Map<String, dynamic> map) {
    return QuranLectureModel(
      id: map['id'] as int,
      title: map['title'] as String,
      videoUrl: map['video_url'] as String,
      description: map['description'] as String?,
      date: map['date'] != null ? DateTime.tryParse(map['date'] as String) : null,
      sortOrder: map['sort_order'] as int? ?? 0,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'video_url': videoUrl,
      'description': description,
      'date': date?.toIso8601String(),
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }

  QuranLectureModel copyWith({
    int? id,
    String? title,
    String? videoUrl,
    String? description,
    DateTime? date,
    int? sortOrder,
    bool? isActive,
  }) {
    return QuranLectureModel(
      id: id ?? this.id,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      date: date ?? this.date,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}
