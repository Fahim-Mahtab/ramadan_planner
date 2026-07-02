class MosqueModel {
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final double distanceKm;

  const MosqueModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.distanceKm,
  });

  String get distanceDisplay =>
      distanceKm < 1
          ? '${(distanceKm * 1000).round()}m'
          : '${distanceKm.toStringAsFixed(1)}km';
}
