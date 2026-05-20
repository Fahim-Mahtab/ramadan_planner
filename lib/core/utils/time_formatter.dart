import 'package:intl/intl.dart';

class TimeFormatter {
  /// Converts a 24-hour time string "HH:MM" (e.g. "15:45")
  /// into a 12-hour format "hh:mm a" (e.g. "03:45 PM").
  static String to12Hour(String time24) {
    if (time24.isEmpty) return "";

    // Aladhan API sometimes returns time with timezone like "18:45 (BST)"
    // We want to clip off the timezone string if it exists to safely parse.
    final rawTime = time24.split(' ').first; // Take only the '18:45' part

    try {
      final dateTime = DateFormat("HH:mm").parse(rawTime);
      return DateFormat("hh:mm a").format(dateTime); // 06:45 PM
    } catch (e) {
      // Return original string if parsing fails
      return time24;
    }
  }

  /// Parses a 24-hour time string "HH:MM" and returns a DateTime for today.
  static DateTime? parseToDateTime(String time24, {bool isNextDay = false}) {
    if (time24.isEmpty) return null;
    final rawTime = time24.split(' ').first;
    try {
      final parts = rawTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      var target = DateTime(now.year, now.month, now.day, hour, minute);
      if (isNextDay) target = target.add(const Duration(days: 1));
      return target;
    } catch (e) {
      return null;
    }
  }

  /// Converts English digits to Bengali digits.
  static String toBengaliDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String result = input;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], bengali[i]);
    }
    return result;
  }
}
