import 'package:flutter/foundation.dart';

import '../../../history/data/services/history_service.dart';

class HomeProvider extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();
  bool _showStats = false;

  bool get showStats => _showStats;

  void toggleStats() {
    _showStats = !_showStats;
    notifyListeners();
  }

  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;

  HomeProvider() {
    _loadStats();
  }

  /// Refresh stats from SQLite (e.g. after completing a polygon or returning to home)
  Future<void> refreshStats() async {
    await _loadStats();
  }

  Future<void> _loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final totalArea = await _historyService.getTotalAreaConquered();
      final polygonCount = await _historyService.getPolygonCount();
      final activePolygons = await _historyService.getActivePolygons();
      final totalDistance = await _historyService.getTotalDistance();
      final todayDistance = await _historyService.getTodayDistance();
      final streak = await _historyService.getCurrentStreak();
      final maxArea = await _historyService.getMaxArea();
      final maxStreak = await _historyService.getMaxStreak();

      final totalDistanceKm = totalDistance / 1000.0;
      final totalCalories = (totalDistanceKm * 55).round();
      final todayDistanceKm = todayDistance / 1000.0;
      final todayCalories = (todayDistanceKm * 55).round();

      final averageArea =
          polygonCount > 0 ? totalArea / polygonCount : 0.0;

      _stats = {
        'totalArea': totalArea,
        'polygonCount': polygonCount,
        'activePolygonCount': activePolygons.length,
        'averageArea': averageArea,
        'totalDistance': totalDistance,
        'todayDistance': todayDistance,
        'totalCalories': totalCalories,
        'todayCalories': todayCalories,
        'streak': streak,
        'maxArea': maxArea,
        'maxStreak': maxStreak,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error loading stats: $e');
      }
      _stats = {
        'totalArea': 0.0,
        'polygonCount': 0,
        'activePolygonCount': 0,
        'averageArea': 0.0,
        'totalDistance': 0.0,
        'todayDistance': 0.0,
        'totalCalories': 0,
        'todayCalories': 0,
        'streak': 0,
        'maxArea': 0.0,
        'maxStreak': 0,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }

  String formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters < 10000) {
      // 1 hektardan az → m²
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else if (areaInSquareMeters < 1000000) {
      // 1 km²'den az → hektar (ha), 1 ha = 10.000 m²
      return '${(areaInSquareMeters / 10000).toStringAsFixed(2)} ha';
    } else {
      // 1 km² ve üzeri → km², 1 km² = 1.000.000 m²
      return '${(areaInSquareMeters / 1000000).toStringAsFixed(2)} km²';
    }
  }

  String formatCalories(int calories) {
    if (calories < 1000) {
      return '$calories kcal';
    } else {
      return '${(calories / 1000).toStringAsFixed(1)}k kcal';
    }
  }

  String formatStreak(int streak) {
    return '$streak';
  }
}
