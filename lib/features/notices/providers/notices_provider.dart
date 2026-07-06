import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notice_model.dart';

/// Fetches notices from Supabase, listens for real-time changes,
/// and allows admins to publish/delete notices.
class NoticesProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<NoticeModel> _notices = [];
  bool _isLoading = false;
  String? _error;

  // Holds the active Realtime channel.
  RealtimeChannel? _channel;

  // ── Getters ──────────────────────────────────────────────────────────────

  List<NoticeModel> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasNotices => _notices.isNotEmpty;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  NoticesProvider() {
    _initRealtime();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  // ── Realtime subscription ─────────────────────────────────────────────────

  void _initRealtime() {
    _fetchNotices();

    _channel = _client
        .channel('public:notices')
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'notices',
          callback: (_) {
            // Re-fetch the full list whenever a notice changes.
            _fetchNotices();
          },
        )
        .subscribe();
  }

  // ── Data fetching ─────────────────────────────────────────────────────────

  Future<void> _fetchNotices() async {
    _setLoading(true);
    try {
      final data = await _client
          .from('notices')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      _notices = (data as List)
          .map((row) => NoticeModel.fromMap(row as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load notices.';
      debugPrint('NoticesProvider fetch error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() => _fetchNotices();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ── Publisher Actions (Admin) ─────────────────────────────────────────────

  Future<void> addNotice(NoticeModel notice) async {
    try {
      await _client.from('notices').insert(notice.toMap());
    } catch (e) {
      debugPrint('NoticesProvider add error: $e');
      rethrow;
    }
  }

  Future<void> deleteNotice(String id) async {
    try {
      await _client.from('notices').delete().eq('id', id);
    } catch (e) {
      debugPrint('NoticesProvider delete error: $e');
      rethrow;
    }
  }

  Future<void> fetchAllForAdmin() async {
    _setLoading(true);
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        _error = 'Unauthorized.';
        return;
      }

      bool isAdmin = false;
      try {
        final profileData = await _client
            .from('profiles')
            .select('role')
            .eq('id', currentUser.id)
            .maybeSingle();
        if (profileData != null) {
          final role = profileData['role'] as String?;
          isAdmin = role == 'admin' || role == 'imam';
        }
      } catch (_) {}

      if (!isAdmin) {
        _error = 'Unauthorized access to admin features.';
        return;
      }

      // Admins see BOTH active and inactive notices
      final data = await _client
          .from('notices')
          .select()
          .order('created_at', ascending: false);

      _notices = (data as List)
          .map((row) => NoticeModel.fromMap(row as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load all notices for admin.';
      debugPrint('NoticesProvider admin fetch error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleActiveStatus(String id, bool newStatus) async {
    try {
      await _client.from('notices').update({'is_active': newStatus}).eq('id', id);
    } catch (e) {
      debugPrint('NoticesProvider toggle error: $e');
      rethrow;
    }
  }
}
