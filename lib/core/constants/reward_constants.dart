/// Görev ve ödül sabitleri: tek seferlik görevler (avatar/banner),
/// günlük/haftalık/aylık görevler (sıfat).
class RewardConstants {
  RewardConstants._();

  // --- Avatarlar ---
  /// Varsayılan avatar sayısı (0..defaultAvatarCount-1 her zaman açık)
  static const int defaultAvatarCount = 8;

  /// Premium (aksesuar/overlay) ID'leri görevle açılır (8, 9, ...)
  static const int premiumAvatarStartId = 8;

  /// Görevle açılan premium avatar sayısı (ID 8 … 15 → avatar_9 … avatar_16)
  static const int premiumAvatarCount = 8;

  // --- Bannerlar ---
  /// Varsayılan banner ID (0) her zaman açık
  static const int defaultBannerId = 0;

  /// Görevle açılan banner sayısı (1, 2, 3)
  static const int rewardBannerCount = 3;

  // --- Sıfatlar (günlük/haftalık/aylık ödül) ---
  /// Sıfat ID → görünen metin (havalı, kısa, banner’da iyi görünsün)
  static const Map<String, String> titleLabels = {
    'daily_runner': 'Rüzgar',
    'weekly_active': 'Momentum',
    'monthly_champion': 'Ayın Şampiyonu',
    'week_streak_3': 'Ateş Yakıldı',
    'week_streak_5': 'Demir İrade',
    'month_runs_5': 'Ayın Avcısı',
    'month_runs_10': 'Tam Gaz',
  };

  // --- Tek seferlik görev tanımları ---
  /// Görev tipi
  static const String taskTypeOneTime = 'one_time';
  static const String taskTypeDaily = 'daily';
  static const String taskTypeWeekly = 'weekly';
  static const String taskTypeMonthly = 'monthly';

  /// Ödül tipi
  static const String rewardTypeAvatar = 'avatar';
  static const String rewardTypeBanner = 'banner';
  static const String rewardTypeTitle = 'title';
  static const String rewardTypeAccessory = 'accessory';
}
