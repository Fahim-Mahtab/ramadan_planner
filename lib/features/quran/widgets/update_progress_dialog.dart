import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
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
        SnackBar(
          content: Text(AppLocale.format(AppLocale.quranUpdateSuccess)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocale.format(AppLocale.quranUpdateTitle)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _juzController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocale.format(AppLocale.quranCurrentJuzLabel),
                hintText: AppLocale.format(AppLocale.quranJuzHint),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocale.format(AppLocale.quranJuzRequired);
                }
                final juz = int.tryParse(value);
                if (juz == null || juz < 1 || juz > 30) {
                  return AppLocale.format(AppLocale.quranJuzInvalid);
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocale.format(AppLocale.quranCurrentPageLabel),
                hintText: AppLocale.format(AppLocale.quranPageHint),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocale.format(AppLocale.quranPageRequired);
                }
                final page = int.tryParse(value);
                if (page == null || page < 1 || page > 604) {
                  return AppLocale.format(AppLocale.quranPageInvalid);
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
          child: Text(AppLocale.format(AppLocale.settingsLogoutCancel)),
        ),
        ElevatedButton(
            onPressed: _saveProgress,
            child: Text(AppLocale.format(AppLocale.quranSave))),
      ],
    );
  }
}
