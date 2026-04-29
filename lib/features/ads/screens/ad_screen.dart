import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ad_model.dart';
import '../providers/ads_provider.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen ad splash.
/// [onDone] is called when the user skips or countdown ends —
/// [AuthGate] swaps in [HomeScreen] without a Navigator push.
class AdScreen extends StatefulWidget {
  final VoidCallback onDone;
  const AdScreen({super.key, required this.onDone});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Countdown in seconds before auto-skip.
  static const int _countdownSeconds = 8;
  int _countdown = _countdownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Fetch freshest ads every time splash mounts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsProvider>().refresh();
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        _goHome();
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  void _goHome() {
    if (!mounted) return;
    widget.onDone(); // Tell AuthGate to show HomeScreen.
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
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
        // If no ads (or error) — skip directly to home without showing anything.
        if (!provider.isLoading && !provider.hasAds) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _goHome());
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return PopScope(
          // Prevent the back button from going to login.
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : _AdContent(
                    ads: provider.ads,
                    currentPage: _currentPage,
                    countdown: _countdown,
                    pageController: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    onSkip: _goHome,
                    onTap: (ad) => _openUrl(ad.redirectUrl),
                  ),
          ),
        );
      },
    );
  }
}

// ── Main content layout ────────────────────────────────────────────────────────

class _AdContent extends StatelessWidget {
  final List<AdModel> ads;
  final int currentPage;
  final int countdown;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onSkip;
  final ValueChanged<AdModel> onTap;

  const _AdContent({
    required this.ads,
    required this.currentPage,
    required this.countdown,
    required this.pageController,
    required this.onPageChanged,
    required this.onSkip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Stack(
      children: [
        // ── Full-screen paged ads ──────────────────────────────────────
        PageView.builder(
          controller: pageController,
          itemCount: ads.length,
          onPageChanged: onPageChanged,
          itemBuilder: (_, i) =>
              _FullscreenAdPage(ad: ads[i], onTap: () => onTap(ads[i])),
        ),

        // ── Top bar: app name + skip button ───────────────────────────
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32 : 20,
              vertical: 12,
            ),
            child: Row(
              children: [
                // App label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🌙', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Text(
                        'Ramadan Planner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Skip / countdown button
                GestureDetector(
                  onTap: onSkip,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Countdown ring
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value:
                                    countdown /
                                    _AdScreenState._countdownSeconds,
                                strokeWidth: 2,
                                color: AppColors.primary,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              Text(
                                '$countdown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

        // ── Dot indicators (for multiple ads) ─────────────────────────
        if (ads.length > 1)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(ads.length, (i) {
                final active = i == currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

// ── Single full-screen ad page ─────────────────────────────────────────────────

class _FullscreenAdPage extends StatelessWidget {
  final AdModel ad;
  final VoidCallback onTap;

  const _FullscreenAdPage({required this.ad, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Image ──
          ad.imageUrl.isNotEmpty
              ? Image.network(
                  ad.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _ImageError(),
                  loadingBuilder: (_, child, prog) {
                    if (prog == null) return child;
                    return const _ImageLoading();
                  },
                )
              : const _ImageError(),

          // ── Bottom Gradient & Info ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                60,
                20,
                MediaQuery.of(context).padding.bottom + 80, // Space for dots
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // AD badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'AD',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      ad.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Arrow button
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageLoading extends StatelessWidget {
  const _ImageLoading();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white38),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a2e),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white24, size: 64),
      ),
    );
  }
}
