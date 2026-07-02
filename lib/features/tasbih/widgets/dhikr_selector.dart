import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../data/dhikr_list.dart';
import '../providers/tasbih_provider.dart';

class DhikrSelector extends StatelessWidget {
  const DhikrSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasbihProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allDhikr.length,
            itemBuilder: (context, index) {
              final dhikr = allDhikr[index];
              final isSelected = index == provider.selectedIndex;
              final isDark = context.isDark;

              return GestureDetector(
                onTap: () => provider.selectDhikr(index),
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withAlpha(25)
                        : (isDark ? AppColors.slate800 : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.slate700 : AppColors.slate200),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dhikr.transliteration,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.slate300 : AppColors.slate600),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dhikr.target}x',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.slate500 : AppColors.slate400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
