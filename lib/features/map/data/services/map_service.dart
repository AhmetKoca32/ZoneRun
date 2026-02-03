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

  /// Calculate polygon area using Shoelace formula with proper coordinate conversion
  /// Uses average point as reference for better accuracy
  double calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    // Calculate average latitude for longitude conversion
    final avgLat =
        points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
    final avgLon =
        points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length;
    
    // Convert lat/lon to meters using proper projection
    // 1 degree latitude ≈ 111,320 meters (constant)
    // 1 degree longitude ≈ 111,320 * cos(latitude) meters (varies by latitude)
    const double latMetersPerDegree = 111320.0;
    final lonMetersPerDegree = 111320.0 * math.cos(avgLat * math.pi / 180.0);
    
    // Convert all points to meters relative to average point
    // This gives better accuracy than using first point
    final pointsInMeters = points.map((p) {
      return {
        'x': (p.longitude - avgLon) * lonMetersPerDegree,
        'y': (p.latitude - avgLat) * latMetersPerDegree,
      };
    }).toList();
    
    // Apply Shoelace formula on meter coordinates
    double area = 0.0;
    for (int i = 0; i < pointsInMeters.length; i++) {
      final j = (i + 1) % pointsInMeters.length;
      area += pointsInMeters[i]['x']! * pointsInMeters[j]['y']!;
      area -= pointsInMeters[j]['x']! * pointsInMeters[i]['y']!;
    }
    
    return area.abs() / 2.0;
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

  /// Get all completed polygons
  Future<List<PolygonModel>> getCompletedPolygons() async {
    return await _databaseService.getCompletedPolygons();
  }

  /// Delete a polygon
  Future<void> deletePolygon(int id) async {
    await _databaseService.deletePolygon(id);
  }
}
