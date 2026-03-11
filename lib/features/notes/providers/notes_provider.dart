import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages daily notes saved locally via SharedPreferences.
class NotesProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  String _todayNote = '';

  NotesProvider(this._prefs) {
    _loadTodayNote();
  }

  String get todayNote => _todayNote;

  /// Gets the storage key for the current date (e.g., 'note_2024-03-15').
  String get _todayKey {
    final now = DateTime.now();
    return 'note_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _loadTodayNote() {
    _todayNote = _prefs.getString(_todayKey) ?? '';
    notifyListeners();
  }

  /// Saves the updated note for today.
  Future<void> saveNote(String newNote) async {
    _todayNote = newNote;
    await _prefs.setString(_todayKey, newNote);
    notifyListeners();
  }
}
