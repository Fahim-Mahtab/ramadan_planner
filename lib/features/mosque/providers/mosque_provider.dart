import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/mosque_model.dart';

class MosqueProvider with ChangeNotifier {
  List<MosqueModel> _mosques = [];
  bool _isLoading = false;
  String? _error;
  Position? _position;

  List<MosqueModel> get mosques => _mosques;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get position => _position;

  Future<void> findNearbyMosques({double radiusKm = 5}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      _position = await Geolocator.getLastKnownPosition();
    }

    if (_position == null) {
      _error = 'Could not determine your location';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final lat = _position!.latitude;
      final lng = _position!.longitude;

      final overpassQuery = '''
        [out:json];
        (
          node["amenity"="place_of_worship"]["religion"="islam"](around:$lat,$lng,${(radiusKm * 1000).round()});
          way["amenity"="place_of_worship"]["religion"="islam"](around:$lat,$lng,${(radiusKm * 1000).round()});
        );
        out center;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'data': overpassQuery},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];

        _mosques = elements.map<MosqueModel?>((e) {
          final tags = e['tags'] as Map<String, dynamic>? ?? {};
          final name = tags['name'] as String? ??
              tags['name:en'] as String? ??
              'Unknown Mosque';

          double mLat, mLng;
          if (e['type'] == 'node') {
            mLat = (e['lat'] as num).toDouble();
            mLng = (e['lon'] as num).toDouble();
          } else {
            final center = e['center'] as Map<String, dynamic>?;
            if (center == null) return null;
            mLat = (center['lat'] as num).toDouble();
            mLng = (center['lon'] as num).toDouble();
          }

          final distance = _calculateDistance(lat, lng, mLat, mLng);

          String? address;
          final road = tags['addr:street'] as String?;
          final city = tags['addr:city'] as String?;
          if (road != null && city != null) {
            address = '$road, $city';
          } else if (road != null) {
            address = road;
          }

          return MosqueModel(
            name: name,
            latitude: mLat,
            longitude: mLng,
            address: address,
            distanceKm: distance,
          );
        }).whereType<MosqueModel>().toList();

        _mosques.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      } else {
        _error = 'Failed to fetch nearby mosques';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      debugPrint('MosqueProvider error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRad(double deg) => deg * pi / 180;
}
