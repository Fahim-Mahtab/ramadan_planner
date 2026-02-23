import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login_screen.dart';
import '../../ads/screens/ad_screen.dart';

/// Listens to Supabase auth state changes and routes the user:
///  - Authenticated   → [AdScreen] (which transitions to [HomeScreen])
///  - Unauthenticated → [LoginScreen]
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final session = snapshot.data?.session;

        if (session != null) {
          // Authenticated — show full-screen ad first, then home.
          return const AdScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

/// Shown while the auth state is being determined on startup.
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
