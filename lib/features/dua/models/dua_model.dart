import 'package:flutter/material.dart';

enum DuaCategory {
  morning,
  evening,
  night,
  daily,
  ramadanSpecial,
  travel,
  forgiveness,
}

extension DuaCategoryLabel on DuaCategory {
  String get banglaLabel {
    switch (this) {
      case DuaCategory.morning:
        return 'সকাল';
      case DuaCategory.evening:
        return 'সন্ধ্যা';
      case DuaCategory.night:
        return 'রাত';
      case DuaCategory.daily:
        return 'দৈনিক';
      case DuaCategory.ramadanSpecial:
        return 'রমজান';
      case DuaCategory.travel:
        return 'সফর';
      case DuaCategory.forgiveness:
        return 'ক্ষমা';
    }
  }

  String get englishLabel {
    switch (this) {
      case DuaCategory.morning:
        return 'Morning';
      case DuaCategory.evening:
        return 'Evening';
      case DuaCategory.night:
        return 'Night';
      case DuaCategory.daily:
        return 'Daily';
      case DuaCategory.ramadanSpecial:
        return 'Ramadan';
      case DuaCategory.travel:
        return 'Travel';
      case DuaCategory.forgiveness:
        return 'Forgiveness';
    }
  }

  String getLabel(String langCode) =>
      langCode == 'bn' ? banglaLabel : englishLabel;

  Color get accentColor {
    switch (this) {
      case DuaCategory.morning:
        return const Color(0xFFF59E0B);
      case DuaCategory.evening:
        return const Color(0xFF6366F1);
      case DuaCategory.night:
        return const Color(0xFF3B4C8C);
      case DuaCategory.daily:
        return const Color(0xFF10B981);
      case DuaCategory.ramadanSpecial:
        return const Color(0xFFD4AF37);
      case DuaCategory.travel:
        return const Color(0xFF3B82F6);
      case DuaCategory.forgiveness:
        return const Color(0xFF8B5CF6);
    }
  }

  IconData get categoryIcon {
    switch (this) {
      case DuaCategory.morning:
        return Icons.wb_sunny_rounded;
      case DuaCategory.evening:
        return Icons.wb_twilight_rounded;
      case DuaCategory.night:
        return Icons.bedtime_rounded;
      case DuaCategory.daily:
        return Icons.today_rounded;
      case DuaCategory.ramadanSpecial:
        return Icons.star_rounded;
      case DuaCategory.travel:
        return Icons.flight_takeoff_rounded;
      case DuaCategory.forgiveness:
        return Icons.favorite_rounded;
    }
  }
}

class DuaModel {
  final String id;
  final String banglaName;
  final String englishName;
  final DuaCategory group;
  final IconData icon;
  final String arabic;
  final String banglaTranslation;
  final String englishTranslation;
  final String banglaPronounciation;
  final String englishPronounciation;
  final String reference;
  final int tasbihTarget;

  const DuaModel({
    required this.id,
    required this.banglaName,
    required this.englishName,
    required this.group,
    required this.icon,
    required this.arabic,
    required this.banglaTranslation,
    required this.englishTranslation,
    required this.banglaPronounciation,
    required this.englishPronounciation,
    required this.reference,
    this.tasbihTarget = 0,
  });

  String getName(String langCode) =>
      langCode == 'bn' ? banglaName : englishName;

  String getTranslation(String langCode) =>
      langCode == 'bn' ? banglaTranslation : englishTranslation;

  String getPronounciation(String langCode) =>
      langCode == 'bn' ? banglaPronounciation : englishPronounciation;
}

const allDuas = <DuaModel>[
  // ── সকাল (Morning) ──────────────────────────────────────────────────────────
  DuaModel(
    id: 'dua_01',
    banglaName: 'ঘুম থেকে জাগার দোয়া',
    englishName: 'Dua Upon Waking',
    group: DuaCategory.morning,
    icon: Icons.wb_sunny_rounded,
    arabic:
        'اَلْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    banglaTranslation:
        'সকল প্রশংসা আল্লাহর জন্য, যিনি আমাদের মৃত্যুর (ঘুমের) পর পুনরায় জীবিত করেছেন এবং তাঁর দিকেই পুনরুত্থান।',
    englishTranslation:
        'All praise is for Allah who revived us after He had caused us to die (sleep), and unto Him is the Resurrection.',
    banglaPronounciation:
        'আলহামদু লিল্লাহিল্লাযী আহইয়ানা বা\'দা মা আমাতানা ওয়া ইলাইহিন নুশূর',
    englishPronounciation:
        'Alhamdu lillahil-lathee ahyana ba\'da ma amatana wa ilayhin-nushoor',
    reference: 'সহীহ বুখারী: ৬৩২৪',
  ),
  DuaModel(
    id: 'dua_02',
    banglaName: 'সকালের আযকার',
    englishName: 'Morning Adhkar',
    group: DuaCategory.morning,
    icon: Icons.wb_twilight_rounded,
    arabic:
        'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
    banglaTranslation:
        'আমরা সকালে উপনীত হলাম এবং সকল রাজত্ব আল্লাহর জন্য। সকল প্রশংসা আল্লাহর। আল্লাহ ছাড়া কোনো ইলাহ নেই, তিনি একক, তাঁর কোনো শরীক নেই।',
    englishTranslation:
        'We have reached the morning and at this very time all sovereignty belongs to Allah. All praise is for Allah. There is nothing worthy of worship except Allah, alone, Who has no partner.',
    banglaPronounciation:
        'আসবাহনা ওয়া আসবাহাল মুলকু লিল্লাহ, ওয়ালহামদু লিল্লাহ, লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারিকা লাহ',
    englishPronounciation:
        'Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah',
    reference: 'সহীহ মুসলিম: ২৭২৩',
  ),
  DuaModel(
    id: 'dua_03',
    banglaName: 'সকালের সুরক্ষার দোয়া',
    englishName: 'Morning Protection Dua',
    group: DuaCategory.morning,
    icon: Icons.shield_rounded,
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    banglaTranslation:
        'আল্লাহর নামে, যাঁর নামের সাথে আসমান ও যমীনে কোনো কিছুই ক্ষতি করতে পারে না। তিনি সর্বশ্রোতা, সর্বজ্ঞ।',
    englishTranslation:
        'In the name of Allah, with whose name nothing can harm on earth or in the heavens, and He is the All-Hearing, All-Knowing.',
    banglaPronounciation:
        'বিসমিল্লাহিল্লাযী লা ইয়াদুররু মা\'আসমিহি শাইউন ফিল আরদি ওয়ালা ফিস সামাই ওয়া হুওয়াস সামীউল আলীম',
    englishPronounciation:
        'Bismillahil-lathee la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-samee\'ul-\'aleem',
    reference: 'আবু দাউদ: ৫০৮৮',
    tasbihTarget: 3,
  ),

  // ── সন্ধ্যা (Evening) ────────────────────────────────────────────────────────
  DuaModel(
    id: 'dua_05',
    banglaName: 'সন্ধ্যার আযকার',
    englishName: 'Evening Adhkar',
    group: DuaCategory.evening,
    icon: Icons.dark_mode_rounded,
    arabic:
        'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
    banglaTranslation:
        'আমরা সন্ধ্যায় উপনীত হলাম এবং সকল রাজত্ব আল্লাহর জন্য। সকল প্রশংসা আল্লাহর। আল্লাহ ছাড়া কোনো ইলাহ নেই, তিনি একক, তাঁর কোনো শরীক নেই।',
    englishTranslation:
        'We have reached the evening and at this very time all sovereignty belongs to Allah. All praise is for Allah. There is nothing worthy of worship except Allah, alone, Who has no partner.',
    banglaPronounciation:
        'আমসাইনা ওয়া আমসাল মুলকু লিল্লাহ, ওয়ালহামদু লিল্লাহ, লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারিকা লাহ',
    englishPronounciation:
        'Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah',
    reference: 'সহীহ মুসলিম: ২৭২৩',
  ),
  DuaModel(
    id: 'dua_27',
    banglaName: 'সন্ধ্যার সুরক্ষার দোয়া',
    englishName: 'Evening Protection Dua',
    group: DuaCategory.evening,
    icon: Icons.security_rounded,
    arabic:
        'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
    banglaTranslation:
        'আমি আল্লাহর পরিপূর্ণ কালামের মাধ্যমে তাঁর সৃষ্টির সকল অনিষ্ট থেকে আশ্রয় চাই।',
    englishTranslation:
        'I seek refuge in the complete words of Allah from the evil of what He has created.',
    banglaPronounciation:
        'আউযু বিকালিমাতিল্লাহিত তাম্মাতি মিন শাররি মা খালাক্ব',
    englishPronounciation:
        'A\'oodhu bikalimatillahit-tammati min sharri ma khalaq',
    reference: 'সহীহ মুসলিম: ২৭০৯',
    tasbihTarget: 3,
  ),
  DuaModel(
    id: 'dua_28',
    banglaName: 'সন্ধ্যার তাসবিহ',
    englishName: 'Evening Tasbih',
    group: DuaCategory.evening,
    icon: Icons.radio_button_checked_rounded,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    banglaTranslation: 'আল্লাহ পবিত্র এবং তাঁর প্রশংসাসহ পবিত্র।',
    englishTranslation: 'Glory and praise be to Allah.',
    banglaPronounciation: 'সুবহানাল্লাহি ওয়া বিহামদিহ',
    englishPronounciation: 'Subhanallahi wa bihamdih',
    reference: 'সহীহ বুখারী: ৬৬৮২',
    tasbihTarget: 100,
  ),
  DuaModel(
    id: 'dua_29',
    banglaName: 'সন্ধ্যায় শরীরের আরোগ্যের দোয়া',
    englishName: 'Evening Health Dua',
    group: DuaCategory.evening,
    icon: Icons.favorite_border_rounded,
    arabic:
        'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ',
    banglaTranslation:
        'হে আল্লাহ! আমার শরীরকে সুস্থ রাখুন। হে আল্লাহ! আমার কানকে সুস্থ রাখুন। হে আল্লাহ! আমার চোখকে সুস্থ রাখুন। আপনি ছাড়া কোনো ইলাহ নেই।',
    englishTranslation:
        'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. There is no deity but You.',
    banglaPronounciation:
        'আল্লাহুম্মা \'আফিনী ফী বাদানী, আল্লাহুম্মা \'আফিনী ফী সাম\'ঈ, আল্লাহুম্মা \'আফিনী ফী বাসারী, লা ইলাহা ইল্লা আন্ত',
    englishPronounciation:
        'Allahumma \'afini fi badani, Allahumma \'afini fi sam\'ee, Allahumma \'afini fi basaree, la ilaha illa anta',
    reference: 'আবু দাউদ: ৫০৯০',
    tasbihTarget: 3,
  ),

  // ── রাত (Night) ──────────────────────────────────────────────────────────────
  DuaModel(
    id: 'dua_04',
    banglaName: 'ঘুমানোর দোয়া',
    englishName: 'Bedtime Dua',
    group: DuaCategory.night,
    icon: Icons.bedtime_rounded,
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    banglaTranslation:
        'হে আল্লাহ! আপনার নামেই আমি মৃত্যুবরণ করি (ঘুমাই) এবং জীবিত হই (জাগি)।',
    englishTranslation:
        'In Your name, O Allah, I die (sleep) and I live (wake).',
    banglaPronounciation: 'বিসমিকা আল্লাহুম্মা আমূতু ওয়া আহইয়া',
    englishPronounciation: 'Bismika Allahumma amootu wa ahya',
    reference: 'সহীহ বুখারী: ৬৩২৫',
  ),
  DuaModel(
    id: 'dua_06',
    banglaName: 'ঘুমানোর আগে আয়াতুল কুরসী',
    englishName: 'Ayatul Kursi Before Sleep',
    group: DuaCategory.night,
    icon: Icons.auto_stories_rounded,
    arabic:
        'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
    banglaTranslation:
        'আল্লাহ, তিনি ছাড়া কোনো ইলাহ নেই। তিনি চিরঞ্জীব, সর্বসত্তার ধারক। তন্দ্রা ও নিদ্রা তাঁকে স্পর্শ করে না।',
    englishTranslation:
        'Allah, there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep.',
    banglaPronounciation:
        'আল্লাহু লা ইলাহা ইল্লা হুওয়াল হাইয়্যুল ক্বাইয়্যুম, লা তা\'খুযুহু সিনাতুন ওয়ালা নাউম',
    englishPronounciation:
        'Allahu la ilaha illa huwal-hayyul-qayyum, la ta\'khuthuhu sinatun wa la nawm',
    reference: 'সহীহ বুখারী: ৫০১০',
  ),
  DuaModel(
    id: 'dua_30',
    banglaName: 'ঘুমানোর আগে বিশেষ দোয়া',
    englishName: 'Special Bedtime Supplication',
    group: DuaCategory.night,
    icon: Icons.nights_stay_rounded,
    arabic:
        'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ وَفَوَّضْتُ أَمْرِي إِلَيْكَ وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ رَهْبَةً وَرَغْبَةً إِلَيْكَ آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
    banglaTranslation:
        'হে আল্লাহ! আমি আমার জীবন আপনার কাছে সমর্পণ করলাম, আমার বিষয় আপনার কাছে ন্যস্ত করলাম এবং ভয় ও আকাঙ্ক্ষায় আপনার দিকে হেলান দিলাম। আমি আপনার নাযিলকৃত কিতাব ও আপনার প্রেরিত নবীর প্রতি ঈমান এনেছি।',
    englishTranslation:
        'O Allah, I submit myself to You, entrust my affairs to You, and I rely fully upon You out of fear and hope of You. I believe in Your revealed Book and Your sent Prophet.',
    banglaPronounciation:
        'আল্লাহুম্মা আসলামতু নাফসী ইলাইক, ওয়া ফাওওয়াদতু আমরী ইলাইক, ওয়া আলজা\'তু যাহরী ইলাইক, রাহবাতান ওয়া রাগবাতান ইলাইক। আমানতু বিকিতাবিকাল্লাযী আনযালতা ওয়া নাবিয়্যিকাল্লাযী আরসালত',
    englishPronounciation:
        'Allahumma aslamtu nafsee ilayk, wa fawwadtu amree ilayk, wa alja\'tu zahree ilayk, rahbatan wa raghbatan ilayk. Amantu bikitabikal-lathee anzalta wa nabiyyikal-lathee arsalt',
    reference: 'সহীহ বুখারী: ২৪৭',
  ),
  DuaModel(
    id: 'dua_31',
    banglaName: 'রাতে জেগে উঠলে দোয়া',
    englishName: 'Dua When Waking at Night',
    group: DuaCategory.night,
    icon: Icons.star_rounded,
    arabic:
        'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    banglaTranslation:
        'আল্লাহ ছাড়া কোনো ইলাহ নেই, তিনি একক, তাঁর কোনো শরীক নেই। রাজত্ব তাঁর এবং প্রশংসা তাঁর। তিনি সব কিছুর উপর সর্বশক্তিমান।',
    englishTranslation:
        'None has the right to be worshipped except Allah, alone, without partners. To Him belongs all sovereignty and all praise, and He is over all things omnipotent.',
    banglaPronounciation:
        'লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারিকা লাহু, লাহুল মুলকু ওয়া লাহুল হামদু ওয়া হুওয়া \'আলা কুল্লি শাই\'ইন ক্বদীর',
    englishPronounciation:
        'La ilaha illallahu wahdahu la sharika lahu, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadeer',
    reference: 'সহীহ বুখারী: ১১৫৪',
  ),
  DuaModel(
    id: 'dua_32',
    banglaName: 'ঘুমানোর আগে তিন কুল',
    englishName: 'Three Quls Before Sleep',
    group: DuaCategory.night,
    icon: Icons.menu_book_rounded,
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
    banglaTranslation:
        'ঘুমানোর আগে সূরা ইখলাস, সূরা ফালাক ও সূরা নাস তিনবার পড়ে উভয় হাতে ফুঁক দিয়ে সারা শরীরে মুছে নিন।',
    englishTranslation:
        'Read Surah Ikhlas, Surah Al-Falaq, and Surah An-Nas three times, then blow into your hands and wipe them over your body.',
    banglaPronounciation:
        'ক্বুল হুওয়াল্লাহু আহাদ... ক্বুল আউযু বিরাব্বিল ফালাক্ব... ক্বুল আউযু বিরাব্বিন নাস',
    englishPronounciation:
        'Qul huwa Allahu ahad... Qul a\'oodhu birabbil-falaq... Qul a\'oodhu birabbin-nas',
    reference: 'সহীহ বুখারী: ৫০১৭',
    tasbihTarget: 3,
  ),

  // ── দৈনিক (Daily) ────────────────────────────────────────────────────────────
  DuaModel(
    id: 'dua_07',
    banglaName: 'খাবার শুরুর দোয়া',
    englishName: 'Dua Before Eating',
    group: DuaCategory.daily,
    icon: Icons.restaurant_rounded,
    arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    banglaTranslation:
        'আল্লাহর নামে এবং আল্লাহর বরকতে (শুরু করছি)।',
    englishTranslation:
        'In the name of Allah and with the blessings of Allah.',
    banglaPronounciation: 'বিসমিল্লাহি ওয়া \'আলা বারাকাতিল্লাহ',
    englishPronounciation: 'Bismillahi wa \'ala barakatillah',
    reference: 'আবু দাউদ: ৩৭৬৭',
  ),
  DuaModel(
    id: 'dua_08',
    banglaName: 'খাবার শেষের দোয়া',
    englishName: 'Dua After Eating',
    group: DuaCategory.daily,
    icon: Icons.thumb_up_alt_rounded,
    arabic:
        'اَلْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
    banglaTranslation:
        'সকল প্রশংসা আল্লাহর জন্য, যিনি আমাদের খাওয়ালেন, পান করালেন এবং আমাদের মুসলিম বানালেন।',
    englishTranslation:
        'All praise is for Allah who fed us, gave us drink, and made us Muslims.',
    banglaPronounciation:
        'আলহামদু লিল্লাহিল্লাযী আত\'আমানা ওয়া সাক্বানা ওয়া জা\'আলানা মুসলিমীন',
    englishPronounciation:
        'Alhamdu lillahil-lathee at\'amana wa saqana wa ja\'alana muslimeen',
    reference: 'আবু দাউদ: ৩৮৫০',
  ),
  DuaModel(
    id: 'dua_09',
    banglaName: 'ঘর থেকে বের হওয়ার দোয়া',
    englishName: 'Dua When Leaving Home',
    group: DuaCategory.daily,
    icon: Icons.door_front_door_rounded,
    arabic:
        'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    banglaTranslation:
        'আল্লাহর নামে (বের হচ্ছি), আল্লাহর উপর ভরসা করলাম। আল্লাহর সাহায্য ছাড়া কোনো উপায় নেই, কোনো শক্তি নেই।',
    englishTranslation:
        'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
    banglaPronounciation:
        'বিসমিল্লাহি, তাওয়াককালতু \'আলাল্লাহ, ওয়া লা হাওলা ওয়া লা ক্বুওয়্যাতা ইল্লা বিল্লাহ',
    englishPronounciation:
        'Bismillahi, tawakkaltu \'alallah, wa la hawla wa la quwwata illa billah',
    reference: 'আবু দাউদ: ৫০৯৫',
  ),
  DuaModel(
    id: 'dua_10',
    banglaName: 'ঘরে প্রবেশের দোয়া',
    englishName: 'Dua When Entering Home',
    group: DuaCategory.daily,
    icon: Icons.home_rounded,
    arabic:
        'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    banglaTranslation:
        'আল্লাহর নামে আমরা প্রবেশ করছি, আল্লাহর নামে বের হচ্ছি এবং আমাদের রবের উপর ভরসা করছি।',
    englishTranslation:
        'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we place our trust.',
    banglaPronounciation:
        'বিসমিল্লাহি ওয়ালাজনা, ওয়া বিসমিল্লাহি খারাজনা, ওয়া \'আলা রাব্বিনা তাওয়াককালনা',
    englishPronounciation:
        'Bismillahi walajna, wa bismillahi kharajna, wa \'ala rabbina tawakkalna',
    reference: 'আবু দাউদ: ৫০৯৬',
  ),
  DuaModel(
    id: 'dua_11',
    banglaName: 'মসজিদে প্রবেশের দোয়া',
    englishName: 'Dua Entering the Mosque',
    group: DuaCategory.daily,
    icon: Icons.mosque_rounded,
    arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    banglaTranslation:
        'হে আল্লাহ! আমার জন্য আপনার রহমতের দরজাসমূহ খুলে দিন।',
    englishTranslation:
        'O Allah, open the gates of Your mercy for me.',
    banglaPronounciation: 'আল্লাহুম্মা ইফতাহ লী আবওয়াবা রাহমাতিক',
    englishPronounciation: 'Allahumma iftah li abwaba rahmatik',
    reference: 'সহীহ মুসলিম: ৭১৩',
  ),
  DuaModel(
    id: 'dua_12',
    banglaName: 'মসজিদ থেকে বের হওয়ার দোয়া',
    englishName: 'Dua Leaving the Mosque',
    group: DuaCategory.daily,
    icon: Icons.mosque_outlined,
    arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    banglaTranslation: 'হে আল্লাহ! আমি আপনার অনুগ্রহ প্রার্থনা করছি।',
    englishTranslation: 'O Allah, I ask You from Your bounty.',
    banglaPronounciation: 'আল্লাহুম্মা ইন্নী আস\'আলুকা মিন ফাদলিক',
    englishPronounciation: 'Allahumma inni as\'aluka min fadlik',
    reference: 'সহীহ মুসলিম: ৭১৩',
  ),
  DuaModel(
    id: 'dua_13',
    banglaName: 'বিপদের দোয়া',
    englishName: 'Dua During Hardship',
    group: DuaCategory.daily,
    icon: Icons.healing_rounded,
    arabic:
        'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا',
    banglaTranslation:
        'নিশ্চয়ই আমরা আল্লাহর জন্য এবং তাঁর কাছেই ফিরে যাব। হে আল্লাহ! আমার বিপদে আমাকে সওয়াব দিন এবং এর চেয়ে উত্তম বিকল্প দান করুন।',
    englishTranslation:
        'Indeed we belong to Allah, and indeed unto Him we will return. O Allah, recompense me for my affliction and replace it for me with something better.',
    banglaPronounciation:
        'ইন্না লিল্লাহি ওয়া ইন্না ইলাইহি রাজিউন, আল্লাহুম্মা আজুরনী ফী মুসীবাতী ওয়া আখলিফ লী খাইরান মিনহা',
    englishPronounciation:
        'Inna lillahi wa inna ilayhi raji\'oon, Allahumma a\'jurni fi museebati wa akhlif li khayran minha',
    reference: 'সহীহ মুসলিম: ৯১৮',
  ),
  DuaModel(
    id: 'dua_14',
    banglaName: 'ইস্তেখারার দোয়া',
    englishName: 'Istikhara Dua',
    group: DuaCategory.daily,
    icon: Icons.help_outline_rounded,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ',
    banglaTranslation:
        'হে আল্লাহ! আমি আপনার জ্ঞানের মাধ্যমে আপনার কাছে কল্যাণ চাচ্ছি, আপনার কুদরতের মাধ্যমে শক্তি চাচ্ছি এবং আপনার মহান অনুগ্রহ চাচ্ছি।',
    englishTranslation:
        'O Allah, I seek Your guidance in my decision by Your knowledge, I seek power by Your power, and I ask You from Your immense bounty.',
    banglaPronounciation:
        'আল্লাহুম্মা ইন্নী আস্তাখীরুকা বি\'ইলমিক, ওয়া আস্তাক্বদিরুকা বিক্বুদরাতিক, ওয়া আস\'আলুকা মিন ফাদলিকাল আযীম',
    englishPronounciation:
        'Allahumma inni astakheeruka bi\'ilmik, wa astaqdiruka biqudratik, wa as\'aluka min fadlikal-\'azeem',
    reference: 'সহীহ বুখারী: ১১৬২',
  ),
  DuaModel(
    id: 'dua_15',
    banglaName: 'টয়লেটে প্রবেশের দোয়া',
    englishName: 'Dua Entering the Toilet',
    group: DuaCategory.daily,
    icon: Icons.water_rounded,
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    banglaTranslation:
        'হে আল্লাহ! আমি আপনার কাছে জিন পুরুষ ও জিন নারীদের অনিষ্ট থেকে আশ্রয় চাই।',
    englishTranslation:
        'O Allah, I seek refuge in You from the male and female devils.',
    banglaPronounciation:
        'আল্লাহুম্মা ইন্নী আউযু বিকা মিনাল খুবুসি ওয়াল খাবায়িস',
    englishPronounciation:
        'Allahumma inni a\'oodhu bika minal-khubuthi wal-khaba\'ith',
    reference: 'সহীহ বুখারী: ১৪২',
  ),
  DuaModel(
    id: 'dua_16',
    banglaName: 'অসুস্থ ব্যক্তির জন্য দোয়া',
    englishName: 'Dua for the Sick',
    group: DuaCategory.daily,
    icon: Icons.local_hospital_rounded,
    arabic:
        'أَذْهِبِ الْبَأْسَ رَبَّ النَّاسِ اشْفِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا',
    banglaTranslation:
        'হে মানুষের রব! কষ্ট দূর করুন, আরোগ্য দান করুন। আপনিই আরোগ্যদানকারী। আপনার আরোগ্য ছাড়া কোনো আরোগ্য নেই— এমন আরোগ্য দিন যা কোনো রোগ অবশিষ্ট রাখে না।',
    englishTranslation:
        'Remove the affliction, O Lord of mankind. Grant healing; You are the Healer. There is no healing except Your healing—a healing that leaves no illness behind.',
    banglaPronounciation:
        'আযহিবিল বা\'সা রাব্বান্নাস, ইশফি ওয়া আন্তাশ শাফী, লা শিফাআ ইল্লা শিফাউক, শিফাআন লা ইউগাদিরু সাক্বামা',
    englishPronounciation:
        'Adhhabil ba\'sa rabban-nas, ishfi wa antash-shafi, la shifa\'a illa shifa\'uk, shifa\'an la yughadiru saqama',
    reference: 'সহীহ বুখারী: ৫৭৫০',
  ),

  // ── রমজান বিশেষ (Ramadan Special) ──────────────────────────────────────────
  DuaModel(
    id: 'dua_17',
    banglaName: 'সাহরীর দোয়া (রোজার নিয়ত)',
    englishName: 'Intention to Fast (Sehri)',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.wb_twilight_rounded,
    arabic: 'وَبِصَوْمِ غَدٍ نَوَيْتُ مِنْ شَهْرِ رَمَضَانَ',
    banglaTranslation: 'রমজান মাসের আগামীকালের রোজা রাখার নিয়ত করলাম।',
    englishTranslation:
        'I intend to fast tomorrow of the month of Ramadan.',
    banglaPronounciation:
        'ওয়া বিসাওমি গাদিন নাওয়াইতু মিন শাহরি রামাদান',
    englishPronounciation:
        'Wa bisawmi ghadin nawaitu min shahri ramadan',
    reference: 'আবু দাউদ: ২৪৫৪',
  ),
  DuaModel(
    id: 'dua_18',
    banglaName: 'ইফতারের দোয়া',
    englishName: 'Iftar Dua',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.water_drop_rounded,
    arabic:
        'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
    banglaTranslation:
        'পিপাসা দূর হলো, শিরাগুলো সিক্ত হলো এবং ইনশাআল্লাহ সওয়াব নির্ধারিত হলো।',
    englishTranslation:
        'The thirst has gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
    banglaPronounciation:
        'যাহাবায যামাউ ওয়াবতাল্লাতিল উরূক্বু ওয়া সাবাতাল আজরু ইনশাআল্লাহ',
    englishPronounciation:
        'Dhahaba az-zama\'u wabtallatil-\'urooqu wa thabatal-ajru insha\'allah',
    reference: 'আবু দাউদ: ২৩৫৭',
  ),
  DuaModel(
    id: 'dua_19',
    banglaName: 'লাইলাতুল কদরের দোয়া',
    englishName: 'Laylatul Qadr Dua',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.nights_stay_rounded,
    arabic:
        'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
    banglaTranslation:
        'হে আল্লাহ! আপনি পরম ক্ষমাশীল, আপনি ক্ষমা করতে ভালোবাসেন, তাই আমাকে ক্ষমা করুন।',
    englishTranslation:
        'O Allah, You are the Most Forgiving, You love to forgive, so forgive me.',
    banglaPronounciation:
        'আল্লাহুম্মা ইন্নাকা \'আফুওয়্যুন তুহিব্বুল \'আফওয়া ফা\'ফু \'আন্নী',
    englishPronounciation:
        'Allahumma innaka \'afuwwun tuhibbul \'afwa fa\'fu \'anni',
    reference: 'তিরমিযী: ৩৫১৩',
    tasbihTarget: 100,
  ),
  DuaModel(
    id: 'dua_20',
    banglaName: 'তারাবীহর দোয়া (প্রতি ৪ রাকাত পর)',
    englishName: 'Tarawih Dua (After Every 4 Rakats)',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.mosque_rounded,
    arabic:
        'سُبْحَانَ ذِي الْمُلْكِ وَالْمَلَكُوتِ سُبْحَانَ ذِي الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ وَالْكِبْرِيَاءِ وَالْجَبَرُوتِ',
    banglaTranslation:
        'পবিত্র তিনি যিনি রাজত্ব ও মহারাজত্বের মালিক। পবিত্র তিনি যিনি সম্মান, মহত্ত্ব, প্রতাপ, শক্তি, বড়ত্ব ও পরাক্রমের মালিক।',
    englishTranslation:
        'Glory be to the Owner of sovereignty and dominion; glory be to the Owner of might, greatness, grandeur, power, pride, and majesty.',
    banglaPronounciation:
        'সুবহানা যিল মুলকি ওয়াল মালাকূত, সুবহানা যিল ইয্যাতি ওয়াল আযামাতি ওয়াল হাইবাতি ওয়াল ক্বুদরাতি ওয়াল কিবরিয়াই ওয়াল জাবারূত',
    englishPronounciation:
        'Subhana dhil-mulki wal-malakoot, subhana dhil-\'izzati wal-\'azamati wal-haybati wal-qudrati wal-kibriya\'i wal-jabaroot',
    reference: 'মুসান্নাফ ইবনে আবী শাইবা',
  ),

  // ── সফর (Travel) ────────────────────────────────────────────────────────────
  DuaModel(
    id: 'dua_21',
    banglaName: 'যাত্রার দোয়া',
    englishName: 'Dua for Travel',
    group: DuaCategory.travel,
    icon: Icons.flight_takeoff_rounded,
    arabic:
        'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
    banglaTranslation:
        'পবিত্র তিনি যিনি এটিকে আমাদের বশীভূত করে দিয়েছেন, আমরা একে বশীভূত করতে সক্ষম ছিলাম না। আর নিশ্চয়ই আমরা আমাদের রবের কাছে ফিরে যাব।',
    englishTranslation:
        'Glory be to the One who has subjected this for us, and we could never have it (by our efforts). And to our Lord we shall indeed return.',
    banglaPronounciation:
        'সুবহানাল্লাযী সাখখারা লানা হাযা ওয়া মা কুন্না লাহু মুক্বরিনীন ওয়া ইন্না ইলা রাব্বিনা লামুনক্বালিবূন',
    englishPronounciation:
        'Subhanal-lathee sakhkhara lana hadha wa ma kunna lahu muqrinin wa inna ila rabbina lamunqaliboon',
    reference: 'সূরা যুখরুফ: ১৩-১৪',
  ),
  DuaModel(
    id: 'dua_22',
    banglaName: 'সফর থেকে ফেরার দোয়া',
    englishName: 'Dua Returning from Travel',
    group: DuaCategory.travel,
    icon: Icons.flight_land_rounded,
    arabic: 'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
    banglaTranslation:
        'আমরা প্রত্যাবর্তনকারী, তওবাকারী, ইবাদতকারী এবং আমাদের রবের প্রশংসাকারী।',
    englishTranslation:
        'We are returning, repenting, worshipping, and to our Lord we are grateful.',
    banglaPronounciation:
        'আইবূন, তায়িবূন, \'আবিদূন, লি রাব্বিনা হামিদূন',
    englishPronounciation:
        'Ayboon, ta\'iboon, \'abidoon, li rabbina hamidoon',
    reference: 'সহীহ মুসলিম: ১৩৪২',
  ),

  // ── ক্ষমা (Forgiveness) ─────────────────────────────────────────────────────
  DuaModel(
    id: 'dua_23',
    banglaName: 'ক্ষমা প্রার্থনার দোয়া',
    englishName: 'Seeking Forgiveness',
    group: DuaCategory.forgiveness,
    icon: Icons.spa_rounded,
    arabic:
        'أَسْتَغْفِرُ اللَّهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
    banglaTranslation:
        'আমি আল্লাহর কাছে ক্ষমা চাই, যিনি ছাড়া কোনো ইলাহ নেই, তিনি চিরঞ্জীব, সর্বসত্তার ধারক এবং আমি তাঁর কাছে তাওবা করছি।',
    englishTranslation:
        'I seek forgiveness from Allah, besides Whom there is no god, the Ever-Living, the Sustainer, and I repent to Him.',
    banglaPronounciation:
        'আস্তাগফিরুল্লাহাল্লাযী লা ইলাহা ইল্লা হুওয়াল হাইয়্যুল ক্বাইয়্যুম ওয়া আতূবু ইলাইহ',
    englishPronounciation:
        'Astaghfirullahallathee la ilaha illa huwal hayyul qayyum wa atoobu ilayh',
    reference: 'আবু দাউদ: ১৫১৭',
    tasbihTarget: 100,
  ),
  DuaModel(
    id: 'dua_24',
    banglaName: 'সাইয়্যিদুল ইস্তিগফার',
    englishName: 'Sayyidul Istighfar',
    group: DuaCategory.forgiveness,
    icon: Icons.auto_awesome_rounded,
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    banglaTranslation:
        'হে আল্লাহ! আপনি আমার রব, আপনি ছাড়া কোনো ইলাহ নেই। আপনি আমাকে সৃষ্টি করেছেন, আমি আপনার বান্দা। আমি যথাসাধ্য আপনার ওয়াদা ও প্রতিশ্রুতির উপর আছি। আমি আমার কৃতকর্মের অনিষ্ট থেকে আপনার কাছে আশ্রয় চাই। আমার প্রতি আপনার নিয়ামতের কথা স্বীকার করছি এবং আমার গুনাহের কথাও স্বীকার করছি। অতএব আমাকে ক্ষমা করুন, কেননা আপনি ছাড়া কেউ গুনাহ ক্ষমা করতে পারে না।',
    englishTranslation:
        'O Allah, You are my Lord, there is no god but You. You created me and I am Your servant. I am following Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favor upon me and I acknowledge my sins. Forgive me, for indeed none forgives sins except You.',
    banglaPronounciation:
        'আল্লাহুম্মা আন্তা রাব্বী লা ইলাহা ইল্লা আন্তা খালাক্বতানী ওয়া আনা \'আবদুকা ওয়া আনা \'আলা \'আহদিকা ওয়া ওয়া\'দিকা মাস্তাতা\'তু আউযু বিকা মিন শাররি মা সানা\'তু আবূউ লাকা বিনি\'মাতিকা \'আলাইয়্যা ওয়া আবূউ বিযানবী ফাগফিরলী',
    englishPronounciation:
        'Allahumma anta rabbi la ilaha illa anta khalaqtani wa ana \'abduka wa ana \'ala \'ahdika wa wa\'dika mastata\'tu a\'oodhu bika min sharri ma sana\'tu aboo\'u laka bini\'matika \'alayya wa aboo\'u bithanbi faghfir lee',
    reference: 'সহীহ বুখারী: ৬৩০৬',
  ),
  DuaModel(
    id: 'dua_25',
    banglaName: 'সুবহানাল্লাহ তাসবিহ',
    englishName: 'Subhanallah Tasbih',
    group: DuaCategory.forgiveness,
    icon: Icons.circle_outlined,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
    banglaTranslation:
        'আল্লাহ পবিত্র এবং তাঁর প্রশংসাসহ পবিত্র, মহান আল্লাহ পবিত্র।',
    englishTranslation:
        'Glory and praise be to Allah; glory be to the Magnificent Allah.',
    banglaPronounciation:
        'সুবহানাল্লাহি ওয়া বিহামদিহ, সুবহানাল্লাহিল আযীম',
    englishPronounciation:
        'Subhanallahi wa bihamdih, subhanallahil \'azeem',
    reference: 'সহীহ বুখারী: ৬৬৮২',
    tasbihTarget: 33,
  ),
  DuaModel(
    id: 'dua_26',
    banglaName: 'সালাতের পর তাসবীহ',
    englishName: 'Post-Salah Tasbih',
    group: DuaCategory.forgiveness,
    icon: Icons.loop_rounded,
    arabic:
        'سُبْحَانَ اللَّهِ ٣٣ ، اَلْحَمْدُ لِلَّهِ ٣٣ ، اللَّهُ أَكْبَرُ ٣٤',
    banglaTranslation:
        'সুবহানাল্লাহ ৩৩ বার, আলহামদুলিল্লাহ ৩৩ বার, আল্লাহু আকবার ৩৪ বার।',
    englishTranslation:
        'SubhanAllah 33 times, Alhamdulillah 33 times, Allahu Akbar 34 times.',
    banglaPronounciation:
        'সুবহানাল্লাহ (৩৩ বার), আলহামদুলিল্লাহ (৩৩ বার), আল্লাহু আকবার (৩৪ বার)',
    englishPronounciation:
        'SubhanAllah (33×), Alhamdulillah (33×), Allahu Akbar (34×)',
    reference: 'সহীহ মুসলিম: ৫৯৫',
    tasbihTarget: 100,
  ),
];
