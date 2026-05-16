import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityNotificationProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  RealtimeChannel? _notificationChannel;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount =>
      _notifications.where((n) => n['is_read'] != true).length;

  CommunityNotificationProvider() {
    initialize();
  }

  Future<void> initialize() async {
    await fetchNotifications();
    _initializeRealtime();
  }

  void _initializeRealtime() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _notificationChannel = _supabase
        .channel('user_notifications_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            fetchNotifications();
          },
        )
        .subscribe();
  }

  Future<void> fetchNotifications() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();
    try {
      final data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(20);

      _notifications = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('CommunityNotificationProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      
      // Local update for immediate feedback
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['is_read'] = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Mark as read error: $e');
    }
  }

  @override
  void dispose() {
    _notificationChannel?.unsubscribe();
    super.dispose();
  }
}
