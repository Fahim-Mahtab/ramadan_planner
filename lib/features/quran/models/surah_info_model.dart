class SurahInfoModel {
  final int surahNo;
  final String surahName;
  final String surahNameArabic;
  final String surahNameTranslation;
  final String revelationPlace;
  final int totalAyah;

  SurahInfoModel({
    required this.surahNo,
    required this.surahName,
    required this.surahNameArabic,
    required this.surahNameTranslation,
    required this.revelationPlace,
    required this.totalAyah,
  });

  factory SurahInfoModel.fromJson(
    Map<String, dynamic> json,
    int defaultSurahNo,
  ) {
    return SurahInfoModel(
      surahNo: json['surahNo'] ?? defaultSurahNo,
      surahName: json['surahName'] ?? '',
      surahNameArabic: json['surahNameArabic'] ?? '',
      surahNameTranslation: json['surahNameTranslation'] ?? '',
      revelationPlace: json['revelationPlace'] ?? '',
      totalAyah: json['totalAyah'] ?? 0,
    );
  }
}
