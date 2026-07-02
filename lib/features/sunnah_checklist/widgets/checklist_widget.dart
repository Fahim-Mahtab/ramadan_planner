import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../data/sunnah_acts.dart';
import '../providers/checklist_provider.dart';
import 'category_progress.dart';
import 'sunnah_item_tile.dart';

class ChecklistWidget extends StatelessWidget {
  const ChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Consumer<ChecklistProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const CustomCard(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final completed = provider.completedCount;
        final total = provider.items.length;

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.format(AppLocale.checklistTitle),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$completed/$total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: provider.totalProgress,
                  backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    provider.totalProgress == 1.0
                        ? AppColors.primary
                        : AppColors.gold,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
              const CategoryProgress(category: MorningEvening()),
              const CategoryProgress(category: EatingSleeping()),
              const CategoryProgress(category: MosqueWorship()),
              const CategoryProgress(category: Character()),
              const Divider(height: 24),
              ..._buildItems(context, provider),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildItems(BuildContext context, ChecklistProvider provider) {
    final items = <Widget>[];
    final categories = [
      const MorningEvening(),
      const EatingSleeping(),
      const MosqueWorship(),
      const Character(),
    ];

    for (final cat in categories) {
      final catActs = allSunnahActs.where((a) => a.category.runtimeType == cat.runtimeType).toList();
      for (var i = 0; i < catActs.length; i++) {
        final act = catActs[i];
        final itemIndex = provider.items.indexWhere((item) => item.key == act.key);
        if (itemIndex == -1) continue;

        items.add(SunnahItemTile(
          act: act,
          isCompleted: provider.items[itemIndex].isCompleted,
          onTap: () => provider.toggleItem(itemIndex),
        ));
      }
    }

    return items;
  }
}
