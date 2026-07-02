class ReadingPlan {
  final int dailyTargetPages;
  final int monthlyTargetJuz;

  const ReadingPlan({
    this.dailyTargetPages = 5,
    this.monthlyTargetJuz = 1,
  });

  ReadingPlan copyWith({int? dailyTargetPages, int? monthlyTargetJuz}) {
    return ReadingPlan(
      dailyTargetPages: dailyTargetPages ?? this.dailyTargetPages,
      monthlyTargetJuz: monthlyTargetJuz ?? this.monthlyTargetJuz,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyTargetPages': dailyTargetPages,
        'monthlyTargetJuz': monthlyTargetJuz,
      };

  factory ReadingPlan.fromJson(Map<String, dynamic> json) => ReadingPlan(
        dailyTargetPages: json['dailyTargetPages'] as int? ?? 5,
        monthlyTargetJuz: json['monthlyTargetJuz'] as int? ?? 1,
      );
}

class DailyReading {
  final DateTime date;
  final String dateKey;
  final int pagesRead;
  final int targetPages;
  final bool completed;

  const DailyReading({
    required this.date,
    required this.dateKey,
    required this.pagesRead,
    required this.targetPages,
    required this.completed,
  });

  DailyReading copyWith({int? pagesRead, bool? completed}) {
    return DailyReading(
      date: date,
      dateKey: dateKey,
      pagesRead: pagesRead ?? this.pagesRead,
      targetPages: targetPages,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'pagesRead': pagesRead,
        'targetPages': targetPages,
        'completed': completed,
      };
}
