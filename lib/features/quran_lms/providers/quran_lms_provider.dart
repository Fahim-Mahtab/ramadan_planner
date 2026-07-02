import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quran_lecture_model.dart';

class QuranLmsProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _lecturesChannel;

  List<QuranLectureModel> _lectures = [];
  bool _isLoading = false;
  String? _error;
  Set<int> _completedLectureIds = {};
  Set<int> _inProgressLectureIds = {};

  List<QuranLectureModel> get lectures => _lectures;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isCompleted(int lectureId) => _completedLectureIds.contains(lectureId);
  bool isInProgress(int lectureId) => _inProgressLectureIds.contains(lectureId);

  QuranLmsProvider() {
    _initProgress();
    fetchLectures();
    _initializeRealtime();
  }

  Future<void> _initProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getString('lms_completed_lectures');
    final inProgress = prefs.getString('lms_in_progress_lectures');
    if (completed != null) {
      _completedLectureIds = Set.from(json.decode(completed) as List).cast<int>();
    }
    if (inProgress != null) {
      _inProgressLectureIds = Set.from(json.decode(inProgress) as List).cast<int>();
    }
  }

  Future<void> _persistProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lms_completed_lectures', json.encode(_completedLectureIds.toList()));
    await prefs.setString('lms_in_progress_lectures', json.encode(_inProgressLectureIds.toList()));
  }

  void _initializeRealtime() {
    _lecturesChannel = _supabase
        .channel('public:quran_lectures')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'quran_lectures',
          callback: (_) => fetchLectures(),
        )
        .subscribe();
  }

  Future<void> fetchLectures() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabase
          .from('quran_lectures')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      _lectures = (data as List)
          .map((e) => QuranLectureModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = 'Failed to load lectures.';
      debugPrint('QuranLmsProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markInProgress(int lectureId) async {
    _inProgressLectureIds.add(lectureId);
    notifyListeners();
    await _persistProgress();
  }

  Future<void> markCompleted(int lectureId) async {
    _completedLectureIds.add(lectureId);
    _inProgressLectureIds.remove(lectureId);
    notifyListeners();
    await _persistProgress();
  }

  Future<void> refresh() => fetchLectures();

  @override
  void dispose() {
    _lecturesChannel?.unsubscribe();
    super.dispose();
  }
}
