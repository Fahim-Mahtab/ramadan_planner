enum FastType { voluntary, makeup, whiteDays, mondayThursday, dawud }

enum FastStatus { kept, missed, makeup }

class FastingRecord {
  final DateTime date;
  final FastType type;
  final FastStatus status;

  const FastingRecord({
    required this.date,
    required this.type,
    required this.status,
  });

  String get dateKey =>
      '${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}';

  FastingRecord copyWith({FastStatus? status, FastType? type}) {
    return FastingRecord(
      date: date,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': dateKey,
        'type': type.name,
        'status': status.name,
      };

  factory FastingRecord.fromJson(Map<String, dynamic> json) {
    final parts = (json['date'] as String).split('_');
    return FastingRecord(
      date: DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])),
      type: FastType.values.byName(json['type'] as String),
      status: FastStatus.values.byName(json['status'] as String),
    );
  }
}
