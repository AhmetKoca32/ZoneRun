import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
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

  Future<void> _loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock data for development
      await Future.delayed(const Duration(milliseconds: 500));

      _stats = {
        'totalArea': 12500000.0, // m² -> 12.50 km²
        'polygonCount': 8,
        'activePolygonCount': 3,
        'averageArea': 1560000.0, // m² -> 1.56 km²
        'totalDistance': 18500.0, // meters -> 18.50 km
        'todayDistance': 3200.0, // meters -> 3.20 km
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
    if (areaInSquareMeters < 1000) {
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else if (areaInSquareMeters < 1000000) {
      return '${(areaInSquareMeters / 1000).toStringAsFixed(2)} km²';
    } else {
      return '${(areaInSquareMeters / 1000000).toStringAsFixed(2)} km²';
    }
  }
}
