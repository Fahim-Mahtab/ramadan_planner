import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../models/qibla_direction.dart';
import '../services/qibla_calculator.dart';

class QiblaProvider with ChangeNotifier {
  QiblaDirection? _direction;
  bool _isCalibrated = false;
  bool _isLoading = true;
  Position? _position;
  StreamSubscription? _sensorSubscription;

  QiblaDirection? get direction => _direction;
  bool get isCalibrated => _isCalibrated;
  bool get isLoading => _isLoading;
  Position? get position => _position;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _getLocation();
    _startSensors();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _getLocation() async {
    try {
      _position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      try {
        _position = await Geolocator.getLastKnownPosition();
      } catch (_) {
        _position = null;
      }
    }
  }

  void _startSensors() {
    _sensorSubscription = magnetometerEventStream().listen(
      (event) {
        _updateDirection(event.x, event.y, event.z);
      },
      onError: (_) {
        _isCalibrated = false;
        notifyListeners();
      },
    );
  }

  void _updateDirection(double x, double y, double z) {
    if (_position == null) return;

    final heading = atan2(y, x) * (180 / pi);
    final normalizedHeading = heading < 0 ? heading + 360 : heading;

    final lat = _position!.latitude;
    final lng = _position!.longitude;
    final qiblaAngle = QiblaCalculator.calculateBearing(lat, lng);

    final difference = (qiblaAngle - normalizedHeading + 360) % 360;
    final offset = difference > 180 ? difference - 360 : difference;

    _direction = QiblaDirection(
      bearing: offset + 360,
      isCalibrated: true,
    );
    _isCalibrated = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    super.dispose();
  }
}
