import '../../../../core/models/polygon_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/geometry_utils.dart';

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

  /// Get total distance (sum of perimeters of all completed polygons) in meters
  Future<double> getTotalDistance() async {
    final polygons = await getHistory();
    double total = 0.0;
    for (final polygon in polygons) {
      if (polygon.points.length >= 2) {
        total += polygonPerimeterMeters(polygon.points);
      }
    }
    return total;
  }

  /// Get today's distance (sum of perimeters of polygons completed today) in meters
  Future<double> getTodayDistance() async {
    final polygons = await getTodayPolygons();
    double total = 0.0;
    for (final polygon in polygons) {
      if (polygon.points.length >= 2) {
        total += polygonPerimeterMeters(polygon.points);
      }
    }
    return total;
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

  /// Get polygons completed this week (Monday start)
  Future<List<PolygonModel>> getThisWeekPolygons() async {
    final allPolygons = await getHistory();
    final now = DateTime.now();
    final weekday = now.weekday;
    final mondayOffset = weekday - DateTime.monday;
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: mondayOffset));

    return allPolygons.where((polygon) {
      if (polygon.completedAt == null) return false;
      return !polygon.completedAt!.isBefore(weekStart);
    }).toList();
  }

  /// Get polygons completed this month
  Future<List<PolygonModel>> getThisMonthPolygons() async {
    final allPolygons = await getHistory();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    return allPolygons.where((polygon) {
      if (polygon.completedAt == null) return false;
      return !polygon.completedAt!.isBefore(monthStart);
    }).toList();
  }

  /// Get this week's total distance in meters
  Future<double> getThisWeekDistance() async {
    final polygons = await getThisWeekPolygons();
    double total = 0.0;
    for (final polygon in polygons) {
      if (polygon.points.length >= 2) {
        total += polygonPerimeterMeters(polygon.points);
      }
    }
    return total;
  }

  /// Get this month's total distance in meters
  Future<double> getThisMonthDistance() async {
    final polygons = await getThisMonthPolygons();
    double total = 0.0;
    for (final polygon in polygons) {
      if (polygon.points.length >= 2) {
        total += polygonPerimeterMeters(polygon.points);
      }
    }
    return total;
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

  /// Get maximum area from all completed polygons
  Future<double> getMaxArea() async {
    final polygons = await getHistory();
    if (polygons.isEmpty) return 0.0;
    
    double maxArea = 0.0;
    for (final polygon in polygons) {
      if (polygon.area > maxArea) {
        maxArea = polygon.area;
      }
    }
    return maxArea;
  }

  /// Get maximum streak (highest streak ever achieved)
  Future<int> getMaxStreak() async {
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

    // Sort dates
    final sortedDates = completedDates.toList()..sort();

    int maxStreak = 0;
    int currentStreak = 1;

    // Find longest consecutive sequence
    for (int i = 1; i < sortedDates.length; i++) {
      final prevDate = sortedDates[i - 1];
      final currDate = sortedDates[i];
      final daysDiff = currDate.difference(prevDate).inDays;

      if (daysDiff == 1) {
        // Consecutive day
        currentStreak++;
      } else {
        // Break in streak
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
        }
        currentStreak = 1;
      }
    }

    // Check last streak
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }

    return maxStreak;
  }
}
