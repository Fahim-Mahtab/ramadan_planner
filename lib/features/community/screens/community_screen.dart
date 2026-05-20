import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../models/community_announcement_model.dart';
import '../models/community_event_model.dart';
import '../providers/community_feed_provider.dart';
import '../providers/community_notification_provider.dart';
import 'community_calendar_screen.dart';
import 'community_event_detail_screen.dart';
import 'create_event_request_screen.dart';
import '../widgets/community_qa_tab.dart';

class CommunityScreen extends StatefulWidget {
  static const double maxContentWidth = 900;
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

// Moved to CommunityScreen static constant

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final feedProvider = context.read<CommunityFeedProvider>();
      final notificationProvider = context.read<CommunityNotificationProvider>();
      await feedProvider.fetchInitial();
      await notificationProvider.fetchNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocale.format(AppLocale.communityTitle),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Consumer<CommunityNotificationProvider>(
            builder: (_, provider, _) {
              final unread = provider.unreadCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => _showNotifications(context),
                    icon: const Icon(Icons.notifications_none_rounded, size: 26),
                  ),
                  if (unread > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.tune_rounded, size: 24),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.slate900 : AppColors.slate100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: isDark ? AppColors.slate800 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              labelColor: isDark ? Colors.white : AppColors.slate900,
              unselectedLabelColor: AppColors.slate500,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: AppLocale.format(AppLocale.communityFeed)),
                Tab(text: AppLocale.format(AppLocale.communityCalendar)),
                Tab(text: AppLocale.format(AppLocale.communityQA)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: null,
      body: TabBarView(
        controller: _tabController,
        children: [
          const _CommunityFeedTab(),
          const CommunityCalendarScreen(),
          const CommunityQATab(),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    final items = context.read<CommunityNotificationProvider>().notifications;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: isDark ? AppColors.slate900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none_rounded,
                              size: 64, color: AppColors.slate300),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications yet',
                            style: TextStyle(color: AppColors.slate500),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final item = items[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isDark ? AppColors.slate800 : AppColors.slate100,
                            ),
                          ),
                          title: Text(
                            item['title']?.toString() ?? 'Notification',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(item['message']?.toString() ?? ''),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.info_outline_rounded,
                                color: AppColors.primary, size: 20),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityFeedTab extends StatelessWidget {
  const _CommunityFeedTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 380;

    return Consumer<CommunityFeedProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null && provider.events.isEmpty) {
          return Center(child: Text(provider.error ?? ''));
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton.extended(
              heroTag: 'feed_fab',
              onPressed: () {
                final auth = context.read<AuthProvider>();
                if (!auth.isLoggedIn) {
                  showAuthRequiredDialog(context, 'request an event');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateEventRequestScreen()),
                  );
                }
              },
              backgroundColor: isDark ? AppColors.slate700 : AppColors.slate900,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: compact
                  ? const SizedBox.shrink()
                  : Text(AppLocale.format(AppLocale.communityRequestEvent)),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: provider.refresh,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth >= 700 ? 24.0 : 16.0;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: CommunityScreen.maxContentWidth),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        horizontalPadding,
                        horizontalPadding,
                        110,
                      ),
                      children: [
                        if (provider.announcements.isNotEmpty) ...[
                          _SectionHeader(
                            title: AppLocale.format(AppLocale.communityAnnouncements),
                            icon: Icons.campaign_rounded,
                          ),
                          const SizedBox(height: 12),
                          ...provider.announcements.map(
                            (item) => _AnnouncementCard(announcement: item),
                          ),
                          const SizedBox(height: 24),
                        ],
                        _SectionHeader(
                          title: AppLocale.format(AppLocale.communityEvents),
                          icon: Icons.event_available_rounded,
                        ),
                        const SizedBox(height: 12),
                        ...provider.events.map(
                          (event) => _EventFeedCard(event: event),
                        ),
                        if (provider.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 20, color: isDark ? Colors.white70 : AppColors.slate800),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.slate900,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final CommunityAnnouncementModel announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Priority based styling
    Color priorityColor;
    String label;
    switch (announcement.priority.toLowerCase()) {
      case 'urgent':
        priorityColor = Colors.red.shade600;
        label = 'URGENT';
        break;
      case 'important':
        priorityColor = Colors.amber.shade700;
        label = 'IMPORTANT';
        break;
      default:
        priorityColor = isDark ? AppColors.slate700 : AppColors.slate900;
        label = 'BROADCAST';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(announcement.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.slate400 : AppColors.slate500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.2,
                letterSpacing: -0.2,
              ),
            ),
            if (announcement.description != null && announcement.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                announcement.description!,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDark ? AppColors.slate300 : AppColors.slate600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EventFeedCard extends StatelessWidget {
  final CommunityEventModel event;
  const _EventFeedCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityEventDetailScreen(event: event),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDark
                          ? AppColors.slate800
                          : AppColors.slate100,
                      child: Icon(
                        _getCategoryIcon(event.categoryName),
                        color: isDark ? Colors.white : AppColors.slate900,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                event.organizerName ?? 'Community',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              if (event.donationEnabled) ...[
                                const SizedBox(width: 8),
                                _FundraiserBadge(target: event.donationTarget),
                              ],
                            ],
                          ),
                          Text(
                            _formatEventTime(event.eventDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.slate400 : AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(status: event.status),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.slate300 : AppColors.slate700,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.slate800 : AppColors.slate100,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (event.categoryName != null)
                      _MetaTag(
                        label: event.categoryName!,
                        icon: Icons.label_outline_rounded,
                      ),
                    const Spacer(),
                    _InteractionItem(
                      icon: Icons.favorite_border_rounded,
                      count: event.status == CommunityEventStatus.approved ? '12' : '0',
                    ),
                    const SizedBox(width: 16),
                    const _InteractionItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      count: '0',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'iftar':
        return Icons.restaurant_rounded;
      case 'study':
        return Icons.menu_book_rounded;
      case 'charity':
        return Icons.volunteer_activism_rounded;
      case 'taraweeh':
        return Icons.nightlight_round;
      default:
        return Icons.event_rounded;
    }
  }
}

class _MetaTag extends StatelessWidget {
  final String label;
  final IconData icon;
  const _MetaTag({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : AppColors.slate100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.slate500),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionItem extends StatelessWidget {
  final IconData icon;
  final String count;
  const _InteractionItem({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.slate400),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.slate500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

String _formatTimeAgo(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 7) {
    return DateFormat('MMM d, y').format(date);
  } else if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}

String _formatEventTime(DateTime? date) {
  if (date == null) return '';
  return DateFormat('EEE, MMM d • h:mm a').format(date.toLocal());
}

class _StatusChip extends StatelessWidget {
  final CommunityEventStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (text, color) = switch (status) {
      CommunityEventStatus.approved => (
          AppLocale.format(AppLocale.communityStatusApproved),
          isDark ? Colors.white : Colors.black
        ),
      CommunityEventStatus.rejected => (
          AppLocale.format(AppLocale.communityStatusRejected),
          Colors.red
        ),
      CommunityEventStatus.rescheduled => (
          AppLocale.format(AppLocale.communityStatusRescheduled),
          Colors.orange
        ),
      CommunityEventStatus.completed => ('Completed', Colors.blue),
      CommunityEventStatus.cancelled => ('Cancelled', Colors.grey),
      _ => (AppLocale.format(AppLocale.communityStatusPending), isDark ? Colors.white : Colors.black),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FundraiserBadge extends StatelessWidget {
  final double target;
  const _FundraiserBadge({required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.volunteer_activism_rounded, size: 12, color: Colors.orange.shade800),
          const SizedBox(width: 4),
          Text(
            target > 0 ? '৳${target.toInt()}' : 'Donation',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

void showAuthRequiredDialog(BuildContext context, String actionText) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? AppColors.slate900 : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Account Required',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'You need to create an account or sign in to $actionText. It takes less than a minute!',
          style: TextStyle(
            color: isDark ? AppColors.slate300 : AppColors.slate700,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sign In / Register'),
          ),
        ],
      );
    },
  );
}
