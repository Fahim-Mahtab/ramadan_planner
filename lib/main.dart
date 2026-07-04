import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/app_config.dart';
import 'core/l10n/app_locale.dart';
import 'core/theme/app_theme.dart';
import 'features/ads/providers/ads_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/auth_gate.dart';
import 'features/salah/providers/salah_provider.dart';
import 'features/salah/providers/prayer_times_provider.dart';
import 'features/quran/providers/quran_provider.dart';
import 'features/sunnah_checklist/providers/checklist_provider.dart';
import 'features/dua/providers/dua_provider.dart';
import 'features/asmaul_husna/providers/asmaul_husna_provider.dart';
import 'features/notices/providers/notices_provider.dart';
import 'features/hadith/providers/hadith_provider.dart';
import 'features/tasbih/providers/tasbih_provider.dart';
import 'features/fasting/providers/fasting_provider.dart';
import 'features/streaks/providers/streak_provider.dart';
import 'features/charity/providers/charity_provider.dart';
import 'features/quran_plan/providers/quran_plan_provider.dart';
import 'features/journal/providers/journal_provider.dart';
import 'features/mosque/providers/mosque_provider.dart';
import 'features/islamic_calendar/providers/islamic_calendar_provider.dart';
import 'features/community/providers/community_feed_provider.dart';
import 'features/community/providers/community_notification_provider.dart';
import 'features/community/providers/community_qa_provider.dart';
import 'features/community/providers/event_detail_provider.dart';
import 'features/community/providers/event_request_provider.dart';
import 'features/qibla/providers/qibla_provider.dart';
import 'features/zakat/providers/zakat_provider.dart';
import 'features/community/providers/ai_assistant_provider.dart';
import 'features/dua/providers/ai_dua_provider.dart';
import 'features/zakat/providers/ai_zakat_provider.dart';
import 'features/quran_plan/providers/ai_quran_plan_provider.dart';
import 'features/sunnah_checklist/providers/ai_sunnah_provider.dart';
import 'features/quran_lms/providers/quran_lms_provider.dart';
import 'features/book_store/providers/book_store_provider.dart';
import 'features/book_store/providers/order_provider.dart';
import 'features/services/providers/services_provider.dart';
import 'features/ramadan_calendar/providers/calendar_pdf_provider.dart';
import 'features/countdown/providers/countdown_provider.dart';
import 'shared/widgets/web_responsive_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  await FlutterLocalization.instance.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    _localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.eN),
        const MapLocale('bn', AppLocale.bN),
      ],
      initLanguageCode: 'bn',
    );
    _localization.onTranslatedLanguage = (_) => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdsProvider()),
        ChangeNotifierProvider(create: (_) => NoticesProvider()),
        ChangeNotifierProvider(create: (_) => SalahProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
        ChangeNotifierProvider(create: (_) => DuaProvider()),
        ChangeNotifierProvider(create: (_) => AsmaulHusnaProvider()),
        ChangeNotifierProvider(create: (_) => HadithProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider()),
        ChangeNotifierProvider(create: (_) => FastingProvider()),
        ChangeNotifierProvider(create: (_) => IslamicCalendarProvider()),
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => CharityProvider()),
        ChangeNotifierProvider(create: (_) => QuranPlanProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => MosqueProvider()),
        ChangeNotifierProvider(create: (_) => CommunityFeedProvider()),
        ChangeNotifierProvider(create: (_) => EventRequestProvider()),
        ChangeNotifierProvider(create: (_) => EventDetailProvider()),
        ChangeNotifierProvider(create: (_) => CommunityNotificationProvider()),
        ChangeNotifierProvider(create: (_) => CommunityQAProvider()),
        ChangeNotifierProvider(create: (_) => QiblaProvider()),
        ChangeNotifierProvider(create: (_) => ZakatProvider()),
        ChangeNotifierProvider(create: (_) => AIAssistantProvider()),
        ChangeNotifierProvider(create: (_) => AIDuaProvider()),
        ChangeNotifierProvider(create: (_) => AIZakatProvider()),
        ChangeNotifierProvider(create: (_) => AIQuranPlanProvider()),
        ChangeNotifierProvider(create: (_) => AISunnahProvider()),
        ChangeNotifierProvider(create: (_) => QuranLmsProvider()),
        ChangeNotifierProvider(create: (_) => BookStoreProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => CalendarPdfProvider()),
        ChangeNotifierProvider(create: (_) => CountdownProvider()),
      ],
      child: MaterialApp(
        title: 'Ramadan Planner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        locale: _localization.currentLocale,
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        builder: (context, child) =>
            WebResponsiveShell(child: child ?? const SizedBox.shrink()),
        home: const AuthGate(),
      ),
    );
  }
}
