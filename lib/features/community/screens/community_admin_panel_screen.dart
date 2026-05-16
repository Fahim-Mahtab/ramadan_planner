import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/community_admin_provider.dart';
import '../models/community_event_model.dart';
import '../../../shared/widgets/custom_card.dart';

class CommunityAdminPanelScreen extends StatefulWidget {
  const CommunityAdminPanelScreen({super.key});

  @override
  State<CommunityAdminPanelScreen> createState() => _CommunityAdminPanelScreenState();
}

class _CommunityAdminPanelScreenState extends State<CommunityAdminPanelScreen> {
  static const double _maxContentWidth = 760;
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityAdminProvider>().fetchPendingRequests();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityAdminProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 700 ? 24.0 : 16.0;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: RefreshIndicator(
              onRefresh: provider.fetchPendingRequests,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  horizontalPadding,
                  horizontalPadding,
                  110,
                ),
                children: [
                  // --- Pending Requests Section ---
                  Text(
                    'Pending Event Requests',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (provider.pendingRequests.isEmpty && !provider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'No pending requests at the moment.',
                          style: TextStyle(color: AppColors.slate500),
                        ),
                      ),
                    ),
                  ...provider.pendingRequests.map((request) => _PendingRequestCard(request: request)),
                  
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),

                  // --- Announcements Section ---
                  Text(
                    AppLocale.format(AppLocale.communityAdminAnnouncements),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: AppLocale.format(AppLocale.communityAnnouncementTitle),
                      filled: true,
                      fillColor: isDark ? AppColors.slate800 : AppColors.slate50,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: AppLocale.format(AppLocale.communityAnnouncementMessage),
                      filled: true,
                      fillColor: isDark ? AppColors.slate800 : AppColors.slate50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (_titleController.text.trim().isEmpty) return;
                              await context.read<CommunityAdminProvider>().createAnnouncement(
                                    title: _titleController.text,
                                    message: _messageController.text,
                                  );
                              if (!context.mounted) return;
                              _titleController.clear();
                              _messageController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocale.format(AppLocale.communityAnnouncementCreated),
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.slate900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(AppLocale.format(AppLocale.communityCreateAnnouncement)),
                    ),
                  ),

                  const SizedBox(height: 48),
                  const Divider(),
                  const SizedBox(height: 24),

                  // --- Manage Published Events Section ---
                  Text(
                    'Manage Published Events',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (provider.publishedEvents.isEmpty && !provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('No published events found.')),
                    ),
                  ...provider.publishedEvents.map((event) => _ManagedEventCard(event: event)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  final CommunityEventModel request;

  const _PendingRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.slate100,
                backgroundImage: request.organizerPhoto != null ? NetworkImage(request.organizerPhoto!) : null,
                child: request.organizerPhoto == null ? const Icon(Icons.person_outline, size: 18) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.organizerName ?? 'Unknown User',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Requested on ${request.createdAt?.toLocal().toString().split(' ').first}',
                      style: TextStyle(color: AppColors.slate500, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            request.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            request.description,
            style: TextStyle(color: AppColors.slate600, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(icon: Icons.calendar_today_outlined, label: request.eventDate?.toLocal().toString().split(' ').first ?? ''),
              const SizedBox(width: 8),
              _InfoChip(icon: Icons.people_outline, label: '${request.expectedAttendance} expected'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.read<CommunityAdminProvider>().rejectEvent(request.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<CommunityAdminProvider>().approveEvent(request.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.slate900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.slate500),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.slate600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ManagedEventCard extends StatelessWidget {
  final CommunityEventModel event;

  const _ManagedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  event.description,
                  style: TextStyle(color: AppColors.slate500, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _showEditDialog(context),
            color: AppColors.slate500,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: () => _showDeleteConfirm(context),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: event.title);
    final descController = TextEditingController(text: event.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CommunityAdminProvider>().editEvent(
                    eventId: event.id,
                    title: titleController.text,
                    description: descController.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CommunityAdminProvider>().deleteEvent(event.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
