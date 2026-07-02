import 'dart:math';

class QiblaCalculator {
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  QiblaCalculator._();

  static double calculateBearing(double userLat, double userLng) {
    final lat1 = _toRadians(userLat);
    final lat2 = _toRadians(kaabaLat);
    final dLng = _toRadians(kaabaLng - userLng);

    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    final bearing = atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;
  static double _toDegrees(double radians) => radians * 180 / pi;
}
