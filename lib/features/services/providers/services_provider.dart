import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServicesProvider extends ChangeNotifier {
  final List<ServiceModel> _services = const [
    ServiceModel(
      title: 'servicesDailyPrayers',
      description: 'Five daily prayers in congregation led by our qualified imam.',
      icon: Icons.mosque_rounded,
      detail: 'All five daily prayers are offered in congregation at the mosque. '
          'Fajr, Dhuhr, Asr, Maghrib, and Isha prayers are led by our qualified imam. '
          'The mosque opens 15 minutes before each prayer time. Visitors and new '
          'community members are always welcome to join.',
    ),
    ServiceModel(
      title: 'servicesJummah',
      description: 'Weekly Friday congregational prayer with a short sermon.',
      icon: Icons.door_sliding_rounded,
      detail: 'Jummah prayer is held every Friday at 1:30 PM. The khutbah (sermon) '
          'covers relevant Islamic topics and community matters. Doors open at 12:45 PM. '
          'Please arrive early to ensure a seat and to perform Sunnah prayers before '
          'the khutbah begins.',
    ),
    ServiceModel(
      title: 'servicesQuranEducation',
      description: 'Quran reading, tajweed, and memorization classes for all ages.',
      icon: Icons.auto_stories_rounded,
      detail: 'We offer comprehensive Quran education programs for children and adults. '
          'Classes include Quran reading (Noorani Qaida), Tajweed rules, Hifdh '
          '(memorization), and Tafseer. Classes are held on Saturdays and Sundays. '
          'Private one-on-one sessions are also available upon request.',
    ),
    ServiceModel(
      title: 'servicesIslamicStudies',
      description: 'Classes on Fiqh, Aqeedah, Seerah, and Arabic language.',
      icon: Icons.lightbulb_rounded,
      detail: 'Our Islamic studies program covers Fiqh (jurisprudence), Aqeedah '
          '(creed), Seerah (life of the Prophet), Hadith studies, and Arabic language. '
          'Classes are structured for different skill levels from beginner to advanced. '
          'Weekly study circles are held after Isha prayer.',
    ),
    ServiceModel(
      title: 'servicesJanazah',
      description: 'Funeral prayer services and burial arrangements assistance.',
      icon: Icons.volunteer_activism_rounded,
      detail: 'The mosque provides complete Janazah (funeral) services for the '
          'community including Ghusl (washing), Kafan (shrouding), Janazah prayer, '
          'and burial arrangements. Our funeral committee is available 24/7 for '
          'emergencies. Please contact the mosque office for assistance.',
    ),
    ServiceModel(
      title: 'servicesEvents',
      description: 'Community gatherings, iftars, and Islamic holiday celebrations.',
      icon: Icons.people_rounded,
      detail: 'Throughout the year, the mosque hosts various community events including '
          'Ramadan iftar dinners, Eid celebrations, family picnics, and educational '
          'workshops. These events help strengthen community bonds and provide '
          'opportunities for spiritual growth and social connection.',
    ),
  ];

  List<ServiceModel> get services => _services;
}
