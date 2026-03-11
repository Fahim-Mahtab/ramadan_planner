import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/ads/providers/ads_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/auth_gate.dart';
import 'features/salah/providers/salah_provider.dart';
import 'features/quran/providers/quran_provider.dart';
import 'features/sunnah_checklist/providers/checklist_provider.dart';
import 'features/dua/providers/hadith_provider.dart';
import 'features/salah/providers/prayer_times_provider.dart';
import 'features/notes/providers/notes_provider.dart';
import 'features/notices/providers/notices_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Required before any async work before runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase once at app startup.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth provider — registered first so all screens can access it.
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Ads provider — uses Supabase Realtime for live updates.
        ChangeNotifierProvider(create: (_) => AdsProvider()),

        // Feature-specific providers.
        ChangeNotifierProvider(create: (_) => SalahProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider(prefs)),
        ChangeNotifierProvider(create: (_) => NoticesProvider()),
        ChangeNotifierProvider(create: (_) => HadithProvider()),
      ],
      child: MaterialApp(
        title: 'Ramadan Planner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,

        // AuthGate listens to the Supabase auth stream and routes to
        // LoginScreen or HomeScreen automatically.
        home: const AuthGate(),
      ),
    );
  }
}
