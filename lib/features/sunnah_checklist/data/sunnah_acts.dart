sealed class SunnahCategory {
  const SunnahCategory();
  String get labelEn;
  String get labelBn;
  String get key;
}

class MorningEvening extends SunnahCategory {
  const MorningEvening();
  @override String get labelEn => 'Morning & Evening';
  @override String get labelBn => 'সকাল ও সন্ধ্যা';
  @override String get key => 'morning_evening';
}

class EatingSleeping extends SunnahCategory {
  const EatingSleeping();
  @override String get labelEn => 'Eating & Sleeping';
  @override String get labelBn => 'খাওয়া ও ঘুম';
  @override String get key => 'eating_sleeping';
}

class MosqueWorship extends SunnahCategory {
  const MosqueWorship();
  @override String get labelEn => 'Mosque & Worship';
  @override String get labelBn => 'মসজিদ ও ইবাদাত';
  @override String get key => 'mosque_worship';
}

class Character extends SunnahCategory {
  const Character();
  @override String get labelEn => 'Character & Daily Life';
  @override String get labelBn => 'চরিত্র ও দৈনন্দিন';
  @override String get key => 'character';
}

class SunnahAct {
  final String key;
  final SunnahCategory category;
  final String titleEn;
  final String titleBn;
  final String evidence;

  const SunnahAct({
    required this.key,
    required this.category,
    required this.titleEn,
    required this.titleBn,
    required this.evidence,
  });
}

final List<SunnahAct> allSunnahActs = [
  SunnahAct(
    key: 'checklist_siwak',
    category: const MorningEvening(),
    titleEn: 'Use Siwak/Miswak upon waking',
    titleBn: 'ঘুম থেকে উঠে মিসওয়াক করা',
    evidence: 'Sahih Bukhari & Muslim',
  ),
  SunnahAct(
    key: 'checklist_fajr_sunnah',
    category: const MorningEvening(),
    titleEn: 'Pray 2 rak\'ah Sunnah before Fajr',
    titleBn: 'ফজরের সুন্নাত ২ রাকাত পড়া',
    evidence: 'Sahih Muslim',
  ),
  SunnahAct(
    key: 'checklist_ishraq',
    category: const MorningEvening(),
    titleEn: 'Pray Ishraq (after sunrise)',
    titleBn: 'ইশরাকের নামাজ পড়া (সূর্যোদয়ের পর)',
    evidence: 'Sahih Muslim',
  ),
  SunnahAct(
    key: 'checklist_morning_adhkar',
    category: const MorningEvening(),
    titleEn: 'Recite morning Adhkar',
    titleBn: 'সকালের আযকার পড়া',
    evidence: 'Quran 33:41-42',
  ),
  SunnahAct(
    key: 'checklist_evening_adhkar',
    category: const MorningEvening(),
    titleEn: 'Recite evening Adhkar',
    titleBn: 'সন্ধ্যার আযকার পড়া',
    evidence: 'Quran 33:41-42',
  ),
  SunnahAct(
    key: 'checklist_bismillah',
    category: const EatingSleeping(),
    titleEn: 'Say Bismillah before eating',
    titleBn: 'খাওয়ার আগে বিসমিল্লাহ বলা',
    evidence: 'Tirmidhi',
  ),
  SunnahAct(
    key: 'checklist_right_hand',
    category: const EatingSleeping(),
    titleEn: 'Eat and drink with right hand',
    titleBn: 'ডান হাতে খাওয়া ও পান করা',
    evidence: 'Sahih Muslim',
  ),
  SunnahAct(
    key: 'checklist_three_sips',
    category: const EatingSleeping(),
    titleEn: 'Drink water in 3 sips, sitting',
    titleBn: 'বসে ৩ নিঃশ্বাসে পানি পান করা',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_no_waste',
    category: const EatingSleeping(),
    titleEn: 'Don\'t waste food — lick the plate',
    titleBn: 'খাবার নষ্ট না করা — প্লেট চেটে খাওয়া',
    evidence: 'Sahih Muslim',
  ),
  SunnahAct(
    key: 'checklist_sleep_wudu',
    category: const EatingSleeping(),
    titleEn: 'Sleep with wudu',
    titleBn: 'ওযু করে ঘুমানো',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_sleep_position',
    category: const EatingSleeping(),
    titleEn: 'Sleep on right side',
    titleBn: 'ডান কাতে শোয়া',
    evidence: 'Sahih Bukhari & Muslim',
  ),
  SunnahAct(
    key: 'checklist_sleep_dua',
    category: const EatingSleeping(),
    titleEn: 'Read sleep duas (Ayat-ul-Kursi, 3 Quls)',
    titleBn: 'ঘুমের দোয়া পড়া (আয়াতুল কুরসি, ৩ কুল)',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_tahara',
    category: const MosqueWorship(),
    titleEn: 'Maintain constant wudu',
    titleBn: 'সর্বদা ওযু অবস্থায় থাকা',
    evidence: 'Sahih Muslim',
  ),
  SunnahAct(
    key: 'checklist_mosque_early',
    category: const MosqueWorship(),
    titleEn: 'Go to mosque before Adhan',
    titleBn: 'আযানের আগে মসজিদে যাওয়া',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_sunnah_rawatib',
    category: const MosqueWorship(),
    titleEn: 'Pray 12 rak\'ah Sunnah Rawatib daily',
    titleBn: 'দৈনিক ১২ রাকাত সুন্নাতে রাওয়াতিব পড়া',
    evidence: 'Tirmidhi',
  ),
  SunnahAct(
    key: 'checklist_duha',
    category: const MosqueWorship(),
    titleEn: 'Pray Duha (Ishraq/Chasht)',
    titleBn: 'দুহার নামাজ পড়া (ইশরাক/চাশত)',
    evidence: 'Sahih Muslim',
  ),
  SunnahAct(
    key: 'checklist_quran_daily',
    category: const MosqueWorship(),
    titleEn: 'Read Quran daily (even a few verses)',
    titleBn: 'প্রতিদিন কুরআন তেলাওয়াত করা',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_sadaqah',
    category: const Character(),
    titleEn: 'Give Sadaqah (charity) today',
    titleBn: 'আজ সদকা (দান) করা',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_salam',
    category: const Character(),
    titleEn: 'Initiate Salam to others',
    titleBn: 'অন্যদের প্রথমে সালাম দেওয়া',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_smile',
    category: const Character(),
    titleEn: 'Smile — it\'s charity',
    titleBn: 'হাসি — এটাও সদকা',
    evidence: 'Tirmidhi',
  ),
  SunnahAct(
    key: 'checklist_good_word',
    category: const Character(),
    titleEn: 'Speak good or remain silent',
    titleBn: 'ভালো কথা বলা অথবা চুপ থাকা',
    evidence: 'Sahih Bukhari & Muslim',
  ),
  SunnahAct(
    key: 'checklist_istighfar',
    category: const Character(),
    titleEn: 'Make Istighfar (seek forgiveness)',
    titleBn: 'ইস্তিগফার করা (ক্ষমা প্রার্থনা)',
    evidence: 'Sahih Bukhari',
  ),
  SunnahAct(
    key: 'checklist_dua_ummah',
    category: const Character(),
    titleEn: 'Make dua for the Ummah',
    titleBn: 'উম্মাহর জন্য দোয়া করা',
    evidence: 'Abu Dawood',
  ),
];
