import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
      // Check limits and permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error =
            "Location services are disabled. Please enable them in settings.";
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
        _error =
            "Location permissions are permanently denied. Cannot fetch prayer times.";
        _setLoadingFalse();
        return;
      }

      // We have permission, fetch position
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } catch (e) {
        // If timeout or error occurs, fallback to last known position
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        _error =
            "Could not determine your location. Please check your GPS and try again.";
        _setLoadingFalse();
        return;
      }

      // Attempt reverse geocoding to get locality
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city =
              place.locality ??
              place.subAdministrativeArea ??
              place.administrativeArea;
          final country = place.country;
          if (city != null &&
              country != null &&
              city.isNotEmpty &&
              country.isNotEmpty) {
            _locality = "$city, $country";
          } else if (city != null && city.isNotEmpty) {
            _locality = city;
          }
        }
      } catch (e) {
        // Reverse geocoding might fail, fallback is already set
        if (kDebugMode) {
          print("Geocoding failed: $e");
        }
      }

      // Fetch aladhan API
      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings/today?latitude=${position.latitude}&longitude=${position.longitude}&method=2',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['code'] == 200 && jsonResponse['data'] != null) {
          _prayerTimes = PrayerTimesModel.fromJson(jsonResponse['data']);
        } else {
          _error = "Failed to parse API response structure.";
        }
      } else {
        _error =
            "Failed to fetch times. Server returned ${response.statusCode}";
      }
    } catch (e) {
      _error = "An error occurred: $e";
      if (kDebugMode) {
        print("Prayer Time Exception: $e");
      }
    }

    _setLoadingFalse();
  }

  void _setLoadingFalse() {
    _isLoading = false;
    notifyListeners();
  }
}
