import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notices_provider.dart';
import 'notice_card.dart';
import '../../../../core/theme/app_colors.dart';

class NoticeBoardWidget extends StatelessWidget {
  const NoticeBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoticesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.notices.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!provider.hasNotices) {
          return const SizedBox.shrink(); // Hide if no notices
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Board Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Notice Board',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notices List
            ...provider.notices.map((notice) => NoticeCard(notice: notice)),
          ],
        );
      },
    );
  }
}
