import '../l10n/app_locale.dart';

/// App-wide constants
class AppConstants {
  // Prayer Names
  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
    'Taraweeh',
  ];

  // Quran Constants
  static const int totalJuz = 30;
  static const int totalPages = 604;

  // App Strings
  static String get appName => AppLocale.format(AppLocale.adAppName);
  static String get dailySalah => AppLocale.format(AppLocale.salahTitle);
  static String get quranProgress => AppLocale.format(AppLocale.quranProgressTitle);
  static String get sunnahChecklist => AppLocale.format(AppLocale.checklistTitle);
  static String get ayahOfTheDay => AppLocale.format(AppLocale.ayahTitle);
  static String get duaOfTheDay => AppLocale.format(AppLocale.duaOfTheDay);
  static String get asmaulHusna => AppLocale.format(AppLocale.asmaulHusnaTitle);

  // Navigation Labels
  static String get navHome => AppLocale.format(AppLocale.navHome);
  static String get navQuran => AppLocale.format(AppLocale.navQuran);
  static String get navTimes => AppLocale.format(AppLocale.navTimes);
  static String get navDua => AppLocale.format(AppLocale.navDua);
  static String get navSettings => AppLocale.format(AppLocale.navSettings);
}
