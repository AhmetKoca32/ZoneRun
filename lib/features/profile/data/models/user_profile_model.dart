import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int avatarIndex;
  final bool isProMember;
  final DateTime joinDate;
  final int? selectedCharacterId;
  final List<int> purchasedCharacters; // Array of character IDs
  final DateTime? lastUpdated;

  const UserProfileModel({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.avatarIndex,
    required this.isProMember,
    required this.joinDate,
    this.selectedCharacterId,
    this.purchasedCharacters = const [],
    this.lastUpdated,
  });

  /// Create from Firestore document
  factory UserProfileModel.fromFirestore(Map<String, dynamic> data, String userId) {
    // Handle purchasedCharacters - can be List<int> or List<dynamic>
    List<int> purchasedChars = [];
    if (data['purchasedCharacters'] != null) {
      final chars = data['purchasedCharacters'];
      if (chars is List) {
        purchasedChars = chars.map((e) => (e as num).toInt()).toList();
      }
    }
    
    return UserProfileModel(
      userId: userId,
      userName: data['userName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      avatarIndex: data['avatarIndex'] as int? ?? 0,
      isProMember: data['isProMember'] as bool? ?? false,
      joinDate: data['joinDate'] != null
          ? (data['joinDate'] as Timestamp).toDate()
          : DateTime.now(),
      selectedCharacterId: data['selectedCharacterId'] as int?,
      purchasedCharacters: purchasedChars,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'avatarUrl': avatarUrl,
      'avatarIndex': avatarIndex,
      'isProMember': isProMember,
      'joinDate': Timestamp.fromDate(joinDate),
      'selectedCharacterId': selectedCharacterId,
      'purchasedCharacters': purchasedCharacters,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
    };
  }

  /// Create a copy with updated fields
  UserProfileModel copyWith({
    String? userName,
    String? avatarUrl,
    int? avatarIndex,
    bool? isProMember,
    DateTime? joinDate,
    int? selectedCharacterId,
    List<int>? purchasedCharacters,
    DateTime? lastUpdated,
  }) {
    return UserProfileModel(
      userId: userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      isProMember: isProMember ?? this.isProMember,
      joinDate: joinDate ?? this.joinDate,
      selectedCharacterId: selectedCharacterId ?? this.selectedCharacterId,
      purchasedCharacters: purchasedCharacters ?? this.purchasedCharacters,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
