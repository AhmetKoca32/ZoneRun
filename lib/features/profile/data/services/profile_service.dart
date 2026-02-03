import '../../../../core/constants/calorie_constants.dart';
import '../../../history/data/services/history_service.dart';

class ProfileService {
  final HistoryService _historyService = HistoryService();

  /// Get user statistics (from SQLite polygon data).
  /// [weightKg] optional; used for calorie estimate (formula: weight × distance_km × K).
  /// If null, [CalorieConstants.defaultWeightKg] is used.
  Future<Map<String, dynamic>> getUserStats({double? weightKg}) async {
    final totalArea = await _historyService.getTotalAreaConquered();
    final polygonCount = await _historyService.getPolygonCount();
    final activePolygons = await _historyService.getActivePolygons();
    final totalDistance = await _historyService.getTotalDistance();
    final todayDistance = await _historyService.getTodayDistance();
    final streak = await _historyService.getCurrentStreak();
    final maxArea = await _historyService.getMaxArea();
    final maxStreak = await _historyService.getMaxStreak();

    final totalDistanceKm = totalDistance / 1000.0;
    final todayDistanceKm = todayDistance / 1000.0;
    final totalCalories = CalorieConstants.estimateCalories(
      totalDistanceKm,
      weightKg,
    );
    final todayCalories = CalorieConstants.estimateCalories(
      todayDistanceKm,
      weightKg,
    );

    return {
      'totalArea': totalArea,
      'polygonCount': polygonCount,
      'activePolygonCount': activePolygons.length,
      'averageArea': polygonCount > 0 ? totalArea / polygonCount : 0.0,
      'totalDistance': totalDistance,
      'todayDistance': todayDistance,
      'totalCalories': totalCalories,
      'todayCalories': todayCalories,
      'streak': streak,
      'maxArea': maxArea,
      'maxStreak': maxStreak,
    };
  }

  /// Format area to readable string
  String formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters < 10000) {
      // Less than 1 hectare, show in m²
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else if (areaInSquareMeters < 1000000) {
      // Less than 1 km², show in hectares
      return '${(areaInSquareMeters / 10000).toStringAsFixed(2)} ha';
    } else {
      // 1 km² or more, show in km²
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
