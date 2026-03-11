import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AyahListTile extends StatefulWidget {
  final int surahNo;
  final int ayahNo;
  final String arabicText;
  final String bengaliText;
  final String audioUrl;

  const AyahListTile({
    super.key,
    required this.surahNo,
    required this.ayahNo,
    required this.arabicText,
    required this.bengaliText,
    required this.audioUrl,
  });

  @override
  State<AyahListTile> createState() => _AyahListTileState();
}

class _AyahListTileState extends State<AyahListTile> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.playing || state == PlayerState.stopped) {
            _isLoading = false;
          }
        });
      }
    });
    // For handling completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await _audioPlayer.play(UrlSource(widget.audioUrl));
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to play audio. Check internet connection.'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${widget.surahNo}:${widget.ayahNo}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: AppColors.primary,
                        size: 32,
                      ),
                onPressed: _isLoading ? null : _toggleAudio,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.arabicText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTheme.arabicTextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : AppColors.slate800,
            ).copyWith(height: 1.8),
          ),
          const SizedBox(height: 16),
          Text(
            widget.bengaliText,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.slate300 : AppColors.slate600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
