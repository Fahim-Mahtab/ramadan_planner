import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hadith_model.dart';
class HadithProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  HadithModel? _todayHadith;
  bool _isLoading = false;
  String? _error;
  int? _lastFetchedDay;

  RealtimeChannel? _channel;

  HadithModel? get todayHadith => _todayHadith;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get lastFetchedDay => _lastFetchedDay;

  Future<void> fetchHadithForDay(int day) async {
    // Prevent duplicate fetches if already loaded (unless forced by realtime)
    if (_lastFetchedDay == day && _todayHadith != null) return;
    _lastFetchedDay = day;

    _setupRealtime();
    await _fetchCurrentDay();
  }

  void _setupRealtime() {
    if (_channel != null) return;
    _channel = _supabase
        .channel('public:last_ten_days_hadith')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'last_ten_days_hadith',
          callback: (_) {
            if (_lastFetchedDay != null) {
              _fetchCurrentDay();
            }
          },
        )
        .subscribe();
  }

  Future<void> _fetchCurrentDay() async {
    if (_lastFetchedDay == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('last_ten_days_hadith')
          .select()
          .eq('ramadan_day', _lastFetchedDay!)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        _todayHadith = HadithModel.fromJson(response);
      } else {
        _todayHadith = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}
