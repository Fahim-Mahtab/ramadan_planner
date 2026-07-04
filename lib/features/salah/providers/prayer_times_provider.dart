import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/prayer_times_model.dart';

class PrayerTimesProvider with ChangeNotifier {
  PrayerTimesModel? _prayerTimes;
  String _locality = "Unknown Location";
  bool _isLoading = false;
  String? _error;

  PrayerTimesModel? get prayerTimes => _prayerTimes;
  String get locality => _locality;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try Supabase first
      final fetched = await _fetchFromSupabase();
      if (fetched != null) {
        _prayerTimes = fetched;
        _locality = 'Baitul Aman Masjid';
        _setLoadingFalse();
        return;
      }

      // Fallback to Aladhan API
      await _fetchFromAladhan();
    } catch (e) {
      _error = "An error occurred: $e";
      if (kDebugMode) {
        print("Prayer Time Exception: $e");
      }
    }

    _setLoadingFalse();
  }

  Future<PrayerTimesModel?> _fetchFromSupabase() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final data = await Supabase.instance.client
          .from('prayer_times')
          .select()
          .eq('date', today)
          .eq('is_active', true)
          .maybeSingle();

      if (data != null) {
        return PrayerTimesModel.fromSupabase(data as Map<String, dynamic>);
      }
    } catch (e) {
      if (kDebugMode) print("Supabase prayer times fetch failed: $e");
    }
    return null;
  }

  Future<void> _fetchFromAladhan() async {
    double latitude;
    double longitude;

    if (kIsWeb) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 8),
          ),
        );
        latitude = position.latitude;
        longitude = position.longitude;
        _tryReverseGeocode(latitude, longitude);
      } catch (_) {
        latitude = 23.8103;
        longitude = 90.4125;
        _locality = 'Dhaka, Bangladesh';
      }
    } else {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = "Location services are disabled. Please enable them in settings.";
        _setLoadingFalse();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = "Location permissions are denied.";
          _setLoadingFalse();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = "Location permissions are permanently denied. Cannot fetch prayer times.";
        _setLoadingFalse();
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        _error = "Could not determine your location. Please check your GPS and try again.";
        _setLoadingFalse();
        return;
      }

      latitude = position.latitude;
      longitude = position.longitude;
      await _tryReverseGeocode(latitude, longitude);
    }

    final url = Uri.parse(
      'https://api.aladhan.com/v1/timings/today?latitude=$latitude&longitude=$longitude&method=2',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['code'] == 200 && jsonResponse['data'] != null) {
        final apiData = jsonResponse['data'];
        final timings = apiData['timings'] ?? {};
        final date = apiData['date'] ?? {};
        final hijri = date['hijri'] ?? {};
        final hijriMonthData = hijri['month'] ?? {};

        _prayerTimes = PrayerTimesModel(
          fajr: timings['Fajr'] ?? '',
          sunrise: timings['Sunrise'] ?? '',
          dhuhr: timings['Dhuhr'] ?? '',
          asr: timings['Asr'] ?? '',
          maghrib: timings['Maghrib'] ?? '',
          isha: timings['Isha'] ?? '',
          jummah: '13:30',
          gregorianDate: date['readable'] ?? '',
          hijriDate: '${hijri['day'] ?? ''} ${hijriMonthData['en'] ?? ''} ${hijri['year'] ?? ''}',
          hijriMonth: hijriMonthData['en'] ?? '',
        );
      } else {
        _error = "Failed to parse API response structure.";
      }
    } else {
      _error = "Failed to fetch times. Server returned ${response.statusCode}";
    }
  }

  Future<void> _tryReverseGeocode(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
        final country = place.country;
        if (city != null && country != null && city.isNotEmpty && country.isNotEmpty) {
          _locality = "$city, $country";
        } else if (city != null && city.isNotEmpty) {
          _locality = city;
        }
      }
    } catch (e) {
      if (kDebugMode) print("Geocoding failed: $e");
    }
  }

  void _setLoadingFalse() {
    _isLoading = false;
    notifyListeners();
  }
}
