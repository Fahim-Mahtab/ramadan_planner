import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_qa_model.dart';

class CommunityQAProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<CommunityQAModel> _questions = [];
  bool _isLoading = false;
  String? _error;

  List<CommunityQAModel> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CommunityQAProvider() {
    fetchQuestions();
    _subscribeToChanges();
  }

  void _subscribeToChanges() {
    _supabase
        .channel('public:community_qa')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'community_qa',
          callback: (payload) {
            fetchQuestions();
          },
        )
        .subscribe();
  }

  Future<void> fetchQuestions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabase
          .from('community_qa')
          .select('''
            *,
            user_profile:profiles!community_qa_user_id_fkey(*),
            admin_profile:profiles!community_qa_answered_by_fkey(*)
          ''')
          .order('created_at', ascending: false);

      _questions = (data as List)
          .map((e) => CommunityQAModel.fromMap(e))
          .toList();
    } catch (e) {
      _error = 'Failed to load Q&A. Please try again.';
      debugPrint('CommunityQAProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> askQuestion(String title, String question) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      await _supabase.from('community_qa').insert({
        'user_id': user.id,
        'title': title,
        'question': question,
      });
      await fetchQuestions(); // Manual refresh after post
      return true;
    } catch (e) {
      debugPrint('CommunityQAProvider askQuestion error: $e');
      return false;
    }
  }

  Future<bool> answerQuestion(String questionId, String answer) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      await _supabase.from('community_qa').update({
        'answer': answer,
        'is_answered': true,
        'answered_by': user.id,
        'answered_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', questionId);
      await fetchQuestions(); // Manual refresh after answer
      return true;
    } catch (e) {
      debugPrint('CommunityQAProvider answerQuestion error: $e');
      return false;
    }
  }

  Future<bool> deleteQuestion(String questionId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      // 1. Fetch the question to verify ownership
      final questionData = await _supabase
          .from('community_qa')
          .select('user_id')
          .eq('id', questionId)
          .maybeSingle();

      if (questionData == null) return false;
      final ownerId = questionData['user_id'] as String?;

      // 2. Check if user is the owner
      final isOwner = ownerId == currentUser.id;

      // 3. Check if user is admin/imam
      bool isAdmin = false;
      try {
        final profileData = await _supabase
            .from('profiles')
            .select('role')
            .eq('id', currentUser.id)
            .maybeSingle();
        if (profileData != null) {
          final role = profileData['role'] as String?;
          isAdmin = role == 'admin' || role == 'imam';
        }
      } catch (_) {}

      if (!isOwner && !isAdmin) {
        debugPrint('Unauthorized delete attempt: User ${currentUser.id} is not owner or admin.');
        return false;
      }

      await _supabase.from('community_qa').delete().eq('id', questionId);
      await fetchQuestions(); // Manual refresh after delete
      return true;
    } catch (e) {
      debugPrint('CommunityQAProvider deleteQuestion error: $e');
      return false;
    }
  }

  Future<void> refresh() => fetchQuestions();
}
