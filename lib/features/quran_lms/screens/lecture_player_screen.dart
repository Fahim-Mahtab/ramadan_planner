import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/quran_lecture_model.dart';
import '../providers/quran_lms_provider.dart';

class LecturePlayerScreen extends StatefulWidget {
  final QuranLectureModel lecture;

  const LecturePlayerScreen({super.key, required this.lecture});

  @override
  State<LecturePlayerScreen> createState() => _LecturePlayerScreenState();
}

class _LecturePlayerScreenState extends State<LecturePlayerScreen> {
  late YoutubePlayerController _controller;
  String? _videoId;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayer.convertUrlToId(widget.lecture.videoUrl);
    if (_videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      _controller.addListener(_onPlayerStateChange);
    }
  }

  void _onPlayerStateChange() {
    if (!_isPlayerReady && _controller.value.isReady) {
      setState(() => _isPlayerReady = true);
    }
  }

  @override
  void dispose() {
    if (_videoId != null) {
      _controller.removeListener(_onPlayerStateChange);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final provider = context.read<QuranLmsProvider>();
    final isCompleted = provider.isCompleted(widget.lecture.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lecture.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_videoId != null)
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: AppColors.primary,
                topActions: <Widget>[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.lecture.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 10),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                      playedColor: AppColors.primary,
                      handleColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RemainingDuration(),
                  PlaybackSpeedButton(),
                ],
              )
            else
              Container(
                height: 220,
                color: isDark ? AppColors.slate900 : AppColors.slate200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline_rounded, size: 64, color: AppColors.slate400),
                      const SizedBox(height: 8),
                      Text(
                        AppLocale.format(AppLocale.lmsWatch),
                        style: TextStyle(color: AppColors.slate400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lecture.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.slate800,
                    ),
                  ),
                  if (widget.lecture.date != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.slate400),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.lecture.date!.day}/${widget.lecture.date!.month}/${widget.lecture.date!.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.slate400 : AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.lecture.description != null && widget.lecture.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.lecture.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.slate300 : AppColors.slate600,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isCompleted
                          ? null
                          : () {
                              provider.markCompleted(widget.lecture.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocale.format(AppLocale.lmsCompleted)),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                      icon: Icon(isCompleted ? Icons.check_circle_rounded : Icons.check_rounded),
                      label: Text(
                        isCompleted
                            ? AppLocale.format(AppLocale.lmsCompleted)
                            : AppLocale.format(AppLocale.lmsProgress),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
