import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import '../widgets/journal_entry_tile.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.journalTitle),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          heroTag: 'journal_fab',
          onPressed: () => _showEntryDialog(context, null),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      body: Consumer<JournalProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_stories_rounded, size: 64,
                        color: isDark ? AppColors.slate500 : AppColors.slate300),
                    const SizedBox(height: 16),
                    Text(
                      AppLocale.format(AppLocale.journalSubtitle),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocale.format(AppLocale.journalNoEntries),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showEntryDialog(context, null),
                      icon: const Icon(Icons.edit_rounded),
                      label: Text(AppLocale.format(AppLocale.journalWriteFirst)),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      '${provider.totalEntries} ${AppLocale.format(AppLocale.duaCountSuffix)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppLocale.format(AppLocale.journalTapToAdd),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];
                    return JournalEntryTile(
                      entry: entry,
                      isDark: isDark,
                      onTap: () => _showEntryDialog(context, entry),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEntryDialog(BuildContext context, JournalEntry? existing) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final contentCtrl = TextEditingController(text: existing?.content ?? '');
    final tagsStr = existing?.tags.join(', ') ?? '';
    final tagsCtrl = TextEditingController(text: tagsStr);
    final isEditing = existing != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? AppLocale.format(AppLocale.journalEditEntry) : AppLocale.format(AppLocale.journalNewEntry),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.isDark ? Colors.white : AppColors.slate800,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(labelText: AppLocale.format(AppLocale.journalTitleLabel)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              decoration: InputDecoration(
                labelText: AppLocale.format(AppLocale.journalReflectionLabel),
                hintText: 'How was your day? Any duas answered? Goals for tomorrow?',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagsCtrl,
              decoration: InputDecoration(
                labelText: AppLocale.format(AppLocale.journalTagsLabel),
                hintText: 'dua, reflection, goal, gratitude (comma separated)',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final provider = context.read<JournalProvider>();
                  final tags = tagsCtrl.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();

                  if (isEditing) {
                    provider.updateEntry(existing.copyWith(
                      title: titleCtrl.text.trim(),
                      content: contentCtrl.text.trim(),
                      tags: tags,
                    ));
                  } else {
                    provider.addEntry(JournalEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: DateTime.now(),
                      title: titleCtrl.text.trim(),
                      content: contentCtrl.text.trim(),
                      tags: tags,
                    ));
                  }
                  Navigator.pop(ctx);
                },
                child: Text(isEditing ? AppLocale.format(AppLocale.journalUpdate) : AppLocale.format(AppLocale.journalSave)),
              ),
            ),
            if (isEditing) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.read<JournalProvider>().deleteEntry(existing.id);
                    Navigator.pop(ctx);
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: Text(AppLocale.format(AppLocale.journalDelete)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
