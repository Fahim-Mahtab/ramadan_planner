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

Future<void> main() async {
  // Required before any async work before runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase once at app startup.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
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
