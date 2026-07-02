import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/app_locale.dart';
import '../providers/ai_sunnah_provider.dart';

class AISunnahCarousel extends StatefulWidget {
  const AISunnahCarousel({super.key});

  @override
  State<AISunnahCarousel> createState() => _AISunnahCarouselState();
}

class _AISunnahCarouselState extends State<AISunnahCarousel> {
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && mounted) {
        final provider = context.read<AISunnahProvider>();
        if (provider.items.isNotEmpty) {
          int nextPage = _pageController.page!.round() + 1;
          if (nextPage >= provider.items.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage, 
            duration: const Duration(milliseconds: 600), 
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'en';
    final isEn = langCode == 'en';

    return Consumer<AISunnahProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(AppLocale.format(AppLocale.aiSunnahGenerating)),
                ],
              ),
            ),
          );
        }

        if (provider.error != null && provider.items.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Text(
                AppLocale.format(AppLocale.aiSunnahError),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (provider.items.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(child: Text(AppLocale.format(AppLocale.aiSunnahEmpty))),
          );
        }

        final completed = provider.completedCount;
        final total = provider.items.length;
        final progress = provider.totalProgress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.format(AppLocale.aiSunnahTitle),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(isDark ? 50 : 25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completed/$total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.emerald600 : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: isDark ? AppColors.slate800 : AppColors.slate200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1.0 ? AppColors.emerald600 : AppColors.primary,
                  ),
                  minHeight: 8,
                ),
              ),
            ),
            
            if (progress == 1.0)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                child: Text(
                  AppLocale.format(AppLocale.aiSunnahCompletedAll),
                  style: const TextStyle(color: AppColors.emerald600, fontWeight: FontWeight.w600),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Carousel
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final act = provider.items[index];
                  final title = isEn ? act.titleEn : act.titleBn;
                  final evidence = isEn ? act.evidenceEn : act.evidenceBn;

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                      }
                      
                      return Center(
                        child: SizedBox(
                          height: Curves.easeOut.transform(value) * 180,
                          width: double.infinity,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: act.isCompleted 
                            ? (isDark 
                                ? [AppColors.emerald800.withAlpha(200), AppColors.emerald900.withAlpha(200)] 
                                : [AppColors.emerald600, AppColors.emerald700])
                            : (isDark 
                                ? [AppColors.slate800, AppColors.slate900]
                                : [Colors.white, AppColors.slate50]),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: act.isCompleted
                                ? AppColors.emerald600.withAlpha(isDark ? 40 : 80)
                                : Colors.black.withAlpha(isDark ? 40 : 10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () => provider.toggleItem(index),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon/Checkbox area
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: act.isCompleted 
                                      ? Colors.white 
                                      : (isDark ? AppColors.slate700 : AppColors.slate200),
                                  border: Border.all(
                                    color: act.isCompleted ? Colors.white : AppColors.primary.withAlpha(100),
                                    width: 2,
                                  ),
                                ),
                                child: act.isCompleted 
                                    ? Icon(Icons.check_rounded, color: isDark ? AppColors.emerald800 : AppColors.emerald600, size: 20)
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              
                              // Text area
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: act.isCompleted
                                            ? Colors.white
                                            : (isDark ? Colors.white : AppColors.slate800),
                                        decoration: act.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: act.isCompleted 
                                            ? Colors.white.withAlpha(40)
                                            : AppColors.primary.withAlpha(20),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.auto_stories_rounded, 
                                            size: 12, 
                                            color: act.isCompleted ? Colors.white : AppColors.primary
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              evidence,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: act.isCompleted ? Colors.white : AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
