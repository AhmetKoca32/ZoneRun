import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingsModel {
  final String userId;
  final bool isDarkTheme;
  final bool notificationsEnabled;
  final String language;
  final String? region;
  final DateTime? lastUpdated;

  const UserSettingsModel({
    required this.userId,
    required this.isDarkTheme,
    this.notificationsEnabled = true,
    this.language = 'tr',
    this.region,
    this.lastUpdated,
  });

  /// Create from Firestore document
  factory UserSettingsModel.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserSettingsModel(
      userId: userId,
      isDarkTheme: data['isDarkTheme'] as bool? ?? true,
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      language: data['language'] as String? ?? 'tr',
      region: data['region'] as String?,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'isDarkTheme': isDarkTheme,
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'region': region,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
    };
  }

  /// Create a copy with updated fields
  UserSettingsModel copyWith({
    bool? isDarkTheme,
    bool? notificationsEnabled,
    String? language,
    String? region,
    DateTime? lastUpdated,
  }) {
    return UserSettingsModel(
      userId: userId,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      region: region ?? this.region,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
