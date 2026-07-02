import 'package:flutter/material.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';

class MethodDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const MethodDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final methods = ['Karachi', 'Makkah', 'Egypt', 'ISNA'];

    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: AppLocale.format(AppLocale.calendarPdfMethod),
        labelStyle: TextStyle(
          color: isDark ? AppColors.slate400 : AppColors.slate500,
        ),
      ),
      items: methods.map((m) {
        return DropdownMenuItem(
          value: m,
          child: Text(m),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
