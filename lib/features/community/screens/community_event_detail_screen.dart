import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/community_comment_model.dart';
import '../models/community_event_model.dart';
import '../providers/community_admin_provider.dart';
import '../providers/event_detail_provider.dart';

class CommunityEventDetailScreen extends StatefulWidget {
  final CommunityEventModel event;
  const CommunityEventDetailScreen({super.key, required this.event});

  @override
  State<CommunityEventDetailScreen> createState() => _CommunityEventDetailScreenState();
}

class _CommunityEventDetailScreenState extends State<CommunityEventDetailScreen> {
  static const double _maxContentWidth = 800;
  final _commentController = TextEditingController();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final eventDetailProvider = context.read<EventDetailProvider>();
      final adminProvider = context.read<CommunityAdminProvider>();
      await eventDetailProvider.loadEventDetails(widget.event.id);
      final admin = await adminProvider.isCurrentUserAdmin();
      if (!mounted) return;
      setState(() => _isAdmin = admin);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<EventDetailProvider>();
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.slate900 : AppColors.slate50,
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              onPressed: () => _showAdminMenu(context),
            ),
        ],
      ),
      body: provider.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      children: [
                        _buildHeader(isDark),
                        const SizedBox(height: 24),
                        _buildMainContent(isDark, provider),
                        const SizedBox(height: 24),
                        _buildCommentSection(isDark, provider),
                        const SizedBox(height: 80), // Space for bottom input
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomSheet: _buildCommentInput(isDark),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildCategoryIcon(widget.event.categoryIcon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.categoryName?.toUpperCase() ?? 'EVENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(status: widget.event.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _MetaInfo(icon: Icons.calendar_today_rounded, label: DateFormat('EEEE, MMMM d').format(widget.event.eventDate!)),
            const SizedBox(width: 20),
            _MetaInfo(icon: Icons.access_time_rounded, label: widget.event.startTime ?? 'TBD'),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent(bool isDark, EventDetailProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About this event',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.event.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark ? AppColors.slate300 : AppColors.slate700,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              _buildOrganizerInfo(isDark),
            ],
          ),
        ),
        if (widget.event.donationEnabled) ...[
          const SizedBox(height: 16),
          _buildDonationTracker(isDark, provider),
        ],
        const SizedBox(height: 16),
        _buildReactions(isDark, provider),
      ],
    );
  }

  Widget _buildOrganizerInfo(bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.slate100,
          backgroundImage: widget.event.organizerPhoto != null 
              ? NetworkImage(widget.event.organizerPhoto!) 
              : null,
          child: widget.event.organizerPhoto == null 
              ? const Icon(Icons.person_outline, size: 24, color: AppColors.slate400)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organized by',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
              Text(
                widget.event.organizerName ?? 'Unknown Organizer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Contact'),
        ),
      ],
    );
  }

  Widget _buildDonationTracker(bool isDark, EventDetailProvider provider) {
    final summary = provider.donationSummary;
    final progress = widget.event.donationTarget > 0 
        ? (summary.totalDonations / widget.event.donationTarget).clamp(0.0, 1.0)
        : 0.0;

    return CustomCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Raised',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.slate500),
                  ),
                  Text(
                    '৳${summary.totalDonations.toInt()}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              if (widget.event.donationTarget > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Goal',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.slate500),
                    ),
                    Text(
                      '৳${widget.event.donationTarget.toInt()}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${(progress * 100).toInt()}% of the target reached',
            style: TextStyle(fontSize: 12, color: AppColors.slate500, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Contribute Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactions(bool isDark, EventDetailProvider provider) {
    return Row(
      children: [
        _ReactionPill(
          icon: Icons.favorite_rounded,
          activeIcon: Icons.favorite_rounded,
          label: 'Like',
          count: provider.reactions['like'] ?? 0,
          color: Colors.pink,
          onTap: () => provider.toggleReaction(eventRequestId: widget.event.id, reactionType: 'like'),
        ),
        const SizedBox(width: 12),
        _ReactionPill(
          icon: Icons.volunteer_activism_rounded,
          activeIcon: Icons.volunteer_activism_rounded,
          label: 'Support',
          count: provider.reactions['support'] ?? 0,
          color: Colors.orange,
          onTap: () => provider.toggleReaction(eventRequestId: widget.event.id, reactionType: 'support'),
        ),
      ],
    );
  }

  Widget _buildCommentSection(bool isDark, EventDetailProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments (${provider.comments.length})',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 16),
        if (provider.comments.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No comments yet. Be the first to say something!',
                style: TextStyle(color: AppColors.slate500),
              ),
            ),
          )
        else
          ...provider.comments.map((comment) => _CommentTile(comment: comment)),
      ],
    );
  }

  Widget _buildCommentInput(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        border: Border(top: BorderSide(color: isDark ? AppColors.slate700 : AppColors.slate300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                fillColor: isDark ? AppColors.slate900 : AppColors.slate100,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              final text = _commentController.text.trim();
              if (text.isEmpty) return;
              final ok = await context.read<EventDetailProvider>().addComment(
                    eventRequestId: widget.event.id,
                    comment: text,
                  );
              if (ok) {
                _commentController.clear();
                if (mounted) FocusScope.of(context).unfocus();
              }
            },
            icon: Icon(Icons.send_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String? iconData) {
    IconData icon;
    switch (iconData) {
      case 'mosque': icon = Icons.mosque_rounded; break;
      case 'menu_book': icon = Icons.menu_book_rounded; break;
      case 'volunteer_activism': icon = Icons.volunteer_activism_rounded; break;
      case 'favorite': icon = Icons.favorite_rounded; break;
      case 'nightlight': icon = Icons.nightlight_round; break;
      case 'mic': icon = Icons.mic_rounded; break;
      default: icon = Icons.event_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.slate800
            : AppColors.slate100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon, 
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white 
            : AppColors.slate900, 
        size: 28,
      ),
    );
  }

  void _showAdminMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2))),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Admin Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text('Approve Event'),
              onTap: () async {
                await context.read<CommunityAdminProvider>().approveEvent(widget.event.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined, color: Colors.red),
              title: const Text('Reject Event'),
              onTap: () async {
                await context.read<CommunityAdminProvider>().rejectEvent(widget.event.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined, color: Colors.orange),
              title: const Text('Reschedule Event'),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selected == null || !context.mounted) return;
                await context.read<CommunityAdminProvider>().rescheduleEvent(
                      eventRequestId: widget.event.id,
                      newDate: selected,
                    );
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 18, color: isDark ? AppColors.slate400 : AppColors.slate500),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w600, 
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _ReactionPill extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _ReactionPill({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommunityCommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.slate100,
            backgroundImage: comment.authorPhoto != null ? NetworkImage(comment.authorPhoto!) : null,
            child: comment.authorPhoto == null 
                ? const Icon(Icons.person_outline, size: 18, color: AppColors.slate400)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimeAgo(comment.createdAt),
                      style: TextStyle(color: AppColors.slate400, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: isDark ? AppColors.slate300 : AppColors.slate700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
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
