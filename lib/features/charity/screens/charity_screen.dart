import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/charity_record.dart';
import '../providers/charity_provider.dart';

class CharityScreen extends StatefulWidget {
  const CharityScreen({super.key});

  @override
  State<CharityScreen> createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharityProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.charityTitle),
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
      body: Consumer<CharityProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatsRow(provider: provider, isDark: isDark),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocale.format(AppLocale.charityHistory),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddDialog(context, provider),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(AppLocale.format(AppLocale.charityAdd)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (provider.records.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.card_giftcard_rounded, size: 48,
                            color: isDark ? AppColors.slate500 : AppColors.slate300),
                        const SizedBox(height: 12),
                        Text(
                          AppLocale.format(AppLocale.charityNoRecords),
                          style: TextStyle(
                            color: isDark ? AppColors.slate400 : AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () => _showAddDialog(context, provider),
                          child: Text(AppLocale.format(AppLocale.charityAddFirst)),
                        ),
                      ],
                    ),
                  )
                else
                  ...provider.records.map((r) => _CharityTile(record: r, isDark: isDark, provider: provider)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, CharityProvider provider) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    var category = CharityCategory.general;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.format(AppLocale.charityAddDonation),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.isDark ? Colors.white : AppColors.slate800,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocale.format(AppLocale.charityAmount),
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CharityCategory>(
                initialValue: category,
                decoration: InputDecoration(labelText: AppLocale.format(AppLocale.charityCategory)),
                items: CharityCategory.values.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.name[0].toUpperCase() + c.name.substring(1)),
                )).toList(),
                onChanged: (v) => setModalState(() => category = v ?? CharityCategory.general),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(labelText: AppLocale.format(AppLocale.charityNoteOptional)),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountCtrl.text);
                    if (amount == null || amount <= 0) return;
                    provider.addRecord(CharityRecord(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      amount: amount,
                      category: category,
                      note: noteCtrl.text,
                      date: DateTime.now(),
                    ));
                    Navigator.pop(ctx);
                  },
                  child: Text(AppLocale.format(AppLocale.charitySave)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final CharityProvider provider;
  final bool isDark;

  const _StatsRow({required this.provider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(
          label: AppLocale.format(AppLocale.charityThisMonth),
          value: '\$${provider.thisMonthTotal.toStringAsFixed(0)}',
          sub: '${provider.thisMonthCount} donations',
          color: AppColors.primary,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _StatBox(
          label: AppLocale.format(AppLocale.charityAllTime),
          value: '\$${provider.totalGiven.toStringAsFixed(0)}',
          sub: '${provider.records.length} total',
          color: AppColors.gold,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _StatBox(
          label: AppLocale.format(AppLocale.charityAvgDay),
          value: '\$${provider.averagePerDay.toStringAsFixed(1)}',
          sub: AppLocale.format(AppLocale.charityDailyAverage),
          color: AppColors.emerald600,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  final bool isDark;

  const _StatBox({required this.label, required this.value, required this.sub, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.slate800)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.slate400 : AppColors.slate500)),
            Text(sub, style: TextStyle(fontSize: 9, color: isDark ? AppColors.slate500 : AppColors.slate400)),
          ],
        ),
      ),
    );
  }
}

class _CharityTile extends StatelessWidget {
  final CharityRecord record;
  final bool isDark;
  final CharityProvider provider;

  const _CharityTile({required this.record, required this.isDark, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) => provider.deleteRecord(record.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.slate700 : AppColors.slate200),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), shape: BoxShape.circle),
              child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${record.amount.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.slate800)),
                  Text(record.note.isNotEmpty ? record.note : record.category.name,
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.slate400 : AppColors.slate500)),
                ],
              ),
            ),
            Text(
              '${record.date.month}/${record.date.day}',
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.slate500 : AppColors.slate400),
            ),
          ],
        ),
      ),
    );
  }
}
