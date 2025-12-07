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
  
  // User profile data
  String _userName = 'Ahmet Koca';
  String? _avatarUrl;
  int _avatarIndex = 0; // Default avatar index
  bool _isProMember = false;
  DateTime? _joinDate;
  int? _selectedCharacterId;

  Map<String, dynamic>? get userStats => _userStats;
  bool get isLoading => _isLoading;
  int get streak => _streak;
  bool get isDarkTheme => _isDarkTheme;
  String get userName => _userName;
  String? get avatarUrl => _avatarUrl;
  int get avatarIndex => _avatarIndex;
  bool get isProMember => _isProMember;
  DateTime? get joinDate => _joinDate;
  int? get selectedCharacterId => _selectedCharacterId;

  ProfileProvider() {
    _loadProfileData();
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    // TODO: Load from database/storage when implemented
    _joinDate = DateTime.now().subtract(const Duration(days: 30)); // Mock data
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
  
  // User profile methods
  Future<void> updateUserName(String newName) async {
    _userName = newName;
    notifyListeners();
    // TODO: Save to database/storage
  }
  
  Future<void> updateAvatar(int avatarIndex) async {
    _avatarIndex = avatarIndex;
    notifyListeners();
    // TODO: Save to database/storage
  }
  
  Future<void> updateAvatarUrl(String? url) async {
    _avatarUrl = url;
    notifyListeners();
    // TODO: Save to database/storage
  }
  
  Future<void> selectCharacter(int characterId) async {
    _selectedCharacterId = characterId;
    notifyListeners();
    // TODO: Save to database/storage
  }
  
  Future<void> upgradeToPro() async {
    _isProMember = true;
    notifyListeners();
    // TODO: Implement Pro upgrade logic
  }
}

