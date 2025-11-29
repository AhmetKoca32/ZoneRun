import 'dart:math' as math;

import '../../../../core/models/polygon_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/location_service.dart';

class MapService {
  final LocationService _locationService = LocationService();
  final DatabaseService _databaseService = DatabaseService();

  /// Start tracking location for a new polygon
  Stream<LatLng>? startTracking() {
    return _locationService.getLocationStream();
  }

  /// Calculate polygon area using Shoelace formula
  double calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      area += points[i].longitude * points[j].latitude;
      area -= points[j].longitude * points[i].latitude;
    }
    area = area.abs() / 2.0;

    // Convert to square meters (approximate)
    // 1 degree latitude ≈ 111 km
    // 1 degree longitude ≈ 111 km * cos(latitude)
    final avgLat =
        points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
    final latMeters = 111000.0; // meters per degree latitude
    final lonMeters =
        111000.0 *
        math.cos(avgLat * math.pi / 180.0); // meters per degree longitude

    return area * latMeters * lonMeters;
  }

  /// Save polygon to database
  Future<int> savePolygon({
    required String name,
    required List<LatLng> points,
  }) async {
    final area = calculatePolygonArea(points);
    final polygon = PolygonModel(
      name: name,
      points: points,
      area: area,
      createdAt: DateTime.now(),
    );

    return await _databaseService.insertPolygon(polygon);
  }

  /// Complete a polygon (mark as finished)
  Future<void> completePolygon(int polygonId) async {
    final polygon = await _databaseService.getPolygonById(polygonId);
    if (polygon != null) {
      final completedPolygon = polygon.copyWith(completedAt: DateTime.now());
      await _databaseService.updatePolygon(completedPolygon);
    }
  }

  /// Get current location
  Future<LatLng?> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  /// Check location permissions
  Future<bool> checkLocationPermission() async {
    return await _locationService.checkAndRequestPermission();
  }
}
