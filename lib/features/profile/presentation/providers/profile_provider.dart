import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/reward_constants.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../history/data/services/history_service.dart';
import '../../data/services/firestore_user_service.dart';
import '../../data/services/profile_service.dart';

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
  int _avatarIndex = 0;
  DateTime? _joinDate;
  int? _selectedCharacterId;
  List<int> _purchasedCharacters = [];
  bool _isProfileLoading = false;
  // Görev/ödül: seçilen ve kazanılanlar
  String? _selectedTitleId;
  int _selectedBannerId = 0;
  List<String> _unlockedTitleIds = [];
  List<int> _unlockedAvatarIds = [];
  List<int> _unlockedBannerIds = [];
  List<int> _selectedAccessoryIds = [];
  List<int> _unlockedAccessoryIds = [];
  double? _weightKg;

  // Stream subscription for auth state changes
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription? _firestoreListenerSubscription;

  Map<String, dynamic>? get userStats => _userStats;
  bool get isLoading => _isLoading;
  int get streak => _streak;
  bool get isDarkTheme => _isDarkTheme;
  String get userName => _userName;
  String? get avatarUrl => _avatarUrl;
  int get avatarIndex => _avatarIndex;
  DateTime? get joinDate => _joinDate;
  int? get selectedCharacterId => _selectedCharacterId;
  List<int> get purchasedCharacters => _purchasedCharacters;
  bool get isProfileLoading => _isProfileLoading;
  String? get selectedTitleId => _selectedTitleId;
  int get selectedBannerId => _selectedBannerId;
  List<String> get unlockedTitleIds => _unlockedTitleIds;
  List<int> get unlockedAvatarIds => _unlockedAvatarIds;
  List<int> get unlockedBannerIds => _unlockedBannerIds;
  List<int> get selectedAccessoryIds =>
      List.unmodifiable(_selectedAccessoryIds);
  List<int> get unlockedAccessoryIds => _unlockedAccessoryIds;
  double? get weightKg => _weightKg;

  ProfileProvider() {
    _loadProfileData();
    _loadThemePreference();
    _setupAuthStateListener();

    // If user is already authenticated (e.g., app restart), load profile immediately
    if (FirebaseService.isLoggedIn) {
      if (kDebugMode) {
        print('✅ User already authenticated, loading profile immediately...');
      }
      _loadLocalProfile();
    }
  }

  /// Setup listener for Firebase Auth state changes
  /// Only loads profile when user is authenticated
  void _setupAuthStateListener() {
    try {
      _authStateSubscription = FirebaseService.auth.authStateChanges().listen(
        (User? user) {
          if (user != null) {
            if (kDebugMode) {
              print('✅ User authenticated, loading profile...');
            }
            _loadLocalProfile();
          } else {
            // User logged out - clear profile data and cancel listener
            if (kDebugMode) {
              print('⚠️ User logged out, clearing profile...');
            }
            _clearUserProfile();
            _cancelFirestoreListener();
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Error in auth state listener: $error');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up auth state listener: $e');
      }
    }
  }

  /// Cancel Firestore listener subscription (artık kullanılmıyor; profil yerelde)
  void _cancelFirestoreListener() {
    _firestoreListenerSubscription?.cancel();
    _firestoreListenerSubscription = null;
  }

  /// Clear user profile data when user logs out
  void _clearUserProfile() {
    _userName = 'Ahmet Koca';
    _avatarUrl = null;
    _avatarIndex = 0;
    _joinDate = null;
    _selectedCharacterId = null;
    _purchasedCharacters = [];
    _isProfileLoading = false;
    _selectedTitleId = null;
    _selectedBannerId = 0;
    _unlockedTitleIds = [];
    _unlockedAvatarIds = [];
    _unlockedBannerIds = [];
    _selectedAccessoryIds = [];
    _unlockedAccessoryIds = [];
    _weightKg = null;
    notifyListeners();
  }

  /// Load user profile from local storage (SharedPreferences). Firestore kullanılmıyor.
  Future<void> _loadLocalProfile() async {
    if (!FirebaseService.isLoggedIn) {
      if (kDebugMode) print('⚠️ Cannot load profile: User not authenticated');
      return;
    }

    _isProfileLoading = true;
    notifyListeners();

    try {
      final uid = FirebaseService.auth.currentUser?.uid;
      if (uid == null) return;
      final prefs = await SharedPreferences.getInstance();
      final p = _prefsKeyProfile;

      final userName = prefs.getString('${p}userName_$uid');
      if (userName != null && userName.isNotEmpty) {
        _userName = userName;
        _avatarIndex = prefs.getInt('${p}avatarIndex_$uid') ?? 0;
        _avatarUrl = prefs.getString('${p}avatarUrl_$uid');
        final joinStr = prefs.getString('${p}joinDate_$uid');
        _joinDate = joinStr != null
            ? DateTime.tryParse(joinStr)
            : DateTime.now();
        _selectedTitleId = prefs.getString('${p}selectedTitleId_$uid');
        if (_selectedTitleId != null && _selectedTitleId!.isEmpty)
          _selectedTitleId = null;
        _selectedBannerId = prefs.getInt('${p}selectedBannerId_$uid') ?? 0;
        _unlockedTitleIds =
            prefs.getStringList('${p}unlockedTitleIds_$uid') ?? [];
        _unlockedAvatarIds =
            (prefs.getStringList('${p}unlockedAvatarIds_$uid') ?? [])
                .map((e) => int.tryParse(e) ?? 0)
                .where((e) => e > 0)
                .toList();
        _unlockedBannerIds =
            (prefs.getStringList('${p}unlockedBannerIds_$uid') ?? [])
                .map((e) => int.tryParse(e) ?? 0)
                .where((e) => e >= 0)
                .toList();
        _migrateRewardsLockedIfNeeded(prefs, uid);
        if (kDebugMode) {
          _unlockedBannerIds = List.generate(
            RewardConstants.rewardBannerCount,
            (i) => 1 + i,
          );
          await _saveLocalProfile();
          print('✅ Debug: tüm bannerlar açıldı');
        }
        if (kDebugMode) print('✅ Profile loaded from local');
      } else {
        // İlk giriş: varsayılan profil oluştur
        _userName =
            FirebaseService.auth.currentUser?.displayName ?? 'Kullanıcı';
        _avatarIndex = 0;
        _avatarUrl = null;
        _joinDate = DateTime.now();
        _selectedTitleId = null;
        _selectedBannerId = 0;
        _unlockedTitleIds = [];
        _unlockedAvatarIds = [];
        _unlockedBannerIds = [];
        await _saveLocalProfile();
        // Tüm ödül banner'ları açık (eklenen görseller kullanılabilsin)
        _unlockedBannerIds = List.generate(
          RewardConstants.rewardBannerCount,
          (i) => 1 + i,
        );
        await _saveLocalProfile();
        if (kDebugMode) print('✅ Default profile created (local)');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error loading profile: $e');
      _joinDate = DateTime.now();
    } finally {
      _isProfileLoading = false;
      await _loadThemePreference();
      notifyListeners();
      await _loadProfileData();
    }
  }

  Future<void> _saveLocalProfile() async {
    final uid = FirebaseService.auth.currentUser?.uid;
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    final p = _prefsKeyProfile;
    await prefs.setString('${p}userName_$uid', _userName);
    await prefs.setInt('${p}avatarIndex_$uid', _avatarIndex);
    await prefs.setString('${p}avatarUrl_$uid', _avatarUrl ?? '');
    await prefs.setString(
      '${p}joinDate_$uid',
      _joinDate?.toIso8601String() ?? '',
    );
    await prefs.setString('${p}selectedTitleId_$uid', _selectedTitleId ?? '');
    await prefs.setInt('${p}selectedBannerId_$uid', _selectedBannerId);
    await prefs.setStringList('${p}unlockedTitleIds_$uid', _unlockedTitleIds);
    await prefs.setStringList(
      '${p}unlockedAvatarIds_$uid',
      _unlockedAvatarIds.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList(
      '${p}unlockedBannerIds_$uid',
      _unlockedBannerIds.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _loadProfileData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userStats = await _profileService.getUserStats(weightKg: _weightKg);
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

  static const String _prefsKeyWeight = 'weightKg';
  static const String _prefsKeySelectedAccessoryIds = 'selectedAccessoryIds';
  static const String _prefsKeyUnlockedAccessoryIds = 'unlockedAccessoryIds';
  static const String _prefsKeyProfile = 'profile_';

  /// Bir kerelik: ödüller sadece görevle açılsın diye eski "hepsi açık" verisini sıfırlamak için.
  static const int _rewardsSchemaVersion = 3;

  /// Load theme and local-only prefs (weight, aksesuar) from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = FirebaseService.auth.currentUser?.uid;
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? true; // Default to dark
      _weightKg = uid != null
          ? prefs.getDouble('${_prefsKeyWeight}_$uid')
          : null;
      if (uid != null) {
        await _migrateRewardsLockedIfNeeded(prefs, uid);
        final selectedList = prefs.getStringList(
          '${_prefsKeySelectedAccessoryIds}_$uid',
        );
        _selectedAccessoryIds =
            selectedList
                ?.map((e) => int.tryParse(e) ?? 0)
                .where((e) => e > 0)
                .toList() ??
            [];
        final list = prefs.getStringList(
          '${_prefsKeyUnlockedAccessoryIds}_$uid',
        );
        _unlockedAccessoryIds =
            list
                ?.map((e) => int.tryParse(e) ?? 0)
                .where((e) => e > 0)
                .toList() ??
            [];
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme preference: $e');
      }
      // Keep default value
    }
  }

  /// Eski "tüm ödüller açık" verisini bir kerelik sıfırlar; aksesuar, sıfat, avatar ve banner sadece görevle açılsın.
  Future<void> _migrateRewardsLockedIfNeeded(
    SharedPreferences prefs,
    String uid,
  ) async {
    final key = '${_prefsKeyProfile}rewards_schema_$uid';
    final version = prefs.getInt(key) ?? 0;
    if (version >= _rewardsSchemaVersion) return;
    _unlockedTitleIds = [];
    _unlockedAccessoryIds = [];
    _unlockedAvatarIds = [];
    _unlockedBannerIds = [];
    await prefs.setStringList('${_prefsKeyProfile}unlockedTitleIds_$uid', []);
    await prefs.setStringList('${_prefsKeyUnlockedAccessoryIds}_$uid', []);
    await prefs.setStringList('${_prefsKeyProfile}unlockedAvatarIds_$uid', []);
    await prefs.setStringList('${_prefsKeyProfile}unlockedBannerIds_$uid', []);
    await prefs.setInt(key, _rewardsSchemaVersion);
    if (kDebugMode)
      print(
        '✅ Rewards migration: titles, accessories, avatars and banners locked',
      );
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
  
  // User profile methods – hepsi yerelde (SharedPreferences) saklanır
  Future<void> updateUserName(String newName) async {
    try {
      _userName = newName;
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error updating user name: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  Future<void> updateAvatar(int avatarIndex) async {
    try {
      _avatarIndex = avatarIndex;
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error updating avatar: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  Future<void> updateAvatarUrl(String? url) async {
    try {
      _avatarUrl = url;
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error updating avatar URL: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  Future<void> selectCharacter(int characterId) async {
    try {
      _selectedCharacterId = characterId;
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error selecting character: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  Future<void> updateSelectedTitle(String? titleId) async {
    try {
      _selectedTitleId = titleId;
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error updating selected title: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  Future<void> updateSelectedBanner(int bannerId) async {
    try {
      _selectedBannerId = bannerId;
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error updating selected banner: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  /// Görevle sıfat açıldığında yerel listeye ekler.
  Future<void> addUnlockedTitleLocally(String titleId) async {
    if (_unlockedTitleIds.contains(titleId)) return;
    try {
      _unlockedTitleIds.add(titleId);
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error addUnlockedTitleLocally: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  /// Görevle premium avatar açıldığında yerel listeye ekler.
  Future<void> addUnlockedAvatarLocally(int avatarId) async {
    if (_unlockedAvatarIds.contains(avatarId)) return;
    try {
      _unlockedAvatarIds.add(avatarId);
      _unlockedAvatarIds.sort();
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error addUnlockedAvatarLocally: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  /// Görevle banner açıldığında yerel listeye ekler.
  Future<void> addUnlockedBannerLocally(int bannerId) async {
    if (_unlockedBannerIds.contains(bannerId)) return;
    try {
      _unlockedBannerIds.add(bannerId);
      _unlockedBannerIds.sort();
      notifyListeners();
      await _saveLocalProfile();
    } catch (e) {
      if (kDebugMode) print('Error addUnlockedBannerLocally: $e');
      await _loadLocalProfile();
      rethrow;
    }
  }

  /// Aksesuarı seçime ekler/çıkarır (toggle). Birden fazla seçilebilir. id=0 "Yok" tüm seçimi temizler. Yerelde saklanır.
  Future<void> toggleAccessory(int accessoryId) async {
    try {
      if (accessoryId == 0) {
        _selectedAccessoryIds.clear();
      } else if (_selectedAccessoryIds.contains(accessoryId)) {
        _selectedAccessoryIds.remove(accessoryId);
      } else {
        _selectedAccessoryIds.add(accessoryId);
        _selectedAccessoryIds.sort();
      }
      notifyListeners();
      final uid = FirebaseService.auth.currentUser?.uid;
      if (uid != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
          '${_prefsKeySelectedAccessoryIds}_$uid',
          _selectedAccessoryIds.map((e) => e.toString()).toList(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling accessory: $e');
      }
      await _loadThemePreference();
      rethrow;
    }
  }

  /// (Sadece debug) Sıfat kilidini test için açar. Görev tamamlamadan Ödüller > Sıfatlar’da denemek için.
  Future<void> unlockTitleForTesting(String titleId) async {
    if (!kDebugMode) return;
    try {
      await addUnlockedTitleLocally(titleId);
    } catch (e) {
      if (kDebugMode) print('Error unlockTitleForTesting: $e');
    }
  }

  /// Görevle aksesuar açıldığında yerel listeye ekler (SharedPreferences).
  Future<void> addUnlockedAccessoryLocally(int accessoryId) async {
    if (_unlockedAccessoryIds.contains(accessoryId)) return;
    try {
      _unlockedAccessoryIds.add(accessoryId);
      _unlockedAccessoryIds.sort();
      notifyListeners();
      final uid = FirebaseService.auth.currentUser?.uid;
      if (uid != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
          '${_prefsKeyUnlockedAccessoryIds}_$uid',
          _unlockedAccessoryIds.map((e) => e.toString()).toList(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding unlocked accessory: $e');
      }
      await _loadThemePreference();
      rethrow;
    }
  }

  /// Update weight (kg). Pass null to clear. Stored locally only (SharedPreferences, per user).
  Future<void> updateWeightKg(double? kg) async {
    try {
      _weightKg = kg;
      notifyListeners();
      final uid = FirebaseService.auth.currentUser?.uid;
      if (uid == null) return;
      final prefs = await SharedPreferences.getInstance();
      final key = '${_prefsKeyWeight}_$uid';
      if (kg != null) {
        await prefs.setDouble(key, kg);
      } else {
        await prefs.remove(key);
      }
      await _loadProfileData();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating weight: $e');
      }
      await _loadThemePreference();
      rethrow;
    }
  }
  
  /// Refresh user profile from local storage
  Future<void> refreshUserProfile() async {
    await _loadLocalProfile();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _cancelFirestoreListener();
    super.dispose();
  }
}

