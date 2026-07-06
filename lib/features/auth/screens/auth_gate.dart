import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login_screen.dart';
import '../../ads/screens/ad_screen.dart';
import '../../home/screens/home_screen.dart';

/// Root navigation gate — stays permanently in the widget tree so it can
/// always react to Supabase auth state changes (including sign-out).
///
/// Flow:
///   Not authenticated              → [LoginScreen]
///   Authenticated, ad not shown   → [AdScreen]  (calls onDone when done)
///   Authenticated, ad dismissed   → [HomeScreen]
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  /// Whether the ad splash has been shown for the current session.
  /// Resets automatically when the user signs out.
  bool _adShown = false;

  @override
  void initState() {
    super.initState();
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    if (!kIsWeb) return;
    try {
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('code')) {
        await Supabase.instance.client.auth.exchangeCodeForSession(
          uri.queryParameters['code']!,
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        // Show ad once per app run.
        if (!_adShown) {
          return AdScreen(onDone: () => setState(() => _adShown = true));
        }

        final isAuthenticated = snapshot.data?.session != null;
        if (isAuthenticated) {
          return const HomeScreen();
        }
        return const HomeScreen();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
