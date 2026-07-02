class HadithModel {
  final String id;
  final int ramadanDay;
  final String arabicText;
  final String banglaTranslation;
  final String? englishTranslation;
  final String source;
  final bool isActive;
  final DateTime createdAt;

  HadithModel({
    required this.id,
    required this.ramadanDay,
    required this.arabicText,
    required this.banglaTranslation,
    this.englishTranslation,
    required this.source,
    required this.isActive,
    required this.createdAt,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as String,
      ramadanDay: json['ramadan_day'] as int,
      arabicText: json['arabic_text'] as String,
      banglaTranslation: json['bangla_translation'] as String,
      englishTranslation: json['english_translation'] as String?,
      source: json['source'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
