import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../widgets/surah_list_tile.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().loadSurahs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran'), centerTitle: true),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingSurahs && provider.surahs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.surahs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSurahs(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.surahs.isEmpty) {
            return const Center(child: Text('No Surahs found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: provider.surahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = provider.surahs[index];
              return SurahListTile(surah: surah);
            },
          );
        },
      ),
    );
  }
}
