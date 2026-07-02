enum CharityCategory { general, masjid, poor, relatives, other }

class CharityRecord {
  final String id;
  final double amount;
  final CharityCategory category;
  final String note;
  final DateTime date;

  const CharityRecord({
    required this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  String get dateKey =>
      '${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category': category.name,
        'note': note,
        'date': date.toIso8601String(),
      };

  factory CharityRecord.fromJson(Map<String, dynamic> json) => CharityRecord(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        category: CharityCategory.values.byName(json['category'] as String),
        note: json['note'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
      );
}
