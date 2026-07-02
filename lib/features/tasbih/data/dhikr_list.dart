class DhikrItem {
  final String id;
  final String arabic;
  final String transliteration;
  final String translationEn;
  final String translationBn;
  final String meaningEn;
  final String meaningBn;
  final int target;

  const DhikrItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translationEn,
    required this.translationBn,
    required this.meaningEn,
    required this.meaningBn,
    required this.target,
  });
}

final List<DhikrItem> allDhikr = [
  DhikrItem(
    id: 'subhanallah',
    arabic: 'سُبْحَانَ اللَّهِ',
    transliteration: 'Subhanallah',
    translationEn: 'Glory be to Allah',
    translationBn: 'সুবহানাল্লাহ',
    meaningEn: 'Allah is free from all imperfections',
    meaningBn: 'আল্লাহ পবিত্র',
    target: 33,
  ),
  DhikrItem(
    id: 'alhamdulillah',
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    translationEn: 'All praise is due to Allah',
    translationBn: 'আলহামদুলিল্লাহ',
    meaningEn: 'All praise and thanks belong to Allah alone',
    meaningBn: 'সমস্ত প্রশংসা আল্লাহর',
    target: 33,
  ),
  DhikrItem(
    id: 'allahu_akbar',
    arabic: 'اللَّهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    translationEn: 'Allah is the Greatest',
    translationBn: 'আল্লাহু আকবার',
    meaningEn: 'Allah is greater than everything',
    meaningBn: 'আল্লাহ মহান',
    target: 34,
  ),
  DhikrItem(
    id: 'la_ilaha_illallah',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    transliteration: 'La ilaha illallah',
    translationEn: 'There is no god but Allah',
    translationBn: 'লা ইলাহা ইল্লাল্লাহ',
    meaningEn: 'None has the right to be worshipped except Allah',
    meaningBn: 'আল্লাহ ছাড়া কোনো মাবুদ নেই',
    target: 100,
  ),
  DhikrItem(
    id: 'subhanallah_wabihamdih',
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration: 'Subhanallah wa bihamdih',
    translationEn: 'Glory and praise be to Allah',
    translationBn: 'সুবহানাল্লাহি ওয়া বিহামদিহি',
    meaningEn: 'Glory be to Allah and all praise is due to Him',
    meaningBn: 'আল্লাহ পবিত্র ও তাঁর প্রশংসা',
    target: 100,
  ),
  DhikrItem(
    id: 'astaghfirullah',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    transliteration: 'Astaghfirullah',
    translationEn: 'I seek forgiveness from Allah',
    translationBn: 'আস্তাগফিরুল্লাহ',
    meaningEn: 'I ask Allah to forgive my sins',
    meaningBn: 'আমি আল্লাহর কাছে ক্ষমা চাই',
    target: 100,
  ),
  DhikrItem(
    id: 'la_howla',
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration: 'La hawla wa la quwwata illa billah',
    translationEn: 'There is no power except from Allah',
    translationBn: 'লা হাওলা ওয়ালা কুওয়াতা ইল্লা বিল্লাহ',
    meaningEn: 'There is no might nor power except with Allah',
    meaningBn: 'আল্লাহ ছাড়া কোনো শক্তি নেই',
    target: 100,
  ),
  DhikrItem(
    id: 'surah_ikhlas',
    arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
    transliteration: 'Qul huwallahu ahad',
    translationEn: 'Say: He is Allah, the One',
    translationBn: 'কুল হুয়াল্লাহু আহাদ',
    meaningEn: 'Recite Surah Al-Ikhlas',
    meaningBn: 'সূরা ইখলাস পাঠ',
    target: 3,
  ),
  DhikrItem(
    id: 'salawat',
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    transliteration: 'Allahumma salli ala Muhammad',
    translationEn: 'O Allah, send peace upon Muhammad',
    translationBn: 'আল্লাহুম্মা সাল্লি আলা মুহাম্মাদ',
    meaningEn: 'Send blessings upon the Prophet',
    meaningBn: 'নবীর উপর দরুদ পাঠ',
    target: 100,
  ),
  DhikrItem(
    id: 'shahada',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ',
    transliteration: 'La ilaha illallah Muhammadur Rasulullah',
    translationEn: 'There is no god but Allah, Muhammad is His messenger',
    translationBn: 'লা ইলাহা ইল্লাল্লাহু মুহাম্মাদুর রাসুলুল্লাহ',
    meaningEn: 'The declaration of faith',
    meaningBn: 'কালিমা তাইয়্যেবা',
    target: 100,
  ),
];
