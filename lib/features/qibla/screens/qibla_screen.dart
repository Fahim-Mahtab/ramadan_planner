import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/qibla_provider.dart';
import '../widgets/bearing_display.dart';
import '../widgets/compass_painter.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QiblaProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.qiblaTitle),
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
      body: Consumer<QiblaProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    AppLocale.format(AppLocale.qiblaFindingLocation),
                    style: TextStyle(
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!provider.isCalibrated) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.near_me_disabled_rounded,
                    size: 64,
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocale.format(AppLocale.qiblaCalibratePrompt),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                ],
              ),
            );
          }

          final bearing = provider.direction?.bearing ?? 0;

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  AppLocale.format(AppLocale.qiblaAlignPrompt),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.slate400 : AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: CompassPainter(
                      bearing: bearing,
                      isDark: isDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const BearingDisplay(),
                const Spacer(),
                if (provider.position != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocale.format(AppLocale.qiblaLocation, replace: {'lat': provider.position!.latitude.toStringAsFixed(4), 'lng': provider.position!.longitude.toStringAsFixed(4)}),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.slate500 : AppColors.slate400,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
