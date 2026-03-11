import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/ads_provider.dart';
import '../../../core/theme/app_colors.dart';

class HomeAdBanner extends StatefulWidget {
  const HomeAdBanner({super.key});

  @override
  State<HomeAdBanner> createState() => _HomeAdBannerState();
}

class _HomeAdBannerState extends State<HomeAdBanner> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, provider, _) {
        if (!provider.hasHomeAds) return const SizedBox.shrink();

        final ads = provider.homeAds;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Only For You',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: ads.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  return GestureDetector(
                    onTap: () => _openUrl(ad.redirectUrl),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF1e293b),
                        image: ad.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(ad.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: ad.imageUrl.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white24,
                                size: 40,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            if (ads.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(ads.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }
}
