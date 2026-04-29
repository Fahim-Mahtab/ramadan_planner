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
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final session = snapshot.data?.session;

        if (session == null) {
          // Signed out — reset flag so the ad shows again on next login.
          _adShown = false;
          return const LoginScreen();
        }

        // Authenticated — show ad once, then home.
        if (!_adShown) {
          return AdScreen(onDone: () => setState(() => _adShown = true));
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
