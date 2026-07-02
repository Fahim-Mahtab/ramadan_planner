class QiblaDirection {
  final double bearing;
  final bool isCalibrated;

  const QiblaDirection({
    required this.bearing,
    required this.isCalibrated,
  });

  String get bearingLabel {
    final degrees = (bearing % 360).round();
    return '$degrees°';
  }

  String get cardinalDirection {
    final b = bearing % 360;
    return switch (b) {
      >= 337.5 || < 22.5 => 'N',
      >= 22.5 && < 67.5 => 'NE',
      >= 67.5 && < 112.5 => 'E',
      >= 112.5 && < 157.5 => 'SE',
      >= 157.5 && < 202.5 => 'S',
      >= 202.5 && < 247.5 => 'SW',
      >= 247.5 && < 292.5 => 'W',
      >= 292.5 && < 337.5 => 'NW',
      _ => 'N',
    };
  }
}
