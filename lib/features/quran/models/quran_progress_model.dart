/// Model representing Quran reading progress
class QuranProgressModel {
  int currentJuz;
  int currentPage;
  final int targetJuz;

  QuranProgressModel({
    required this.currentJuz,
    required this.currentPage,
    this.targetJuz = 30,
  });

  /// Calculate percentage based on pages read
  /// Total Quran pages = 604
  double get percentage {
    const totalPages = 604;
    return (currentPage / totalPages * 100).clamp(0, 100);
  }

  QuranProgressModel copyWith({
    int? currentJuz,
    int? currentPage,
    int? targetJuz,
  }) {
    return QuranProgressModel(
      currentJuz: currentJuz ?? this.currentJuz,
      currentPage: currentPage ?? this.currentPage,
      targetJuz: targetJuz ?? this.targetJuz,
    );
  }
}
