import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ad_model.dart';

/// Fetches active ads from Supabase and listens for real-time changes.
///
/// Uses Supabase Realtime so the UI updates instantly when an admin
/// activates, deactivates, adds, or removes an ad — no restart needed.
class AdsProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<AdModel> _ads = [];
  bool _isLoading = false;
  String? _error;

  // Holds the active Realtime channel so we can unsubscribe on dispose.
  RealtimeChannel? _channel;

  // ── Getters ──────────────────────────────────────────────────────────────

  List<AdModel> get ads => _ads;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasAds => _ads.isNotEmpty;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  AdsProvider() {
    _initRealtime();
  }

  @override
  void dispose() {
    // Always unsubscribe from Realtime when the provider is removed.
    _channel?.unsubscribe();
    super.dispose();
  }

  // ── Realtime subscription ─────────────────────────────────────────────────

  /// Sets up a Supabase Realtime channel that watches the `ads` table.
  /// Any INSERT, UPDATE, or DELETE from the admin dashboard is reflected
  /// immediately in the app.
  void _initRealtime() {
    // Do initial fetch first.
    _fetchAds();

    _channel = _client
        .channel('public:ads')
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'ads',
          callback: (_) {
            // Re-fetch the full list whenever anything changes.
            // This is simpler and safer than patching the local list.
            _fetchAds();
          },
        )
        .subscribe();
  }

  // ── Data fetching ─────────────────────────────────────────────────────────

  Future<void> _fetchAds() async {
    _setLoading(true);
    try {
      final data = await _client
          .from('ads')
          .select()
          .eq('is_active', true) // RLS also enforces this server-side
          .order('created_at', ascending: false);

      _ads = (data as List)
          .map((row) => AdModel.fromMap(row as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load ads.';
      debugPrint('AdsProvider error: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
