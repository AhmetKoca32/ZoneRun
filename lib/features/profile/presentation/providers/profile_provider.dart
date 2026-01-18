import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/profile_service.dart';
import '../../data/services/firestore_user_service.dart';
import '../../../history/data/services/history_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final HistoryService _historyService = HistoryService();
  final FirestoreUserService _firestoreUserService = FirestoreUserService();

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
  List<int> _purchasedCharacters = [];

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
  List<int> get purchasedCharacters => _purchasedCharacters;

  ProfileProvider() {
    _loadProfileData();
    _loadUserProfile();
    _loadThemePreference();
    _setupFirestoreListener();
  }
  
  /// Setup Firestore listener for real-time premium status updates
  void _setupFirestoreListener() {
    try {
      _firestoreUserService.getUserProfileStream().listen(
        (profile) {
          if (profile != null) {
            _isProMember = profile.isProMember;
            _purchasedCharacters = profile.purchasedCharacters;
            _userName = profile.userName;
            _avatarIndex = profile.avatarIndex;
            _avatarUrl = profile.avatarUrl;
            _selectedCharacterId = profile.selectedCharacterId;
            _joinDate = profile.joinDate;
            notifyListeners();
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Error in Firestore listener: $error');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up Firestore listener: $e');
      }
    }
  }
  
  Future<void> _loadUserProfile() async {
    try {
      final profile = await _firestoreUserService.getUserProfile();
      if (profile != null) {
        _userName = profile.userName;
        _avatarIndex = profile.avatarIndex;
        _avatarUrl = profile.avatarUrl;
        _isProMember = profile.isProMember;
        _joinDate = profile.joinDate;
        _selectedCharacterId = profile.selectedCharacterId;
        _purchasedCharacters = profile.purchasedCharacters;
        notifyListeners();
      } else {
        // No profile found, use defaults
        _joinDate = DateTime.now();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
      // Keep default values on error
      _joinDate = DateTime.now();
    }
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

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? true; // Default to dark
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme preference: $e');
      }
      // Keep default value
    }
  }

  /// Toggle theme and save preference
  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    
    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkTheme', _isDarkTheme);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving theme preference: $e');
      }
    }
  }
  
  // User profile methods
  Future<void> updateUserName(String newName) async {
    try {
      _userName = newName;
      notifyListeners();
      
      // Save to Firestore
      await _firestoreUserService.updateUserProfile(userName: newName);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user name: $e');
      }
      // Revert on error
      await _loadUserProfile();
      rethrow;
    }
  }
  
  Future<void> updateAvatar(int avatarIndex) async {
    try {
      _avatarIndex = avatarIndex;
      notifyListeners();
      
      // Save to Firestore (avatarIndex - which avatar is selected)
      await _firestoreUserService.updateUserProfile(avatarIndex: avatarIndex);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating avatar: $e');
      }
      // Revert on error
      await _loadUserProfile();
      rethrow;
    }
  }
  
  Future<void> updateAvatarUrl(String? url) async {
    try {
      _avatarUrl = url;
      notifyListeners();
      
      // Save to Firestore (optional - local file path reference)
      await _firestoreUserService.updateUserProfile(avatarUrl: url);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating avatar URL: $e');
      }
      // Revert on error
      await _loadUserProfile();
      rethrow;
    }
  }
  
  Future<void> selectCharacter(int characterId) async {
    try {
      _selectedCharacterId = characterId;
      notifyListeners();
      
      // Save to Firestore
      await _firestoreUserService.updateUserProfile(selectedCharacterId: characterId);
    } catch (e) {
      if (kDebugMode) {
        print('Error selecting character: $e');
      }
      // Revert on error
      await _loadUserProfile();
      rethrow;
    }
  }
  
  Future<void> upgradeToPro() async {
    try {
      _isProMember = true;
      notifyListeners();
      
      // Save to Firestore (CRITICAL - payment made)
      await _firestoreUserService.updateUserProfile(isProMember: true);
    } catch (e) {
      if (kDebugMode) {
        print('Error upgrading to Pro: $e');
      }
      // Revert on error
      await _loadUserProfile();
      rethrow;
    }
  }
  
  /// Refresh user profile from Firestore
  Future<void> refreshUserProfile() async {
    await _loadUserProfile();
  }
}

