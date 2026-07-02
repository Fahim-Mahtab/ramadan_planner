import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/quran_lms_provider.dart';
import '../widgets/lecture_card.dart';
import 'lecture_player_screen.dart';

class QuranLmsScreen extends StatefulWidget {
  const QuranLmsScreen({super.key});

  @override
  State<QuranLmsScreen> createState() => _QuranLmsScreenState();
}

class _QuranLmsScreenState extends State<QuranLmsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranLmsProvider>().fetchLectures();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.lmsTitle),
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
      body: Consumer<QuranLmsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.refresh(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.lectures.isEmpty) {
            return Center(
              child: Text(
                AppLocale.format(AppLocale.lmsNoLectures),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.slate400 : AppColors.slate500,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.lectures.length,
              itemBuilder: (context, index) {
                final lecture = provider.lectures[index];
                return LectureCard(
                  lecture: lecture,
                  isCompleted: provider.isCompleted(lecture.id),
                  isInProgress: provider.isInProgress(lecture.id),
                  onTap: () {
                    provider.markInProgress(lecture.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LecturePlayerScreen(lecture: lecture),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
