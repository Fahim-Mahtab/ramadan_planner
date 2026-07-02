import 'package:flutter/foundation.dart';
import '../data/islamic_events.dart';
import '../models/islamic_event.dart';

class IslamicCalendarProvider with ChangeNotifier {
  bool _isInitialized = false;
  int _currentHijriYear = 1447;
  int _currentHijriMonth = 1;
  int _currentHijriDay = 1;
  String _hijriDateStr = '';

  bool get isInitialized => _isInitialized;
  int get currentHijriYear => _currentHijriYear;
  int get currentHijriMonth => _currentHijriMonth;
  int get currentHijriDay => _currentHijriDay;
  String get hijriDateStr => _hijriDateStr;

  List<IslamicEvent> get eventsForCurrentMonth =>
      importantDates.where((e) => e.hijriMonth == _currentHijriMonth).toList();

  List<IslamicEvent> get eventsForToday =>
      importantDates.where((e) =>
          e.hijriDay == _currentHijriDay && e.hijriMonth == _currentHijriMonth).toList();

  List<IslamicEvent> getEventsForDay(int day, int month) =>
      importantDates.where((e) => e.hijriDay == day && e.hijriMonth == month).toList();

  List<IslamicEvent> getEventsForMonth(int month) =>
      importantDates.where((e) => e.hijriMonth == month).toList();

  void updateHijriDate(int day, int month, int year) {
    _currentHijriDay = day;
    _currentHijriMonth = month;
    _currentHijriYear = year;
    _hijriDateStr = '$day ${hijriMonths[month] ?? ""} $year';
    _isInitialized = true;
    notifyListeners();
  }

  static String getMonthName(int month) => hijriMonths[month] ?? '';
}
