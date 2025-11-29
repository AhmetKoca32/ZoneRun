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
}
