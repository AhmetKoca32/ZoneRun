import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int avatarIndex;
  final DateTime joinDate;
  final int? selectedCharacterId;
  final List<int> purchasedCharacters;
  final DateTime? lastUpdated;
  // Görev/ödül: seçilen ve kazanılanlar
  final String? selectedTitleId;
  final int selectedBannerId;
  final List<String> unlockedTitleIds;
  final List<int> unlockedAvatarIds; // premium avatar id'leri (12+)
  final List<int> unlockedBannerIds;

  const UserProfileModel({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.avatarIndex,
    required this.joinDate,
    this.selectedCharacterId,
    this.purchasedCharacters = const [],
    this.lastUpdated,
    this.selectedTitleId,
    this.selectedBannerId = 0,
    this.unlockedTitleIds = const [],
    this.unlockedAvatarIds = const [],
    this.unlockedBannerIds = const [],
  });

  /// Create from Firestore document
  factory UserProfileModel.fromFirestore(
    Map<String, dynamic> data,
    String userId,
  ) {
    List<int> purchasedChars = [];
    if (data['purchasedCharacters'] != null) {
      final chars = data['purchasedCharacters'];
      if (chars is List) {
        purchasedChars = chars.map((e) => (e as num).toInt()).toList();
      }
    }
    List<String> titleIds = [];
    if (data['unlockedTitleIds'] != null) {
      final list = data['unlockedTitleIds'];
      if (list is List) {
        titleIds = list.map((e) => e.toString()).toList();
      }
    }
    List<int> avatarIds = [];
    if (data['unlockedAvatarIds'] != null) {
      final list = data['unlockedAvatarIds'];
      if (list is List) {
        avatarIds = list.map((e) => (e as num).toInt()).toList();
      }
    }
    List<int> bannerIds = [];
    if (data['unlockedBannerIds'] != null) {
      final list = data['unlockedBannerIds'];
      if (list is List) {
        bannerIds = list.map((e) => (e as num).toInt()).toList();
      }
    }
    return UserProfileModel(
      userId: userId,
      userName: data['userName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      avatarIndex: data['avatarIndex'] as int? ?? 0,
      joinDate: data['joinDate'] != null
          ? (data['joinDate'] as Timestamp).toDate()
          : DateTime.now(),
      selectedCharacterId: data['selectedCharacterId'] as int?,
      purchasedCharacters: purchasedChars,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
      selectedTitleId: data['selectedTitleId'] as String?,
      selectedBannerId: data['selectedBannerId'] as int? ?? 0,
      unlockedTitleIds: titleIds,
      unlockedAvatarIds: avatarIds,
      unlockedBannerIds: bannerIds,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'avatarUrl': avatarUrl,
      'avatarIndex': avatarIndex,
      'joinDate': Timestamp.fromDate(joinDate),
      'selectedCharacterId': selectedCharacterId,
      'purchasedCharacters': purchasedCharacters,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
      'selectedTitleId': selectedTitleId,
      'selectedBannerId': selectedBannerId,
      'unlockedTitleIds': unlockedTitleIds,
      'unlockedAvatarIds': unlockedAvatarIds,
      'unlockedBannerIds': unlockedBannerIds,
    };
  }

  /// Create a copy with updated fields
  UserProfileModel copyWith({
    String? userName,
    String? avatarUrl,
    int? avatarIndex,
    DateTime? joinDate,
    int? selectedCharacterId,
    List<int>? purchasedCharacters,
    DateTime? lastUpdated,
    String? selectedTitleId,
    int? selectedBannerId,
    List<String>? unlockedTitleIds,
    List<int>? unlockedAvatarIds,
    List<int>? unlockedBannerIds,
  }) {
    return UserProfileModel(
      userId: userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      joinDate: joinDate ?? this.joinDate,
      selectedCharacterId: selectedCharacterId ?? this.selectedCharacterId,
      purchasedCharacters: purchasedCharacters ?? this.purchasedCharacters,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      selectedTitleId: selectedTitleId ?? this.selectedTitleId,
      selectedBannerId: selectedBannerId ?? this.selectedBannerId,
      unlockedTitleIds: unlockedTitleIds ?? this.unlockedTitleIds,
      unlockedAvatarIds: unlockedAvatarIds ?? this.unlockedAvatarIds,
      unlockedBannerIds: unlockedBannerIds ?? this.unlockedBannerIds,
    );
  }
}
