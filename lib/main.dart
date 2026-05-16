import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
import 'features/notices/providers/notices_provider.dart';
import 'features/asmaul_husna/providers/asmaul_husna_provider.dart';
import 'features/community/providers/community_admin_provider.dart';
import 'features/community/providers/community_feed_provider.dart';
import 'features/community/providers/community_notification_provider.dart';
import 'features/community/providers/event_detail_provider.dart';
import 'features/community/providers/event_request_provider.dart';
import 'shared/widgets/web_responsive_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
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
        ChangeNotifierProvider(create: (_) => CommunityFeedProvider()),
        ChangeNotifierProvider(create: (_) => EventRequestProvider()),
        ChangeNotifierProvider(create: (_) => EventDetailProvider()),
        ChangeNotifierProvider(create: (_) => CommunityAdminProvider()),
        ChangeNotifierProvider(create: (_) => CommunityNotificationProvider()),
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
