import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notice_model.dart';

/// Fetches active notices from Supabase and listens for real-time changes.
class NoticesProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<NoticeModel> _notices = [];
  bool _isLoading = false;
  String? _error;

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
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notices',
          callback: (_) => _fetchNotices(),
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
      debugPrint('NoticesProvider error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() => _fetchNotices();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
