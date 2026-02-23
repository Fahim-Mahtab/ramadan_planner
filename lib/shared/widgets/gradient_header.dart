import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

/// Gradient header widget with Ramadan day info and countdown
class GradientHeader extends StatelessWidget {
  final int ramadanDay;
  final String profileImageUrl;

  /// Called when the user taps the logout button.
  final VoidCallback? onLogout;

  const GradientHeader({
    super.key,
    required this.ramadanDay,
    this.profileImageUrl = '',
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF10D460), // primary/90
            AppColors.emerald600,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Decorative mosque icon
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.mosque_outlined,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          // Decorative moon icon
          Positioned(
            bottom: -24,
            left: -24,
            child: Transform.rotate(
              angle: -0.2,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.bedtime_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with title and profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ramadan Day $ramadanDay',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Logout button in top-right part of header
                    if (onLogout != null) _LogoutIconButton(onTap: onLogout!),
                  ],
                ),
                const SizedBox(height: 24),
                // Countdown stats
                Row(
                  children: [
                    Expanded(
                      child: _CountdownCard(
                        label: 'Iftar In',
                        value: '04h 22m',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _CountdownCard(
                        label: 'Suhoor Ends',
                        value: '04:45 AM',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  final String label;
  final String value;

  const _CountdownCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Logout button shown in the gradient header's top-right corner.
class _LogoutIconButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_rounded, color: Colors.white, size: 16),
            SizedBox(width: 6),
            Text(
              'Log out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
