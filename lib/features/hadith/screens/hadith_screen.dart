import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/hadith_provider.dart';
import '../widgets/hadith_detail_tile.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hadith Collection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<HadithProvider>(
            builder: (context, provider, _) => TextButton.icon(
              onPressed: () => _showBookmarks(context),
              icon: Icon(
                Icons.bookmark,
                size: 18,
                color: provider.bookmarked.isNotEmpty
                    ? AppColors.primary
                    : (isDark ? AppColors.slate400 : AppColors.slate500),
              ),
              label: Text(
                '${provider.bookmarked.length}',
                style: TextStyle(
                  color: isDark ? AppColors.slate400 : AppColors.slate500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final hadithList = provider.all;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: hadithList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'Tap the bookmark icon to save your favorites',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.slate500 : AppColors.slate400,
                    ),
                  ),
                );
              }
              return HadithDetailTile(hadith: hadithList[index - 1]);
            },
          );
        },
      ),
    );
  }

  void _showBookmarks(BuildContext context) {
    final provider = context.read<HadithProvider>();
    final bookmarked = provider.all.where((h) => provider.isBookmarked(h.number)).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bookmarked Hadith',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.isDark ? Colors.white : AppColors.slate800,
              ),
            ),
            const SizedBox(height: 12),
            if (bookmarked.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No bookmarks yet',
                    style: TextStyle(
                      color: context.isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookmarked.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text('#${bookmarked[i].number}: ${bookmarked[i].textEn}'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
