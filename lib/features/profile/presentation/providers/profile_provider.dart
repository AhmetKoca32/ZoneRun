import 'package:flutter/foundation.dart';

import '../../data/services/profile_service.dart';
import '../../../history/data/services/history_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final HistoryService _historyService = HistoryService();

  Map<String, dynamic>? _userStats;
  bool _isLoading = true;
  int _streak = 0;
  bool _isDarkTheme = true; // Default dark theme

  Map<String, dynamic>? get userStats => _userStats;
  bool get isLoading => _isLoading;
  int get streak => _streak;
  bool get isDarkTheme => _isDarkTheme;

  ProfileProvider() {
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userStats = await _profileService.getUserStats();
      _streak = await _historyService.getCurrentStreak();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile data: $e');
      }
      _userStats = {
        'totalArea': 0.0,
        'polygonCount': 0,
        'activePolygonCount': 0,
        'averageArea': 0.0,
      };
      _streak = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadProfileData();
  }

  String formatArea(double areaInSquareMeters) {
    return _profileService.formatArea(areaInSquareMeters);
  }

  String formatDistance(double distanceInMeters) {
    return _profileService.formatDistance(distanceInMeters);
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    // TODO: Implement actual theme change when light theme is ready
  }
}

