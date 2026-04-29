import 'package:flutter/material.dart';

enum DuaCategory {
  morning,
  evening,
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

  Color get accentColor {
    switch (this) {
      case DuaCategory.morning:
        return const Color(0xFFF59E0B);
      case DuaCategory.evening:
        return const Color(0xFF6366F1);
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
        return Icons.nights_stay_rounded;
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
  final String categoryBangla;
  final DuaCategory group;
  final IconData icon;
  final String arabic;
  final String bangla;
  final String reference;
  final int tasbihTarget;

  const DuaModel({
    required this.id,
    required this.categoryBangla,
    required this.group,
    required this.icon,
    required this.arabic,
    required this.bangla,
    required this.reference,
    this.tasbihTarget = 0,
  });
}

const allDuas = <DuaModel>[
  // ── সকাল (Morning) ──
  DuaModel(
    id: 'dua_01',
    categoryBangla: 'ঘুম থেকে জাগার দোয়া',
    group: DuaCategory.morning,
    icon: Icons.wb_sunny_rounded,
    arabic:
        'اَلْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    bangla:
        'সকল প্রশংসা আল্লাহর জন্য, যিনি আমাদের মৃত্যুর (ঘুমের) পর পুনরায় জীবিত করেছেন এবং তাঁর দিকেই পুনরুত্থান।',
    reference: 'সহীহ বুখারী: ৬৩২৪',
  ),
  DuaModel(
    id: 'dua_02',
    categoryBangla: 'সকালের আযকার',
    group: DuaCategory.morning,
    icon: Icons.wb_twilight_rounded,
    arabic:
        'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
    bangla:
        'আমরা সকালে উপনীত হলাম এবং সকল রাজত্ব আল্লাহর জন্য। সকল প্রশংসা আল্লাহর। আল্লাহ ছাড়া কোনো ইলাহ নেই, তিনি একক, তাঁর কোনো শরীক নেই।',
    reference: 'সহীহ মুসলিম: ২৭২৩',
  ),
  DuaModel(
    id: 'dua_03',
    categoryBangla: 'সকালের সুরক্ষার দোয়া',
    group: DuaCategory.morning,
    icon: Icons.shield_rounded,
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    bangla:
        'আল্লাহর নামে, যাঁর নামের সাথে আসমান ও যমীনে কোনো কিছুই ক্ষতি করতে পারে না। তিনি সর্বশ্রোতা, সর্বজ্ঞ।',
    reference: 'আবু দাউদ: ৫০৮৮',
    tasbihTarget: 3,
  ),

  // ── সন্ধ্যা (Evening) ──
  DuaModel(
    id: 'dua_04',
    categoryBangla: 'ঘুমানোর দোয়া',
    group: DuaCategory.evening,
    icon: Icons.bedtime_rounded,
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    bangla:
        'হে আল্লাহ! আপনার নামেই আমি মৃত্যুবরণ করি (ঘুমাই) এবং জীবিত হই (জাগি)।',
    reference: 'সহীহ বুখারী: ৬৩২৫',
  ),
  DuaModel(
    id: 'dua_05',
    categoryBangla: 'সন্ধ্যার আযকার',
    group: DuaCategory.evening,
    icon: Icons.dark_mode_rounded,
    arabic:
        'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
    bangla:
        'আমরা সন্ধ্যায় উপনীত হলাম এবং সকল রাজত্ব আল্লাহর জন্য। সকল প্রশংসা আল্লাহর। আল্লাহ ছাড়া কোনো ইলাহ নেই, তিনি একক, তাঁর কোনো শরীক নেই।',
    reference: 'সহীহ মুসলিম: ২৭২৩',
  ),
  DuaModel(
    id: 'dua_06',
    categoryBangla: 'ঘুমানোর আগে আয়াতুল কুরসী',
    group: DuaCategory.evening,
    icon: Icons.auto_stories_rounded,
    arabic:
        'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
    bangla:
        'আল্লাহ, তিনি ছাড়া কোনো ইলাহ নেই। তিনি চিরঞ্জীব, সর্বসত্তার ধারক। তন্দ্রা ও নিদ্রা তাঁকে স্পর্শ করে না।',
    reference: 'সহীহ বুখারী: ৫০১০',
  ),

  // ── দৈনিক (Daily) ──
  DuaModel(
    id: 'dua_07',
    categoryBangla: 'খাবার শুরুর দোয়া',
    group: DuaCategory.daily,
    icon: Icons.restaurant_rounded,
    arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    bangla: 'আল্লাহর নামে এবং আল্লাহর বরকতে (শুরু করছি)।',
    reference: 'আবু দাউদ: ৩৭৬৭',
  ),
  DuaModel(
    id: 'dua_08',
    categoryBangla: 'খাবার শেষের দোয়া',
    group: DuaCategory.daily,
    icon: Icons.thumb_up_alt_rounded,
    arabic:
        'اَلْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
    bangla:
        'সকল প্রশংসা আল্লাহর জন্য, যিনি আমাদের খাওয়ালেন, পান করালেন এবং আমাদের মুসলিম বানালেন।',
    reference: 'আবু দাউদ: ৩৮৫০',
  ),
  DuaModel(
    id: 'dua_09',
    categoryBangla: 'ঘর থেকে বের হওয়ার দোয়া',
    group: DuaCategory.daily,
    icon: Icons.door_front_door_rounded,
    arabic:
        'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    bangla:
        'আল্লাহর নামে (বের হচ্ছি), আল্লাহর উপর ভরসা করলাম। আল্লাহর সাহায্য ছাড়া কোনো উপায় নেই, কোনো শক্তি নেই।',
    reference: 'আবু দাউদ: ৫০৯৫',
  ),
  DuaModel(
    id: 'dua_10',
    categoryBangla: 'ঘরে প্রবেশের দোয়া',
    group: DuaCategory.daily,
    icon: Icons.home_rounded,
    arabic:
        'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    bangla:
        'আল্লাহর নামে আমরা প্রবেশ করছি, আল্লাহর নামে বের হচ্ছি এবং আমাদের রবের উপর ভরসা করছি।',
    reference: 'আবু দাউদ: ৫০৯৬',
  ),
  DuaModel(
    id: 'dua_11',
    categoryBangla: 'মসজিদে প্রবেশের দোয়া',
    group: DuaCategory.daily,
    icon: Icons.mosque_rounded,
    arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    bangla: 'হে আল্লাহ! আমার জন্য আপনার রহমতের দরজাসমূহ খুলে দিন।',
    reference: 'সহীহ মুসলিম: ৭১৩',
  ),
  DuaModel(
    id: 'dua_12',
    categoryBangla: 'মসজিদ থেকে বের হওয়ার দোয়া',
    group: DuaCategory.daily,
    icon: Icons.mosque_outlined,
    arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    bangla: 'হে আল্লাহ! আমি আপনার অনুগ্রহ প্রার্থনা করছি।',
    reference: 'সহীহ মুসলিম: ৭১৩',
  ),
  DuaModel(
    id: 'dua_13',
    categoryBangla: 'বিপদের দোয়া',
    group: DuaCategory.daily,
    icon: Icons.healing_rounded,
    arabic:
        'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا',
    bangla:
        'নিশ্চয়ই আমরা আল্লাহর জন্য এবং তাঁর কাছেই ফিরে যাব। হে আল্লাহ! আমার বিপদে আমাকে সওয়াব দিন এবং এর চেয়ে উত্তম বিকল্প দান করুন।',
    reference: 'সহীহ মুসলিম: ৯১৮',
  ),
  DuaModel(
    id: 'dua_14',
    categoryBangla: 'ইস্তেখারার দোয়া',
    group: DuaCategory.daily,
    icon: Icons.help_outline_rounded,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ',
    bangla:
        'হে আল্লাহ! আমি আপনার জ্ঞানের মাধ্যমে আপনার কাছে কল্যাণ চাচ্ছি, আপনার কুদরতের মাধ্যমে শক্তি চাচ্ছি এবং আপনার মহান অনুগ্রহ চাচ্ছি।',
    reference: 'সহীহ বুখারী: ১১৬২',
  ),
  DuaModel(
    id: 'dua_15',
    categoryBangla: 'টয়লেটে প্রবেশের দোয়া',
    group: DuaCategory.daily,
    icon: Icons.water_rounded,
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    bangla:
        'হে আল্লাহ! আমি আপনার কাছে জিন পুরুষ ও জিন নারীদের অনিষ্ট থেকে আশ্রয় চাই।',
    reference: 'সহীহ বুখারী: ১৪২',
  ),
  DuaModel(
    id: 'dua_16',
    categoryBangla: 'অসুস্থ ব্যক্তির জন্য দোয়া',
    group: DuaCategory.daily,
    icon: Icons.local_hospital_rounded,
    arabic:
        'أَذْهِبِ الْبَأْسَ رَبَّ النَّاسِ اشْفِ وَأَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا',
    bangla:
        'হে মানুষের রব! কষ্ট দূর করুন, আরোগ্য দান করুন। আপনিই আরোগ্যদানকারী। আপনার আরোগ্য ছাড়া কোনো আরোগ্য নেই— এমন আরোগ্য দিন যা কোনো রোগ অবশিষ্ট রাখে না।',
    reference: 'সহীহ বুখারী: ৫৭৫০',
  ),

  // ── রমজান বিশেষ (Ramadan Special) ──
  DuaModel(
    id: 'dua_17',
    categoryBangla: 'সাহরীর দোয়া (রোজার নিয়ত)',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.wb_twilight_rounded,
    arabic:
        'وَبِصَوْمِ غَدٍ نَوَيْتُ مِنْ شَهْرِ رَمَضَانَ',
    bangla:
        'রমজান মাসের আগামীকালের রোজা রাখার নিয়ত করলাম।',
    reference: 'আবু দাউদ: ২৪৫৪',
  ),
  DuaModel(
    id: 'dua_18',
    categoryBangla: 'ইফতারের দোয়া',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.water_drop_rounded,
    arabic:
        'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
    bangla:
        'পিপাসা দূর হলো, শিরাগুলো সিক্ত হলো এবং ইনশাআল্লাহ সওয়াব নির্ধারিত হলো।',
    reference: 'আবু দাউদ: ২৩৫৭',
  ),
  DuaModel(
    id: 'dua_19',
    categoryBangla: 'লাইলাতুল কদরের দোয়া',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.nights_stay_rounded,
    arabic:
        'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
    bangla:
        'হে আল্লাহ! আপনি পরম ক্ষমাশীল, আপনি ক্ষমা করতে ভালোবাসেন, তাই আমাকে ক্ষমা করুন।',
    reference: 'তিরমিযী: ৩৫১৩',
    tasbihTarget: 100,
  ),
  DuaModel(
    id: 'dua_20',
    categoryBangla: 'তারাবীহর দোয়া (প্রতি ৪ রাকাত পর)',
    group: DuaCategory.ramadanSpecial,
    icon: Icons.mosque_rounded,
    arabic:
        'سُبْحَانَ ذِي الْمُلْكِ وَالْمَلَكُوتِ سُبْحَانَ ذِي الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ وَالْكِبْرِيَاءِ وَالْجَبَرُوتِ',
    bangla:
        'পবিত্র তিনি যিনি রাজত্ব ও মহারাজত্বের মালিক। পবিত্র তিনি যিনি সম্মান, মহত্ত্ব, প্রতাপ, শক্তি, বড়ত্ব ও পরাক্রমের মালিক।',
    reference: 'মুসান্নাফ ইবনে আবী শাইবা',
  ),

  // ── সফর (Travel) ──
  DuaModel(
    id: 'dua_21',
    categoryBangla: 'যাত্রার দোয়া',
    group: DuaCategory.travel,
    icon: Icons.flight_takeoff_rounded,
    arabic:
        'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
    bangla:
        'পবিত্র তিনি যিনি এটিকে আমাদের বশীভূত করে দিয়েছেন, আমরা একে বশীভূত করতে সক্ষম ছিলাম না। আর নিশ্চয়ই আমরা আমাদের রবের কাছে ফিরে যাব।',
    reference: 'সূরা যুখরুফ: ১৩-১৪',
  ),
  DuaModel(
    id: 'dua_22',
    categoryBangla: 'সফর থেকে ফেরার দোয়া',
    group: DuaCategory.travel,
    icon: Icons.flight_land_rounded,
    arabic:
        'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
    bangla:
        'আমরা প্রত্যাবর্তনকারী, তওবাকারী, ইবাদতকারী এবং আমাদের রবের প্রশংসাকারী।',
    reference: 'সহীহ মুসলিম: ১৩৪২',
  ),

  // ── ক্ষমা (Forgiveness) ──
  DuaModel(
    id: 'dua_23',
    categoryBangla: 'ক্ষমা প্রার্থনার দোয়া',
    group: DuaCategory.forgiveness,
    icon: Icons.spa_rounded,
    arabic:
        'أَسْتَغْفِرُ اللَّهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
    bangla:
        'আমি আল্লাহর কাছে ক্ষমা চাই, যিনি ছাড়া কোনো ইলাহ নেই, তিনি চিরঞ্জীব, সর্বসত্তার ধারক এবং আমি তাঁর কাছে তাওবা করছি।',
    reference: 'আবু দাউদ: ১৫১৭',
    tasbihTarget: 100,
  ),
  DuaModel(
    id: 'dua_24',
    categoryBangla: 'সাইয়্যিদুল ইস্তিগফার',
    group: DuaCategory.forgiveness,
    icon: Icons.auto_awesome_rounded,
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    bangla:
        'হে আল্লাহ! আপনি আমার রব, আপনি ছাড়া কোনো ইলাহ নেই। আপনি আমাকে সৃষ্টি করেছেন, আমি আপনার বান্দা। আমি যথাসাধ্য আপনার ওয়াদা ও প্রতিশ্রুতির উপর আছি। আমি আমার কৃতকর্মের অনিষ্ট থেকে আপনার কাছে আশ্রয় চাই। আমার প্রতি আপনার নিয়ামতের কথা স্বীকার করছি এবং আমার গুনাহের কথাও স্বীকার করছি। অতএব আমাকে ক্ষমা করুন, কেননা আপনি ছাড়া কেউ গুনাহ ক্ষমা করতে পারে না।',
    reference: 'সহীহ বুখারী: ৬৩০৬',
  ),
  DuaModel(
    id: 'dua_25',
    categoryBangla: 'সুবহানাল্লাহ',
    group: DuaCategory.forgiveness,
    icon: Icons.circle_outlined,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
    bangla:
        'আল্লাহ পবিত্র এবং তাঁর প্রশংসাসহ পবিত্র, মহান আল্লাহ পবিত্র।',
    reference: 'সহীহ বুখারী: ৬৬৮২',
    tasbihTarget: 33,
  ),
  DuaModel(
    id: 'dua_26',
    categoryBangla: 'সালাতের পর তাসবীহ',
    group: DuaCategory.forgiveness,
    icon: Icons.loop_rounded,
    arabic:
        'سُبْحَانَ اللَّهِ ٣٣ ، اَلْحَمْدُ لِلَّهِ ٣٣ ، اللَّهُ أَكْبَرُ ٣٤',
    bangla:
        'সুবহানাল্লাহ ৩৩ বার, আলহামদুলিল্লাহ ৩৩ বার, আল্লাহু আকবার ৩৪ বার।',
    reference: 'সহীহ মুসলিম: ৫৯৫',
    tasbihTarget: 100,
  ),
];
