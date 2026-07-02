import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../community/providers/community_feed_provider.dart';
import '../../community/providers/community_notification_provider.dart';
import '../../community/providers/community_qa_provider.dart';
import '../../community/screens/community_screen.dart';

class CommunityHeroCard extends StatelessWidget {
  const CommunityHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Consumer3<CommunityFeedProvider, CommunityQAProvider,
        CommunityNotificationProvider>(
      builder: (context, feed, qa, notifications, _) {
        final eventCount = feed.events.length;
        final qaCount =
            qa.questions.where((q) => q.answer == null || q.answer!.isEmpty).length;
        final unreadNotifCount = notifications.unreadCount;
        final latestAnnouncement =
            feed.announcements.isNotEmpty ? feed.announcements.first.title : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CommunityScreen()),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.slate800, AppColors.slate900]
                      : [AppColors.primary.withValues(alpha: 0.08), AppColors.emerald600.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isDark
                      ? AppColors.emerald900.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.emerald900.withValues(alpha: 0.4)
                                : AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.mosque_rounded,
                            color: isDark ? AppColors.emerald600 : AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocale.format(AppLocale.homeCommunity),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  color: isDark ? Colors.white : AppColors.slate900,
                                ),
                              ),
                              Text(
                                AppLocale.format(AppLocale.communityTitle),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.slate400 : AppColors.slate500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: isDark ? AppColors.slate500 : AppColors.slate400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _StatItem(
                          icon: Icons.event_rounded,
                          count: '$eventCount',
                          label: AppLocale.format(AppLocale.communityEvents),
                        ),
                        const SizedBox(width: 24),
                        _StatItem(
                          icon: Icons.help_outline_rounded,
                          count: '$qaCount',
                          label: AppLocale.format(AppLocale.communityQA),
                        ),
                        const SizedBox(width: 24),
                        _StatItem(
                          icon: Icons.notifications_outlined,
                          count: '$unreadNotifCount',
                          label: AppLocale.format(AppLocale.communityNotifications),
                          highlight: unreadNotifCount > 0,
                        ),
                      ],
                    ),
                    if (latestAnnouncement != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.slate800
                              : AppColors.emerald600.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? AppColors.slate700
                                : AppColors.emerald600.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.campaign_rounded,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                latestAnnouncement,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.slate200 : AppColors.slate700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CommunityScreen()),
                        ),
                        icon: const Icon(Icons.explore_rounded, size: 18),
                        label: Text(AppLocale.format(AppLocale.communityExplore)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.emerald600 : AppColors.primary,
                          side: BorderSide(
                            color: isDark
                                ? AppColors.emerald800
                                : AppColors.primary.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final bool highlight;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.slate800
              : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: highlight
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: highlight
                      ? AppColors.primary
                      : (isDark ? AppColors.slate400 : AppColors.slate500),
                ),
                const SizedBox(width: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: highlight
                        ? AppColors.primary
                        : (isDark ? Colors.white : AppColors.slate900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.slate500 : AppColors.slate500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
