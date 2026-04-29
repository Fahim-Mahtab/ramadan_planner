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
}
