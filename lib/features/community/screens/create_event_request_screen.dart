import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_locale.dart';
import '../providers/event_request_provider.dart';

class CreateEventRequestScreen extends StatefulWidget {
  const CreateEventRequestScreen({super.key});

  @override
  State<CreateEventRequestScreen> createState() => _CreateEventRequestScreenState();
}

class _CreateEventRequestScreenState extends State<CreateEventRequestScreen> {
  static const double _maxContentWidth = 760;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _attendanceController = TextEditingController(text: '50');
  String? _categoryId;
  DateTime? _dateTime;
  bool _donationEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventRequestProvider>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _attendanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventRequestProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocale.format(AppLocale.communityRequestEvent))),
      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 24.0 : 16.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                horizontalPadding,
                horizontalPadding,
                32,
              ),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: AppLocale.format(AppLocale.communityEventTitle),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppLocale.format(AppLocale.communityValidationRequired)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: AppLocale.format(AppLocale.communityEventDescription),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppLocale.format(AppLocale.communityValidationRequired)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _categoryId,
                      items: provider.categories
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item['id'].toString(),
                              child: Text(item['name']?.toString() ?? ''),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _categoryId = value),
                      decoration: InputDecoration(
                        labelText: AppLocale.format(AppLocale.communityEventCategory),
                      ),
                      validator: (v) => v == null
                          ? AppLocale.format(AppLocale.communityValidationRequired)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(AppLocale.format(AppLocale.communityEventDateTime)),
                      subtitle: Text(
                        _dateTime == null
                            ? AppLocale.format(AppLocale.communityPickDateTime)
                            : _dateTime!.toLocal().toString().split('.').first,
                      ),
                      trailing: const Icon(Icons.calendar_today_rounded),
                      onTap: _pickDateTime,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _attendanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: AppLocale.format(AppLocale.communityExpectedAttendance),
                      ),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n <= 0) {
                          return AppLocale.format(AppLocale.communityValidationAttendance);
                        }
                        return null;
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _donationEnabled,
                      title: Text(AppLocale.format(AppLocale.communityEnableDonation)),
                      onChanged: (v) => setState(() => _donationEnabled = v),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isLoading ? null : _submit,
                        child: provider.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(AppLocale.format(AppLocale.communitySubmitRequest)),
                      ),
                    ),
                    if (provider.error != null) ...[
                      const SizedBox(height: 8),
                      Text(provider.error!, style: const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null || !mounted) return;
    setState(() {
      _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;
    final eventDate = _dateTime;
    final categoryId = _categoryId;
    if (eventDate == null || categoryId == null) return;
    final ok = await context.read<EventRequestProvider>().createRequest(
          title: _titleController.text,
          description: _descriptionController.text,
          eventDate: eventDate,
          categoryId: categoryId,
          donationEnabled: _donationEnabled,
          expectedAttendance: int.parse(_attendanceController.text),
        );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocale.format(AppLocale.communityRequestSubmitted))),
      );
      Navigator.pop(context);
    }
  }
}
