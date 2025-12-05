import '../../../../core/models/polygon_model.dart';
import '../../../../core/services/database_service.dart';

class HistoryService {
  final DatabaseService _databaseService = DatabaseService();

  /// Get all completed polygons (history)
  Future<List<PolygonModel>> getHistory() async {
    return await _databaseService.getCompletedPolygons();
  }

  /// Get all polygons (including active ones)
  Future<List<PolygonModel>> getAllPolygons() async {
    return await _databaseService.getAllPolygons();
  }

  /// Get active (incomplete) polygons
  Future<List<PolygonModel>> getActivePolygons() async {
    return await _databaseService.getActivePolygons();
  }

  /// Get polygon by id
  Future<PolygonModel?> getPolygonById(int id) async {
    return await _databaseService.getPolygonById(id);
  }

  /// Delete a polygon from history
  Future<void> deletePolygon(int id) async {
    await _databaseService.deletePolygon(id);
  }

  /// Get total area conquered (sum of all completed polygons)
  Future<double> getTotalAreaConquered() async {
    final polygons = await getHistory();
    double total = 0.0;
    for (final polygon in polygons) {
      total += polygon.area;
    }
    return total;
  }

  /// Get polygon count
  Future<int> getPolygonCount() async {
    final polygons = await getHistory();
    return polygons.length;
  }

  /// Get polygons completed today
  Future<List<PolygonModel>> getTodayPolygons() async {
    final allPolygons = await getHistory();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return allPolygons.where((polygon) {
      if (polygon.completedAt == null) return false;
      return polygon.completedAt!.isAfter(todayStart);
    }).toList();
  }

  /// Calculate current streak (consecutive days with activity)
  /// Streak continues if user has activity today or yesterday
  Future<int> getCurrentStreak() async {
    final polygons = await getHistory();
    if (polygons.isEmpty) return 0;

    // Get unique dates when polygons were completed
    final completedDates = <DateTime>{};
    for (final polygon in polygons) {
      if (polygon.completedAt != null) {
        final date = DateTime(
          polygon.completedAt!.year,
          polygon.completedAt!.month,
          polygon.completedAt!.day,
        );
        completedDates.add(date);
      }
    }

    if (completedDates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if user has activity today or yesterday
    final hasActivityToday = completedDates.contains(today);
    final yesterday = today.subtract(const Duration(days: 1));
    final hasActivityYesterday = completedDates.contains(yesterday);

    // If no activity today or yesterday, streak is 0
    if (!hasActivityToday && !hasActivityYesterday) return 0;

    // Start from today if activity today, otherwise from yesterday
    DateTime checkDate = hasActivityToday ? today : yesterday;
    int streak = 0;

    // Count consecutive days backwards
    while (completedDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
