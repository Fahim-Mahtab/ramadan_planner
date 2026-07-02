import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/calendar_config.dart';
import '../providers/calendar_pdf_provider.dart';
import '../widgets/method_dropdown.dart';

class CalendarPdfScreen extends StatefulWidget {
  const CalendarPdfScreen({super.key});

  @override
  State<CalendarPdfScreen> createState() => _CalendarPdfScreenState();
}

class _CalendarPdfScreenState extends State<CalendarPdfScreen> {
  final _cityController = TextEditingController(text: 'Dhaka');
  String _language = 'en';
  String _timeFormat = '12h';
  String _calculationMethod = 'Karachi';

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.calendarPdfTitle),
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
      body: Consumer<CalendarPdfProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              children: [
                _buildConfigSection(context, isDark),
                const SizedBox(height: 16),
                if (provider.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Generating calendar...'),
                      ],
                    ),
                  ),
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      '${AppLocale.format(AppLocale.calendarPdfError)}: ${provider.error}',
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (provider.pdfBytes != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 400,
                    child: PdfPreview(
                      build: (format) async => provider.pdfBytes!,
                      maxPageWidth: 400,
                      canChangeOrientation: false,
                      canChangePageFormat: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => provider.sharePdf(),
                      icon: const Icon(Icons.share_rounded),
                      label: Text(
                        AppLocale.format(AppLocale.calendarPdfShare),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfigSection(BuildContext context, bool isDark) {
    final provider = context.read<CalendarPdfProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: AppLocale.format(AppLocale.calendarPdfCity),
              prefixIcon: const Icon(Icons.location_city_rounded),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocale.format(AppLocale.calendarPdfLanguage),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _ToggleChips(
                      options: const ['en', 'bn'],
                      labels: const ['English', 'বাংলা'],
                      selected: _language,
                      onSelected: (v) => setState(() => _language = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocale.format(AppLocale.calendarPdfTimeFormat),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _ToggleChips(
                      options: const ['12h', '24h'],
                      labels: const ['12h', '24h'],
                      selected: _timeFormat,
                      onSelected: (v) => setState(() => _timeFormat = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MethodDropdown(
            value: _calculationMethod,
            onChanged: (v) {
              if (v != null) setState(() => _calculationMethod = v);
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: provider.isLoading
                  ? null
                  : () {
                      final config = CalendarConfig(
                        city: _cityController.text.trim().isEmpty
                            ? 'Dhaka'
                            : _cityController.text.trim(),
                        language: _language,
                        timeFormat: _timeFormat,
                        calculationMethod: _calculationMethod,
                      );
                      provider.generatePdf(config);
                    },
              icon: provider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.picture_as_pdf_rounded),
              label: Text(
                provider.isLoading
                    ? AppLocale.format(AppLocale.calendarPdfGenerating)
                    : AppLocale.format(AppLocale.calendarPdfGenerate),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleChips extends StatelessWidget {
  final List<String> options;
  final List<String> labels;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ToggleChips({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = selected == options[i];
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(options[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.slate300,
                ),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : null,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
