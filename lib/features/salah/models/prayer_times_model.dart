class PrayerTimesModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String jummah;

  final String gregorianDate; // e.g. "09 Mar 2026"
  final String hijriDate; // e.g. "20 Ramadan 1447"
  final String hijriMonth; // e.g. "Ramadan"

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.jummah,
    required this.gregorianDate,
    required this.hijriDate,
    required this.hijriMonth,
  });

  bool get isRamadan => hijriMonth.toLowerCase() == 'ramadan';

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] ?? {};
    final date = json['date'] ?? {};
    final hijri = date['hijri'] ?? {};
    final hijriMonthData = hijri['month'] ?? {};

    return PrayerTimesModel(
      fajr: timings['Fajr'] ?? '',
      sunrise: timings['Sunrise'] ?? '',
      dhuhr: timings['Dhuhr'] ?? '',
      asr: timings['Asr'] ?? '',
      maghrib: timings['Maghrib'] ?? '',
      isha: timings['Isha'] ?? '',
      jummah: '13:30', // Hardcoded as per user request
      gregorianDate: date['readable'] ?? '',
      hijriDate:
          '${hijri['day'] ?? ''} ${hijriMonthData['en'] ?? ''} ${hijri['year'] ?? ''}',
      hijriMonth: hijriMonthData['en'] ?? '',
    );
  }
}
