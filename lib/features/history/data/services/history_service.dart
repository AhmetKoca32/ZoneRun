import '../../../../core/models/polygon_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/calorie_estimator.dart';
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

  /// Tek günde koşulan en fazla mesafe (metre). Tüm zamanlar.
  Future<double> getMaxDistanceInSingleDay() async {
    final polygons = await getHistory();
    final Map<DateTime, double> dayToDistance = {};
    for (final p in polygons) {
      if (p.completedAt == null) continue;
      final day = DateTime(
        p.completedAt!.year,
        p.completedAt!.month,
        p.completedAt!.day,
      );
      final dist = p.points.length >= 2
          ? polygonPerimeterMeters(p.points)
          : 0.0;
      dayToDistance[day] = (dayToDistance[day] ?? 0) + dist;
    }
    if (dayToDistance.isEmpty) return 0.0;
    return dayToDistance.values.reduce((a, b) => a > b ? a : b);
  }

  /// Geçen ay tamamlanan poligonlar (takvim ayı).
  Future<List<PolygonModel>> getLastMonthPolygons() async {
    final allPolygons = await getHistory();
    final now = DateTime.now();
    final lastMonthStart = now.month == 1
        ? DateTime(now.year - 1, 12, 1)
        : DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 1);
    return allPolygons.where((p) {
      if (p.completedAt == null) return false;
      return !p.completedAt!.isBefore(lastMonthStart) &&
          p.completedAt!.isBefore(lastMonthEnd);
    }).toList();
  }

  /// Geçen ay toplam mesafe (metre).
  Future<double> getLastMonthDistance() async {
    final polygons = await getLastMonthPolygons();
    double total = 0.0;
    for (final p in polygons) {
      if (p.points.length >= 2) total += polygonPerimeterMeters(p.points);
    }
    return total;
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

  /// Son [lastDays] gün için günlük mesafe (metre). Key = gün (00:00:00), value = o günkü toplam mesafe.
  /// Isı haritası için kullanılır.
  Future<Map<DateTime, double>> getDailyDistanceForLastDays(
    int lastDays,
  ) async {
    final polygons = await getHistory();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: lastDays - 1));
    final Map<DateTime, double> dayToDistance = {};
    for (final p in polygons) {
      if (p.completedAt == null) continue;
      final day = DateTime(
        p.completedAt!.year,
        p.completedAt!.month,
        p.completedAt!.day,
      );
      if (day.isBefore(startDate)) continue;
      final dist = p.points.length >= 2
          ? polygonPerimeterMeters(p.points)
          : 0.0;
      dayToDistance[day] = (dayToDistance[day] ?? 0) + dist;
    }
    return dayToDistance;
  }

  /// Son [lastWeeks] hafta için haftalık toplam mesafe (m) ve poligon sayısı.
  /// Hafta Pazartesi başlar. [weekStart] = o haftanın Pazartesi 00:00.
  Future<List<({DateTime weekStart, double distanceM, int polygonCount})>>
  getWeeklyTotalsForLastWeeks(int lastWeeks) async {
    final polygons = await getHistory();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = now.weekday;
    final mondayOffset = weekday - DateTime.monday;
    final thisWeekStart = today.subtract(Duration(days: mondayOffset));
    final List<({DateTime weekStart, double distanceM, int polygonCount})>
    result = [];
    for (var w = 0; w < lastWeeks; w++) {
      final weekStart = thisWeekStart.subtract(Duration(days: 7 * w));
      final weekEnd = weekStart.add(const Duration(days: 7));
      double distanceM = 0.0;
      int count = 0;
      for (final p in polygons) {
        if (p.completedAt == null) continue;
        if (!p.completedAt!.isBefore(weekStart) &&
            p.completedAt!.isBefore(weekEnd)) {
          count++;
          if (p.points.length >= 2) {
            distanceM += polygonPerimeterMeters(p.points);
          }
        }
      }
      result.add((
        weekStart: weekStart,
        distanceM: distanceM,
        polygonCount: count,
      ));
    }
    return result;
  }

  /// Tüm tamamlanmış poligonlar için MET tabanlı toplam kalori (kcal).
  ///
  /// [weightKg] null ise [CalorieEstimator.defaultWeightKg] kullanılır.
  Future<int> getTotalCalories({double? weightKg}) async {
    final polygons = await getHistory();
    var total = 0;
    for (final p in polygons) {
      total += CalorieEstimator.estimateForPolygon(
        p,
        weightKg: weightKg,
      );
    }
    return total;
  }

  /// Bugün tamamlanan poligonlar için MET tabanlı toplam kalori (kcal).
  ///
  /// [weightKg] null ise [CalorieEstimator.defaultWeightKg] kullanılır.
  Future<int> getTodayCalories({double? weightKg}) async {
    final polygons = await getTodayPolygons();
    var total = 0;
    for (final p in polygons) {
      total += CalorieEstimator.estimateForPolygon(
        p,
        weightKg: weightKg,
      );
    }
    return total;
  }
}

