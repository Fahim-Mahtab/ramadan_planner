class SurahDetailModel {
  final int surahNo;
  final String surahName;
  final String surahNameArabic;
  final String surahNameTranslation;
  final String revelationPlace;
  final int totalAyah;
  final List<String> arabic1;
  final List<String> bengali;

  SurahDetailModel({
    required this.surahNo,
    required this.surahName,
    required this.surahNameArabic,
    required this.surahNameTranslation,
    required this.revelationPlace,
    required this.totalAyah,
    required this.arabic1,
    required this.bengali,
  });

  factory SurahDetailModel.fromJson(
    Map<String, dynamic> json,
    int defaultSurahNo,
  ) {
    return SurahDetailModel(
      surahNo: json['surahNo'] ?? defaultSurahNo,
      surahName: json['surahName'] ?? '',
      surahNameArabic: json['surahNameArabic'] ?? '',
      surahNameTranslation: json['surahNameTranslation'] ?? '',
      revelationPlace: json['revelationPlace'] ?? '',
      totalAyah: json['totalAyah'] ?? 0,
      arabic1: List<String>.from(json['arabic1'] ?? []),
      bengali: List<String>.from(json['bengali'] ?? []),
    );
  }

  String getVerseAudioUrl(int ayahNo, {int reciterId = 1}) {
    // reciter 1 is Mishary Rashid Al Afasy
    return "https://the-quran-project.github.io/Quran-Audio/Data/$reciterId/${surahNo}_$ayahNo.mp3";
  }
}
