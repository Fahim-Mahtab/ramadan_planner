import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';

/// Dialog for updating Quran reading progress
class UpdateProgressDialog extends StatefulWidget {
  const UpdateProgressDialog({super.key});

  @override
  State<UpdateProgressDialog> createState() => _UpdateProgressDialogState();
}

class _UpdateProgressDialogState extends State<UpdateProgressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _juzController = TextEditingController();
  final _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final quranProvider = context.read<QuranProvider>();
    _juzController.text = quranProvider.progress.currentJuz.toString();
    _pageController.text = quranProvider.progress.currentPage.toString();
  }

  @override
  void dispose() {
    _juzController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _saveProgress() {
    if (_formKey.currentState!.validate()) {
      final juz = int.parse(_juzController.text);
      final page = int.parse(_pageController.text);

      context.read<QuranProvider>().updateProgress(juz: juz, page: page);

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Quran Progress'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _juzController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Current Juz',
                hintText: 'Enter Juz number (1-30)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Juz number';
                }
                final juz = int.tryParse(value);
                if (juz == null || juz < 1 || juz > 30) {
                  return 'Juz must be between 1 and 30';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Current Page',
                hintText: 'Enter page number (1-604)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter page number';
                }
                final page = int.tryParse(value);
                if (page == null || page < 1 || page > 604) {
                  return 'Page must be between 1 and 604';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveProgress, child: const Text('Save')),
      ],
    );
  }
}
