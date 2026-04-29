class PrayerTimesModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  final String gregorianDate; // e.g. "09 Mar 2026"
  final String hijriDate; // e.g. "20 Ramadan 1447"

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.gregorianDate,
    required this.hijriDate,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] ?? {};
    final date = json['date'] ?? {};
    final hijri = date['hijri'] ?? {};
    final hijriMonth = hijri['month'] ?? {};

    return PrayerTimesModel(
      fajr: timings['Fajr'] ?? '',
      sunrise: timings['Sunrise'] ?? '',
      dhuhr: timings['Dhuhr'] ?? '',
      asr: timings['Asr'] ?? '',
      maghrib: timings['Maghrib'] ?? '',
      isha: timings['Isha'] ?? '',
      gregorianDate: date['readable'] ?? '',
      hijriDate:
          '${hijri['day'] ?? ''} ${hijriMonth['en'] ?? ''} ${hijri['year'] ?? ''}',
    );
  }
}
