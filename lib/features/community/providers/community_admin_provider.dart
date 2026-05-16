import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_event_model.dart';

class CommunityAdminProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<CommunityEventModel> _pendingRequests = [];
  List<CommunityEventModel> _publishedEvents = [];
  bool _isLoading = false;
  String? _error;
  RealtimeChannel? _adminChannel;

  CommunityAdminProvider() {
    _initializeRealtime();
  }

  void _initializeRealtime() {
    _adminChannel = _supabase
        .channel('admin_pending_requests')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'event_requests',
          callback: (payload) {
            // Refetch when any change occurs in event_requests
            // (New request, status change, etc.)
            fetchPendingRequests();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _adminChannel?.unsubscribe();
    super.dispose();
  }

  List<CommunityEventModel> get pendingRequests => _pendingRequests;
  List<CommunityEventModel> get publishedEvents => _publishedEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> isCurrentUserAdmin() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', userId);
      
      if (response.isEmpty) return false;
      
      final role = response.first['role']?.toString().toLowerCase();
      return role == 'admin' || role == 'moderator' || role == 'imam';
    } catch (e) {
      debugPrint('Admin check error: $e');
      return false;
    }
  }

  Future<void> fetchPendingRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _supabase
          .from('event_requests')
          .select('*, event_categories(*), profiles:profiles!event_requests_user_id_fkey(*)')
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      _pendingRequests = (response as List)
          .map((m) => CommunityEventModel.fromMap(m as Map<String, dynamic>))
          .toList();

      // Also fetch published events for management
      final publishedResponse = await _supabase
          .from('event_requests')
          .select('*, event_categories(*), profiles:profiles!event_requests_user_id_fkey(*)')
          .inFilter('status', ['approved', 'rescheduled'])
          .order('requested_date', ascending: false)
          .limit(20);

      _publishedEvents = (publishedResponse as List)
          .map((m) => CommunityEventModel.fromMap(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = 'Failed to load requests: $e';
      debugPrint('CommunityAdminProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveEvent(String eventRequestId) async {
    final userId = _supabase.auth.currentUser?.id;
    await _updateRequestStatus(eventRequestId, 'approved', {
      'approved_by': userId,
      'approved_at': DateTime.now().toUtc().toIso8601String(),
    });
    // Remove from pending list locally
    _pendingRequests.removeWhere((e) => e.id == eventRequestId);
    notifyListeners();
  }

  Future<void> rejectEvent(String eventRequestId, {String? reason}) async {
    await _updateRequestStatus(eventRequestId, 'rejected', {
      'rejection_reason': reason,
    });
    _pendingRequests.removeWhere((e) => e.id == eventRequestId);
    notifyListeners();
  }

  Future<void> _updateRequestStatus(
    String eventRequestId, 
    String status, 
    Map<String, dynamic> extra
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _supabase
          .from('event_requests')
          .update({
            'status': status,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
            ...extra,
          })
          .eq('id', eventRequestId);
    } catch (e) {
      _error = 'Failed to update event status: $e';
      debugPrint('CommunityAdminProvider update status error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rescheduleEvent({
    required String eventRequestId,
    required DateTime newDate,
    String? reason,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final userId = _supabase.auth.currentUser?.id;
      
      // 1. Log reschedule
      await _supabase.from('event_reschedules').insert({
        'event_id': eventRequestId,
        'new_date': newDate.toIso8601String().split('T')[0],
        'reason': reason,
        'changed_by': userId,
      });

      // 2. Update request
      await _supabase.from('event_requests').update({
        'requested_date': newDate.toIso8601String().split('T')[0],
        'status': 'rescheduled',
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', eventRequestId);

      _pendingRequests.removeWhere((e) => e.id == eventRequestId);
    } catch (e) {
      _error = 'Failed to reschedule event: $e';
      debugPrint('CommunityAdminProvider reschedule error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAnnouncement({
    required String title,
    String? message,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final userId = _supabase.auth.currentUser?.id;
      await _supabase.from('mosque_announcements').insert({
        'title': title,
        'description': message,
        'created_by': userId,
      });
    } catch (e) {
      _error = 'Failed to create announcement: $e';
      debugPrint('CommunityAdminProvider announcement error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabase.from('event_requests').delete().eq('id', eventId);
      _publishedEvents.removeWhere((e) => e.id == eventId);
      _pendingRequests.removeWhere((e) => e.id == eventId);
    } catch (e) {
      debugPrint('Delete event error: $e');
      _error = 'Failed to delete event';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editEvent({
    required String eventId,
    required String title,
    required String description,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabase.from('event_requests').update({
        'title': title,
        'description': description,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', eventId);
      
      fetchPendingRequests(); // Refresh lists
    } catch (e) {
      debugPrint('Edit event error: $e');
      _error = 'Failed to update event';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
