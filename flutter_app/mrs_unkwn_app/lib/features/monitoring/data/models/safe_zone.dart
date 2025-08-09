import 'package:geolocator/geolocator.dart';

/// Represents a circular geographic area.
class SafeZone {
  SafeZone({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double radius; // meters

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      };

  factory SafeZone.fromJson(Map<String, dynamic> json) => SafeZone(
        name: json['name'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        radius: (json['radius'] as num).toDouble(),
      );

  /// Checks whether [position] lies inside this zone.
  bool contains(Position position) {
    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      position.latitude,
      position.longitude,
    );
    return distance <= radius;
  }
}
