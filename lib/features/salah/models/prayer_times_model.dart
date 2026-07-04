class PrayerTimesModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String jummah;

  final String gregorianDate;
  final String hijriDate;
  final String hijriMonth;

  final String? sehriTime;
  final String? iftarTime;

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
    this.sehriTime,
    this.iftarTime,
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
      jummah: '13:30',
      gregorianDate: date['readable'] ?? '',
      hijriDate: '${hijri['day'] ?? ''} ${hijriMonthData['en'] ?? ''} ${hijri['year'] ?? ''}',
      hijriMonth: hijriMonthData['en'] ?? '',
    );
  }

  factory PrayerTimesModel.fromSupabase(Map<String, dynamic> row) {
    return PrayerTimesModel(
      fajr: row['fajr_adhan'] ?? '',
      sunrise: row['sunrise'] ?? '',
      dhuhr: row['dhuhr_adhan'] ?? '',
      asr: row['asr_adhan'] ?? '',
      maghrib: row['maghrib_adhan'] ?? '',
      isha: row['isha_adhan'] ?? row['ish_adhan'] ?? '',
      jummah: row['jummah_adhan'] ?? '13:30',
      gregorianDate: row['date'] ?? '',
      hijriDate: '',
      hijriMonth: '',
      sehriTime: row['sehri_time'],
      iftarTime: row['iftar_time'],
    );
  }
}
