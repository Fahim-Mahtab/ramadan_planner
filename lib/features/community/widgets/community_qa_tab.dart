import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/community_admin_provider.dart';
import '../providers/community_qa_provider.dart';
import 'qa_question_card.dart';

class CommunityQATab extends StatefulWidget {
  const CommunityQATab({super.key});

  @override
  State<CommunityQATab> createState() => _CommunityQATabState();
}

class _CommunityQATabState extends State<CommunityQATab> {
  String _searchQuery = '';
  String _filter = 'All'; // All, Pending, Solved
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
    // Refresh questions when tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityQAProvider>().refresh();
    });
  }

  Future<void> _checkAdmin() async {
    final admin = await context.read<CommunityAdminProvider>().isCurrentUserAdmin();
    if (mounted) setState(() => _isAdmin = admin);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () => _showAskQuestionDialog(context),
          backgroundColor: isDark ? AppColors.slate700 : AppColors.slate900,
          child: const Icon(Icons.add_comment_rounded, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // ── Search & Filter ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search questions...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: isDark ? AppColors.slate900 : AppColors.slate100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildFilterButton(context),
              ],
            ),
          ),

          // ── Questions List ────────────────────────────────────────────────
          Expanded(
            child: Consumer<CommunityQAProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.questions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.questions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        TextButton(
                          onPressed: provider.refresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                var filtered = provider.questions.where((q) {
                  final matchesSearch = q.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      q.question.toLowerCase().contains(_searchQuery.toLowerCase());
                  
                  bool matchesFilter = true;
                  if (_filter == 'Pending') matchesFilter = !q.isAnswered;
                  if (_filter == 'Solved') matchesFilter = q.isAnswered;

                  return matchesSearch && matchesFilter;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz_outlined, size: 64, color: AppColors.slate300),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No questions yet.' : 'No matches found.',
                          style: TextStyle(color: AppColors.slate500),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final qa = filtered[index];
                      return QAQuestionCard(
                        qa: qa,
                        isAdmin: _isAdmin,
                        onAnswerTap: () => _showAnswerDialog(context, qa.id),
                        onDeleteTap: () => _confirmDelete(context, qa.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() => _filter = v),
      initialValue: _filter,
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate900 : AppColors.slate100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.tune_rounded, size: 20, color: isDark ? Colors.white : AppColors.slate700),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'All', child: Text('All Questions')),
        const PopupMenuItem(value: 'Pending', child: Text('Pending Only')),
        const PopupMenuItem(value: 'Solved', child: Text('Solved Only')),
      ],
    );
  }

  void _showAskQuestionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask a Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title (Short summary)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: questionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Detail Question'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty || questionController.text.isEmpty) return;
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final success = await context.read<CommunityQAProvider>().askQuestion(
                titleController.text,
                questionController.text,
              );
              navigator.pop();
              if (success) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Question posted successfully!')),
                );
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _showAnswerDialog(BuildContext context, String questionId) {
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Provide Answer'),
        content: TextField(
          controller: answerController,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Type the solution here...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (answerController.text.isEmpty) return;
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final success = await context.read<CommunityQAProvider>().answerQuestion(
                questionId,
                answerController.text,
              );
              navigator.pop();
              if (success) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Answer posted!')),
                );
              }
            },
            child: const Text('Submit Answer'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await context.read<CommunityQAProvider>().deleteQuestion(id);
              navigator.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
