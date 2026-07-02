class TasbihRecord {
  final String dhikrId;
  final int count;
  final int target;

  const TasbihRecord({
    required this.dhikrId,
    required this.count,
    required this.target,
  });

  double get progress => count / target;
  bool get isComplete => count >= target;

  TasbihRecord copyWith({int? count}) {
    return TasbihRecord(
      dhikrId: dhikrId,
      count: count ?? this.count,
      target: target,
    );
  }

  Map<String, dynamic> toJson() => {
        'dhikrId': dhikrId,
        'count': count,
        'target': target,
      };

  factory TasbihRecord.fromJson(Map<String, dynamic> json) => TasbihRecord(
        dhikrId: json['dhikrId'] as String,
        count: json['count'] as int,
        target: json['target'] as int,
      );
}
