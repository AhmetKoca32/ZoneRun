import 'dart:math' as math;

import '../models/polygon_model.dart';

/// Earth radius in meters (WGS84)
const double _earthRadiusMeters = 6371000.0;

/// Haversine distance between two points in meters.
double haversineDistanceMeters(LatLng a, LatLng b) {
  final lat1 = a.latitude * math.pi / 180;
  final lat2 = b.latitude * math.pi / 180;
  final dLat = (b.latitude - a.latitude) * math.pi / 180;
  final dLon = (b.longitude - a.longitude) * math.pi / 180;

  final x = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(x), math.sqrt(1 - x));

  return _earthRadiusMeters * c;
}

/// Polygon perimeter (sum of edge lengths) in meters.
double polygonPerimeterMeters(List<LatLng> points) {
  if (points.length < 2) return 0.0;

  double perimeter = 0.0;
  for (int i = 0; i < points.length; i++) {
    final j = (i + 1) % points.length;
    perimeter += haversineDistanceMeters(points[i], points[j]);
  }
  return perimeter;
}
