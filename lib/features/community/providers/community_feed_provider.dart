import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_announcement_model.dart';
import '../models/community_event_model.dart';

class CommunityFeedProvider with ChangeNotifier {
  static const int _pageSize = 15;
  final _supabase = Supabase.instance.client;

  final List<CommunityEventModel> _events = [];
  final List<CommunityAnnouncementModel> _announcements = [];
  RealtimeChannel? _eventsChannel;
  RealtimeChannel? _announcementsChannel;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  List<CommunityEventModel> get events => _events;
  List<CommunityAnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  CommunityFeedProvider() {
    fetchInitial();
    _initializeRealtime();
  }

  void _initializeRealtime() {
    // Listen for Announcements
    _announcementsChannel = _supabase
        .channel('public:mosque_announcements')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'mosque_announcements',
          callback: (payload) {
            fetchInitial(); // Simple approach: refetch for now to maintain consistency
          },
        )
        .subscribe();

    // Listen for Events (status changes)
    _eventsChannel = _supabase
        .channel('public:event_requests')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'event_requests',
          callback: (payload) {
            fetchInitial(); // Refetch ensures complex joined data (categories/profiles) is fresh
          },
        )
        .subscribe();
  }

  Future<void> fetchInitial() async {
    _isLoading = true;
    _error = null;
    _hasMore = true;
    notifyListeners();

    try {
      // Fetch Announcements
      final announcementsData = await _supabase
          .from('mosque_announcements')
          .select()
          .order('created_at', ascending: false)
          .limit(5);

      _announcements.clear();
      _announcements.addAll(
        (announcementsData as List)
            .map((e) => CommunityAnnouncementModel.fromMap(e))
            .toList(),
      );

      // Fetch Events
      final eventsData = await _supabase
          .from('event_requests')
          .select('*, event_categories(*), profiles:profiles!event_requests_user_id_fkey(*)')
          .inFilter('status', ['approved', 'rescheduled', 'completed'])
          .order('requested_date', ascending: true)
          .range(0, _pageSize - 1);

      _events.clear();
      _events.addAll(
        (eventsData as List)
            .map((e) => CommunityEventModel.fromMap(e))
            .toList(),
      );

      _hasMore = _events.length >= _pageSize;
    } catch (e) {
      _error = 'Failed to load community feed.';
      debugPrint('CommunityFeedProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final start = _events.length;
      final end = start + _pageSize - 1;

      final eventsData = await _supabase
          .from('event_requests')
          .select('*, event_categories(*), profiles:profiles!event_requests_user_id_fkey(*)')
          .inFilter('status', ['approved', 'rescheduled', 'completed'])
          .order('requested_date', ascending: true)
          .range(start, end);

      final nextEvents = (eventsData as List)
          .map((e) => CommunityEventModel.fromMap(e))
          .toList();

      _events.addAll(nextEvents);
      _hasMore = nextEvents.length >= _pageSize;
    } catch (e) {
      debugPrint('CommunityFeedProvider loadMore error: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _eventsChannel?.unsubscribe();
    _announcementsChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> refresh() => fetchInitial();
}
