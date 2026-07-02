import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/calendar_config.dart';

class CalendarPdfProvider extends ChangeNotifier {
  Uint8List? _pdfBytes;
  bool _isLoading = false;
  String? _error;

  Uint8List? get pdfBytes => _pdfBytes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int _getMethodNumber(String method) {
    switch (method) {
      case 'Karachi':
        return 1;
      case 'ISNA':
        return 2;
      case 'Makkah':
        return 4;
      case 'Egypt':
        return 5;
      default:
        return 1;
    }
  }

  String _formatTime(String time, String timeFormat) {
    final parts = time.split(' ');
    if (parts.length < 2) return time;
    final timePart = parts[0];
    final timeComponents = timePart.split(':');
    if (timeComponents.length < 2) return time;
    final hour = int.tryParse(timeComponents[0]) ?? 0;
    final minute = timeComponents[1];
    if (timeFormat == '12h') {
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
    }
    return '${hour.toString().padLeft(2, '0')}:$minute';
  }

  String _getDateLabel(String gregDate, String language) {
    if (language == 'bn') {
      final parts = gregDate.split('-');
      if (parts.length == 3) {
        final months = [
          '', 'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
          'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
        ];
        final day = int.tryParse(parts[0]) ?? 0;
        final month = int.tryParse(parts[1]) ?? 0;
        final year = parts[2];
        return '$day ${months[month]}, $year';
      }
    }
    return gregDate;
  }

  Future<void> generatePdf(CalendarConfig config) async {
    _isLoading = true;
    _error = null;
    _pdfBytes = null;
    notifyListeners();

    try {
      final method = _getMethodNumber(config.calculationMethod);
      Map<String, Map<String, String>> allData = {};

      for (final month in [2, 3]) {
        final url = 'https://api.aladhan.com/v1/calendar'
            '?latitude=23.81&longitude=90.41'
            '&method=$method'
            '&month=$month'
            '&year=2026';

        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          throw Exception('Failed to fetch prayer times (${response.statusCode})');
        }

        final body = json.decode(response.body);
        for (final day in body['data'] as List) {
          final hijriMonth = day['date']['hijri']['month']['number'];
          if (hijriMonth == 9) {
            final gregDate = day['date']['gregorian']['date'] as String;
            final sehri = day['timings']['Fajr'] as String;
            final iftar = day['timings']['Maghrib'] as String;
            allData[gregDate] = {'sehri': sehri, 'iftar': iftar};
          }
        }
      }

      final sortedKeys = allData.keys.toList()..sort();
      if (sortedKeys.isEmpty) {
        throw Exception('No Ramadan prayer times found for 2026.');
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  'Ramadan Calendar 1447 / 2026',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  '${config.city} | ${config.calculationMethod} Method',
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFF047857),
                ),
                cellStyle: pw.TextStyle(
                  fontSize: 9,
                ),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                },
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                },
                headers: ['Date', 'Sehri (Fajr)', 'Iftar (Maghrib)'],
                data: sortedKeys.map((date) {
                  final d = allData[date]!;
                  final label = _getDateLabel(date, config.language);
                  final sehri = _formatTime(d['sehri']!, config.timeFormat);
                  final iftar = _formatTime(d['iftar']!, config.timeFormat);
                  return [label, sehri, iftar];
                }).toList(),
              ),
            ];
          },
        ),
      );

      _pdfBytes = await pdf.save();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sharePdf() async {
    if (_pdfBytes == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ramadan_calendar_2026.pdf');
    await file.writeAsBytes(_pdfBytes!);
    await Share.shareXFiles([XFile(file.path)], text: 'Ramadan Calendar 1447 / 2026');
  }
}
