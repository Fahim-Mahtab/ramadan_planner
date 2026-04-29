import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/notices_provider.dart';

/// A widget that displays live notices to the user.
/// Usually placed prominently on the HomeScreen.
class NoticeBoardWidget extends StatelessWidget {
  const NoticeBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoticesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.notices.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.notices.isEmpty) {
          // Hide if there are no live notices
          return const SizedBox.shrink();
        }

        // Display a PageView/Carousel for multiple notices
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Live Notice Board',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: PageView.builder(
                itemCount: provider.notices.length,
                itemBuilder: (context, index) {
                  final notice = provider.notices[index];
                  return GestureDetector(
                    onTap: () {
                      // Provide a visual tap effect, could show full screen dialog
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primary.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Optional image background
                          if (notice.imageUrl != null &&
                              notice.imageUrl!.isNotEmpty)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Opacity(
                                  opacity: 0.15,
                                  child: Image.network(
                                    notice.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notice.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'NEW',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    notice.message ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
