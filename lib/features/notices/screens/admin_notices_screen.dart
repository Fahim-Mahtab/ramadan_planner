import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../models/notice_model.dart';
import '../providers/notices_provider.dart';

class AdminNoticesScreen extends StatefulWidget {
  const AdminNoticesScreen({super.key});

  @override
  State<AdminNoticesScreen> createState() => _AdminNoticesScreenState();
}

class _AdminNoticesScreenState extends State<AdminNoticesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all notices including inactive ones for admin view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticesProvider>().fetchAllForAdmin();
    });
  }

  void _showAddNoticeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final imageUrlController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Publish New Notice'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: messageController,
                      decoration: const InputDecoration(labelText: 'Message (optional)'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(labelText: 'Image URL (optional)'),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Is Active'),
                      value: isActive,
                      onChanged: (val) => setState(() => isActive = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;
                    final provider = context.read<NoticesProvider>();
                    final newNotice = NoticeModel(
                      id: '', // Supabase will auto-generate
                      title: titleController.text.trim(),
                      message: messageController.text.trim().isEmpty ? null : messageController.text.trim(),
                      imageUrl: imageUrlController.text.trim().isEmpty ? null : imageUrlController.text.trim(),
                      isActive: isActive,
                      createdAt: DateTime.now(), // Will be overridden by DB
                    );
                    
                    try {
                      await provider.addNotice(newNotice);
                      if (context.mounted) Navigator.pop(context);
                      // Re-fetch after add
                      provider.fetchAllForAdmin();
                    } catch (e) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: const Text('Publish'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Publisher (Notices)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoticeDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Notice'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<NoticesProvider>(
        builder: (context, provider, _) {
           if (provider.isLoading && provider.notices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notices.isEmpty) {
            return const Center(child: Text('No notices found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notices.length,
            itemBuilder: (context, index) {
              final notice = provider.notices[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(notice.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notice.message ?? 'No message'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notice.isActive,
                        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) async {
                          await provider.toggleActiveStatus(notice.id, val);
                          provider.fetchAllForAdmin();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                           final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Notice?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                              ]
                            )
                           );

                           if (confirm == true) {
                              await provider.deleteNotice(notice.id);
                              provider.fetchAllForAdmin();
                           }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      )
    );
  }
}
