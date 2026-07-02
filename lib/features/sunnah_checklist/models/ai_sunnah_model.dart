class AISunnahAct {
  final String id;
  final String titleEn;
  final String titleBn;
  final String evidenceEn;
  final String evidenceBn;
  bool isCompleted;

  AISunnahAct({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.evidenceEn,
    required this.evidenceBn,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleBn': titleBn,
      'evidenceEn': evidenceEn,
      'evidenceBn': evidenceBn,
      'isCompleted': isCompleted,
    };
  }

  factory AISunnahAct.fromJson(Map<String, dynamic> json) {
    return AISunnahAct(
      id: json['id'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleBn: json['titleBn'] as String? ?? '',
      evidenceEn: json['evidenceEn'] as String? ?? '',
      evidenceBn: json['evidenceBn'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  void toggle() {
    isCompleted = !isCompleted;
  }
}
