import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRequestProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _supabase
          .from('event_categories')
          .select('id, name')
          .order('name');
      
      _categories = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _error = 'Failed to load categories: $e';
      debugPrint('EventRequestProvider categories error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRequest({
    required String title,
    required String description,
    required DateTime eventDate,
    required String categoryId,
    required bool donationEnabled,
    required int expectedAttendance,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase.from('event_requests').insert({
        'user_id': userId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'requested_date': eventDate.toIso8601String().split('T')[0],
        'start_time': '${eventDate.hour.toString().padLeft(2, '0')}:${eventDate.minute.toString().padLeft(2, '0')}:00',
        'end_time': '${eventDate.add(const Duration(hours: 2)).hour.toString().padLeft(2, '0')}:${eventDate.minute.toString().padLeft(2, '0')}:00', // Safely add 2 hours
        'expected_attendance': expectedAttendance,
        'donation_enabled': donationEnabled,
        'status': 'pending',
      });
      return true;
    } catch (e) {
      _error = 'Failed to submit request: $e';
      debugPrint('EventRequestProvider create error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
