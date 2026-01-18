import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firebase_service.dart';
import '../models/user_profile_model.dart';
import '../models/user_settings_model.dart';

/// Service for Firestore user profile and settings operations
class FirestoreUserService {
  FirebaseFirestore? get _firestore => FirebaseService.firestore;
  FirebaseAuth? get _auth => FirebaseService.auth;

  /// Get current user ID or throw exception
  String get _currentUserId {
    if (_auth == null) {
      throw Exception('Firebase Auth not initialized');
    }
    final user = _auth!.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  // ==================== User Profile Operations ====================

  /// Get user profile from Firestore
  Future<UserProfileModel?> getUserProfile([String? userId]) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      final uid = userId ?? _currentUserId;
      final doc = await _firestore!.collection('users').doc(uid).get();

      if (!doc.exists) {
        return null;
      }

      return UserProfileModel.fromFirestore(doc.data()!, uid);
    } catch (e) {
      throw Exception('Error getting user profile: $e');
    }
  }
  
  /// Get user profile stream for real-time updates
  Stream<UserProfileModel?> getUserProfileStream([String? userId]) {
    if (_firestore == null) {
      return Stream.value(null);
    }
    try {
      final uid = userId ?? _currentUserId;
      return _firestore!.collection('users').doc(uid).snapshots().map(
        (doc) {
          if (!doc.exists) {
            return null;
          }
          return UserProfileModel.fromFirestore(doc.data()!, uid);
        },
      );
    } catch (e) {
      return Stream.value(null);
    }
  }

  /// Create or update user profile
  Future<void> saveUserProfile(UserProfileModel profile) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      await _firestore!
          .collection('users')
          .doc(profile.userId)
          .set(profile.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving user profile: $e');
    }
  }

  /// Update specific user profile fields
  Future<void> updateUserProfile({
    String? userName,
    String? avatarUrl,
    int? avatarIndex,
    bool? isProMember,
    int? selectedCharacterId,
    List<int>? purchasedCharacters,
  }) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      final uid = _currentUserId;
      final updates = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (userName != null) updates['userName'] = userName;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      if (avatarIndex != null) updates['avatarIndex'] = avatarIndex;
      if (isProMember != null) updates['isProMember'] = isProMember;
      if (selectedCharacterId != null) updates['selectedCharacterId'] = selectedCharacterId;
      if (purchasedCharacters != null) updates['purchasedCharacters'] = purchasedCharacters;

      await _firestore!.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }
  
  /// Add character to purchased characters list
  Future<void> addPurchasedCharacter(int characterId) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      final uid = _currentUserId;
      final profile = await getUserProfile(uid);
      if (profile == null) {
        throw Exception('User profile not found');
      }
      
      final updatedList = List<int>.from(profile.purchasedCharacters);
      if (!updatedList.contains(characterId)) {
        updatedList.add(characterId);
        await updateUserProfile(purchasedCharacters: updatedList);
      }
    } catch (e) {
      throw Exception('Error adding purchased character: $e');
    }
  }

  // ==================== User Settings Operations ====================

  /// Get user settings from Firestore
  Future<UserSettingsModel?> getUserSettings([String? userId]) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      final uid = userId ?? _currentUserId;
      final doc = await _firestore!
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('user_settings')
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserSettingsModel.fromFirestore(doc.data()!, uid);
    } catch (e) {
      throw Exception('Error getting user settings: $e');
    }
  }

  /// Create or update user settings
  Future<void> saveUserSettings(UserSettingsModel settings) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      await _firestore!
          .collection('users')
          .doc(settings.userId)
          .collection('settings')
          .doc('user_settings')
          .set(settings.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving user settings: $e');
    }
  }

  /// Update specific user settings fields
  Future<void> updateUserSettings({
    bool? isDarkTheme,
    bool? notificationsEnabled,
    String? language,
    String? region,
  }) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    try {
      final uid = _currentUserId;
      final updates = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (isDarkTheme != null) updates['isDarkTheme'] = isDarkTheme;
      if (notificationsEnabled != null) updates['notificationsEnabled'] = notificationsEnabled;
      if (language != null) updates['language'] = language;
      if (region != null) updates['region'] = region;

      await _firestore!
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('user_settings')
          .update(updates);
    } catch (e) {
      throw Exception('Error updating user settings: $e');
    }
  }

  // ==================== User Creation ====================

  /// Create initial user profile and settings
  Future<void> createUserProfile({
    required String userName,
    int avatarIndex = 0,
  }) async {
    try {
      final uid = _currentUserId;
      final now = DateTime.now();

      // Create user profile
      final profile = UserProfileModel(
        userId: uid,
        userName: userName,
        avatarIndex: avatarIndex,
        isProMember: false,
        joinDate: now,
      );
      await saveUserProfile(profile);

      // Create default settings
      final settings = UserSettingsModel(
        userId: uid,
        isDarkTheme: true,
        notificationsEnabled: true,
        language: 'tr',
      );
      await saveUserSettings(settings);
    } catch (e) {
      throw Exception('Error creating user profile: $e');
    }
  }
}
