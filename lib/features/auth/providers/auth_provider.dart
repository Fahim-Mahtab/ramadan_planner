import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Manages authentication state using Supabase.
///
/// Provides [signIn], [signUp], and [signOut] actions and exposes
/// [currentUser] / [isLoggedIn] for the rest of the app.
class AuthProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ──────────────────────────────────────────────────────────────

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // ── Auth actions ──────────────────────────────────────────────────────────

  /// Sign in with [email] and [password].
  /// Returns `true` on success, `false` on failure.
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);

    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      _setError(null);
      return true;
    } on AuthException catch (e) {
      _setError(_sanitizeAuthError(e.message));
      return false;
    } catch (_) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new account with [fullName], [phone], [password], and optional [email].
  /// Returns `true` when the account was created successfully.
  Future<bool> signUp({
    required String fullName,
    required String phone,
    required String password,
    String? email,
  }) async {
    _setLoading(true);

    try {
      final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
      final effectiveEmail = (email != null && email.trim().isNotEmpty)
          ? email.trim()
          : '$cleanPhone@phone.ramadanplanner.local';

      final response = await _client.auth.signUp(
        email: effectiveEmail,
        password: password,
        data: {
          'full_name': fullName.trim(),
          'phone': phone.trim(),
        },
      );

      // Supabase returns a session immediately if email confirmation is
      // disabled, or a user without a session when confirmation is required.
      if (response.user != null) {
        _setError(null);
        return true;
      }

      _setError('Registration failed. Please try again.');
      return false;
    } on AuthException catch (e) {
      _setError(_sanitizeAuthError(e.message));
      return false;
    } catch (_) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs the current user out of all devices.
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _client.auth.signOut();
      _setError(null);
    } on AuthException catch (e) {
      _setError(_sanitizeAuthError(e.message));
    } finally {
      _setLoading(false);
    }
  }

  /// Clears any displayed error message.
  void clearError() => _setError(null);

  // ── Private helpers ───────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Maps raw Supabase error messages to user-friendly, non-leaking strings.
  String _sanitizeAuthError(String raw) {
    final lower = raw.toLowerCase();

    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid email or password')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('user already registered') ||
        lower.contains('already registered')) {
      return 'An account with this email already exists.';
    }
    if (lower.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (lower.contains('network') || lower.contains('connection')) {
      return 'Network error. Please check your connection.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please confirm your email address before logging in.';
    }
    if (lower.contains('password')) {
      return 'Password must be at least 6 characters.';
    }

    // Default: return a generic message so internal details aren't leaked.
    return 'Something went wrong. Please try again.';
  }
}
