import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get dayKey => DateFormat('yyyy_MM_dd').format(this);

  bool get isMonday => weekday == DateTime.monday;
  bool get isThursday => weekday == DateTime.thursday;
  bool get isFriday => weekday == DateTime.friday;
  bool get isWednesday => weekday == DateTime.wednesday;

  bool isWhiteDay(int day) => day >= 13 && day <= 15;

  bool get isMondayOrThursday => isMonday || isThursday;
}
