import '../../../history/data/services/history_service.dart';

class ProfileService {
  final HistoryService _historyService = HistoryService();

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    final totalArea = await _historyService.getTotalAreaConquered();
    final polygonCount = await _historyService.getPolygonCount();
    final activePolygons = await _historyService.getActivePolygons();

    return {
      'totalArea': totalArea,
      'polygonCount': polygonCount,
      'activePolygonCount': activePolygons.length,
      'averageArea': polygonCount > 0 ? totalArea / polygonCount : 0.0,
    };
  }

  /// Format area to readable string
  String formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters < 1000) {
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else if (areaInSquareMeters < 1000000) {
      return '${(areaInSquareMeters / 1000).toStringAsFixed(2)} km²';
    } else {
      return '${(areaInSquareMeters / 1000000).toStringAsFixed(2)} km²';
    }
  }

  /// Format distance to readable string
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }
}
