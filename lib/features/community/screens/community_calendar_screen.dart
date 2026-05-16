import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../models/community_event_model.dart';
import '../providers/community_feed_provider.dart';

class CommunityCalendarScreen extends StatelessWidget {
  static const double _maxContentWidth = 900;
  const CommunityCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityFeedProvider>(
      builder: (_, provider, _) {
        final approved = provider.events
            .where((e) => e.status == CommunityEventStatus.approved || e.status == CommunityEventStatus.rescheduled)
            .toList()
          ..sort((a, b) => (a.eventDate ?? DateTime(2100))
              .compareTo(b.eventDate ?? DateTime(2100)));

        if (approved.isEmpty) {
          return _buildEmptyState(context);
        }

        // Group by Month
        final groupedEvents = <String, List<CommunityEventModel>>{};
        for (final event in approved) {
          if (event.eventDate == null) continue;
          final monthKey = DateFormat('MMMM yyyy').format(event.eventDate!);
          groupedEvents.putIfAbsent(monthKey, () => []).add(event);
        }

        final sortedMonthKeys = groupedEvents.keys.toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 24.0 : 16.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    horizontalPadding,
                    horizontalPadding,
                    110,
                  ),
                  itemCount: sortedMonthKeys.length,
                  itemBuilder: (context, monthIndex) {
                    final monthKey = sortedMonthKeys[monthIndex];
                    final monthEvents = groupedEvents[monthKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MonthHeader(title: monthKey),
                        ...monthEvents.map((event) => _EventTimelineItem(event: event)),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: AppColors.slate300,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocale.format(AppLocale.communityNoApprovedEvents),
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final String title;
  const _MonthHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _EventTimelineItem extends StatelessWidget {
  final CommunityEventModel event;
  const _EventTimelineItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final isRescheduled = event.status == CommunityEventStatus.rescheduled;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator & Date
          Column(
            children: [
              _DateBadge(date: event.eventDate),
              Expanded(
                child: Container(
                  width: 2,
                  color: AppColors.slate300.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Event Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                          ),
                        ),
                        if (isRescheduled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.warning, width: 0.5),
                            ),
                            child: Text(
                              AppLocale.format(AppLocale.communityStatusRescheduled),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.slate400 : AppColors.slate600,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: [
                        _IconInfo(
                          icon: Icons.person_outline_rounded,
                          label: event.organizerName ?? '-',
                        ),
                        if (event.categoryName != null)
                          _IconInfo(
                            icon: Icons.category_outlined,
                            label: event.categoryName!,
                          ),
                        if (event.expectedAttendance > 0)
                          _IconInfo(
                            icon: Icons.people_outline_rounded,
                            label: '${event.expectedAttendance}',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final DateTime? date;
  const _DateBadge({this.date});

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    final month = DateFormat('MMM').format(date!).toUpperCase();
    final day = DateFormat('dd').format(date!);

    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              month,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.slate400 : AppColors.slate500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
