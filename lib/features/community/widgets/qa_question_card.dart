import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/community_qa_model.dart';

class QAQuestionCard extends StatelessWidget {
  final CommunityQAModel qa;
  final bool isAdmin;
  final VoidCallback? onAnswerTap;
  final VoidCallback? onDeleteTap;

  const QAQuestionCard({
    super.key,
    required this.qa,
    this.isAdmin = false,
    this.onAnswerTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: User Info & Status ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: qa.userPhotoUrl != null
                      ? NetworkImage(qa.userPhotoUrl!)
                      : null,
                  child: qa.userPhotoUrl == null
                      ? const Icon(Icons.person_outline_rounded,
                          size: 20, color: AppColors.primary)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qa.userName ?? 'User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatDate(qa.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.slate400 : AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(isAnswered: qa.isAnswered),
              ],
            ),
          ),

          // ── Question Content ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qa.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  qa.question,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? AppColors.slate300 : AppColors.slate700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Answer Section (if exists) ────────────────────────────────────
          if (qa.isAnswered && qa.answer != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.emerald900.withValues(alpha: 0.1)
                    : AppColors.emerald50.withValues(alpha: 0.5),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.emerald900.withValues(alpha: 0.2)
                        : AppColors.emerald100,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 16, color: AppColors.emerald600),
                      const SizedBox(width: 8),
                      Text(
                        'Answered by ${qa.answeredByName ?? 'Admin'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    qa.answer!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? AppColors.slate200 : AppColors.slate900,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Footer: Admin Actions ─────────────────────────────────────────
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!qa.isAnswered)
                    TextButton.icon(
                      onPressed: onAnswerTap,
                      icon: const Icon(Icons.question_answer_rounded, size: 18),
                      label: const Text('Answer'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  TextButton.icon(
                    onPressed: onDeleteTap,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, h:mm a').format(date.toLocal());
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAnswered;
  const _StatusBadge({required this.isAnswered});

  @override
  Widget build(BuildContext context) {
    final color = isAnswered ? AppColors.emerald600 : AppColors.slate400;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAnswered ? Icons.check_circle_rounded : Icons.pending_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isAnswered ? 'SOLVED' : 'PENDING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
