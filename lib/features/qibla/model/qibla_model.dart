class QiblaModel {
  final double latitude;
  final double longitude;
  final double direction;

  QiblaModel({
    required this.latitude,
    required this.longitude,
    required this.direction,
  });

  factory QiblaModel.fromJson(Map<String, dynamic> json) {
    return QiblaModel(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      direction: (json['direction'] ?? 0).toDouble(),
    );
  }
}
