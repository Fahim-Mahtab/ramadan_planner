import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/ads_provider.dart';
import '../models/ad_model.dart';
import '../../../core/theme/app_colors.dart';

/// Displays a horizontally scrollable banner of active ads.
///
/// - Shows nothing when there are no active ads (zero height, no space)
/// - Tapping an ad opens [AdModel.redirectUrl] in the browser
/// - Updates in real-time when the admin changes ads in Supabase
class AdsBanner extends StatelessWidget {
  const AdsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (_, provider, _) {
        // Don't reserve any space if there's nothing to show.
        if (provider.isLoading) return const _LoadingBanner();
        if (!provider.hasAds) return const SizedBox.shrink();

        return _AdCarousel(ads: provider.ads);
      },
    );
  }
}

// ── Carousel ──────────────────────────────────────────────────────────────────

class _AdCarousel extends StatefulWidget {
  final List<AdModel> ads;
  const _AdCarousel({required this.ads});

  @override
  State<_AdCarousel> createState() => _AdCarouselState();
}

class _AdCarouselState extends State<_AdCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.ads.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return _AdCard(ad: widget.ads[index]);
            },
          ),
        ),

        // Dot indicators — only show when there's more than one ad.
        if (widget.ads.length > 1) ...[
          const SizedBox(height: 10),
          _DotIndicator(count: widget.ads.length, current: _currentPage),
        ],
      ],
    );
  }
}

// ── Single ad card ─────────────────────────────────────────────────────────────

class _AdCard extends StatelessWidget {
  final AdModel ad;
  const _AdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => _openUrl(ad.redirectUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Ad image
              ad.imageUrl.isNotEmpty
                  ? Image.network(
                      ad.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          _Placeholder(title: ad.title),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const _Placeholder(title: '');
                      },
                    )
                  : _Placeholder(title: ad.title),

              // Subtle gradient overlay at bottom for readability
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ad.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Ad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Dot indicator ──────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.slate300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, color: AppColors.slate400, size: 32),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(color: AppColors.slate500, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LoadingBanner extends StatelessWidget {
  const _LoadingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
