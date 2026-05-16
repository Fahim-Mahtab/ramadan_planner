import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_comment_model.dart';
import '../models/community_donation_summary_model.dart';

class EventDetailProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  final List<CommunityCommentModel> _comments = [];
  CommunityDonationSummaryModel _donationSummary =
      const CommunityDonationSummaryModel(totalDonations: 0, totalExpenses: 0);
  Map<String, int> _reactions = {};
  bool _isLoading = false;
  String? _error;

  List<CommunityCommentModel> get comments => _comments;
  CommunityDonationSummaryModel get donationSummary => _donationSummary;
  Map<String, int> get reactions => _reactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEventDetails(String eventRequestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // 1. Load Comments
      final commentsData = await _supabase
          .from('event_comments')
          .select('*, profiles(full_name, avatar_url)')
          .eq('event_request_id', eventRequestId)
          .order('created_at', ascending: false);

      _comments.clear();
      _comments.addAll(
        (commentsData as List).map((e) => CommunityCommentModel.fromMap(e)).toList(),
      );

      // 2. Load Reactions Count
      final reactionsData = await _supabase
          .from('event_reactions')
          .select('reaction_type')
          .eq('event_request_id', eventRequestId);

      _reactions = {};
      for (var r in (reactionsData as List)) {
        final type = r['reaction_type'] as String;
        _reactions[type] = (_reactions[type] ?? 0) + 1;
      }

      // 3. Load Donation Summary
      final donationsData = await _supabase
          .from('donations')
          .select('amount')
          .eq('event_request_id', eventRequestId);
      
      final expensesData = await _supabase
          .from('donation_expenses')
          .select('amount')
          .eq('event_request_id', eventRequestId);

      double totalDonations = 0;
      for (var d in (donationsData as List)) {
        totalDonations += (d['amount'] as num).toDouble();
      }

      double totalExpenses = 0;
      for (var e in (expensesData as List)) {
        totalExpenses += (e['amount'] as num).toDouble();
      }

      _donationSummary = CommunityDonationSummaryModel(
        totalDonations: totalDonations,
        totalExpenses: totalExpenses,
      );

    } catch (e) {
      _error = 'Failed to load event details.';
      debugPrint('EventDetailProvider load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addComment({
    required String eventRequestId,
    required String comment,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      await _supabase.from('event_comments').insert({
        'event_request_id': eventRequestId,
        'user_id': user.id,
        'comment': comment.trim(),
      });
      await loadEventDetails(eventRequestId);
      return true;
    } catch (e) {
      _error = 'Failed to post comment.';
      debugPrint('EventDetailProvider addComment error: $e');
      return false;
    }
  }

  Future<void> toggleReaction({
    required String eventRequestId,
    required String reactionType,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Check if reaction already exists
      final existing = await _supabase
          .from('event_reactions')
          .select()
          .eq('event_request_id', eventRequestId)
          .eq('user_id', user.id)
          .eq('reaction_type', reactionType)
          .maybeSingle();

      if (existing != null) {
        // Remove it
        await _supabase
            .from('event_reactions')
            .delete()
            .eq('id', existing['id']);
      } else {
        // Add it
        await _supabase.from('event_reactions').insert({
          'event_request_id': eventRequestId,
          'user_id': user.id,
          'reaction_type': reactionType,
        });
      }
      await loadEventDetails(eventRequestId);
    } catch (e) {
      debugPrint('EventDetailProvider toggleReaction error: $e');
    }
  }
}
