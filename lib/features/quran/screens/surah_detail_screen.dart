import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/surah_info_model.dart';
import '../models/surah_detail_model.dart';
import '../providers/quran_provider.dart';
import '../widgets/ayah_list_tile.dart';

class SurahDetailScreen extends StatefulWidget {
  final SurahInfoModel surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late Future<SurahDetailModel?> _futureSurahDetail;

  @override
  void initState() {
    super.initState();
    _futureSurahDetail = context.read<QuranProvider>().loadSurahDetail(
      widget.surah.surahNo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surah.surahName), centerTitle: true),
      body: FutureBuilder<SurahDetailModel?>(
        future: _futureSurahDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load Surah details'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureSurahDetail = context
                            .read<QuranProvider>()
                            .loadSurahDetail(widget.surah.surahNo);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final detail = snapshot.data!;
          // Using bengali.length or arabic1.length to avoid out of bounds if they differ slightly
          // usually they should be exactly equal.
          final length = detail.arabic1.length;

          return ListView.builder(
            itemCount: length,
            itemBuilder: (context, index) {
              return AyahListTile(
                surahNo: detail.surahNo,
                ayahNo: index + 1,
                arabicText: detail.arabic1[index],

                // providing a fallback in case lists lengths differ due to API format issues
                bengaliText: index < detail.bengali.length
                    ? detail.bengali[index]
                    : '',
                audioUrl: detail.getVerseAudioUrl(index + 1),
              );
            },
          );
        },
      ),
    );
  }
}
