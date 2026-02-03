import '../../../../core/constants/overlay_constants.dart';
import '../../../../core/constants/reward_constants.dart';
import '../models/task_model.dart';

/// Uygulama içi görev tanımları: tek seferlik (aksesuar / avatar / banner / sıfat)
/// ve günlük / haftalık / aylık (sıfat).
/// Ödül hiyerarşisi: başlangıç → aksesuar, haftalık/aylık → sıfat, orta → avatar, en zor → banner.
class TaskDefinitions {
  TaskDefinitions._();

  static List<TaskDefinition> get all => [...oneTimeTasks, ...recurringTasks];

  /// Tek seferlik görevler: aksesuar (kolay), avatar (orta), banner (zor), sıfat (seri)
  static final List<TaskDefinition> oneTimeTasks = [
    // --- Başlangıç: aksesuar (5) ---
    TaskDefinition(
      id: 'one_first_run',
      title: 'İlk Adım',
      description: 'İlk koşunu tamamla',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAccessory,
      rewardId: '1',
      target: const TaskTarget(type: 'polygon_count', value: 1),
    ),
    TaskDefinition(
      id: 'one_1km',
      title: 'İlk Kilometre',
      description: 'Toplam 1 km koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAccessory,
      rewardId: '2',
      target: const TaskTarget(type: 'total_distance_m', value: 1000),
    ),
    TaskDefinition(
      id: 'one_2streak',
      title: '2 Gün Seri',
      description: '2 gün üst üste koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAccessory,
      rewardId: '3',
      target: const TaskTarget(type: 'streak_days', value: 2),
    ),
    TaskDefinition(
      id: 'one_3runs',
      title: '3 Koşu',
      description: '3 koşu tamamla',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAccessory,
      rewardId: '4',
      target: const TaskTarget(type: 'polygon_count', value: 3),
    ),
    TaskDefinition(
      id: 'one_3streak',
      title: '3 Gün Seri',
      description: '3 gün üst üste koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAccessory,
      rewardId: '5',
      target: const TaskTarget(type: 'streak_days', value: 3),
    ),
    // --- Orta: avatar (4, ileride ödül avatar görselleri eklenecek) ---
    TaskDefinition(
      id: 'one_10runs',
      title: '10 Koşu',
      description: 'Toplam 10 koşu tamamla',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '8',
      target: const TaskTarget(type: 'polygon_count', value: 10),
    ),
    TaskDefinition(
      id: 'one_25km',
      title: '25 km Ustası',
      description: 'Toplam 25 km koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '9',
      target: const TaskTarget(type: 'total_distance_m', value: 25000),
    ),
    TaskDefinition(
      id: 'one_7streak',
      title: '7 Gün Seri',
      description: '7 gün üst üste koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '10',
      target: const TaskTarget(type: 'streak_days', value: 7),
    ),
    TaskDefinition(
      id: 'one_20runs',
      title: '20 Koşu',
      description: 'Toplam 20 koşu tamamla',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '11',
      target: const TaskTarget(type: 'polygon_count', value: 20),
    ),
    TaskDefinition(
      id: 'one_30runs',
      title: '30 Koşu',
      description: 'Toplam 30 koşu tamamla',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '12',
      target: const TaskTarget(type: 'polygon_count', value: 30),
    ),
    TaskDefinition(
      id: 'one_50km_avatar',
      title: '50 km Koşucu',
      description: 'Toplam 50 km koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '13',
      target: const TaskTarget(type: 'total_distance_m', value: 50000),
    ),
    TaskDefinition(
      id: 'one_10streak',
      title: '10 Gün Seri',
      description: '10 gün üst üste koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '14',
      target: const TaskTarget(type: 'streak_days', value: 10),
    ),
    TaskDefinition(
      id: 'one_50runs',
      title: '50 Koşu',
      description: 'Toplam 50 koşu tamamla',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeAvatar,
      rewardId: '15',
      target: const TaskTarget(type: 'polygon_count', value: 50),
    ),
    // --- En zor: banner (3) ---
    TaskDefinition(
      id: 'one_50km_banner',
      title: '50 km',
      description: 'Toplam 50 km koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeBanner,
      rewardId: '1',
      target: const TaskTarget(type: 'total_distance_m', value: 50000),
    ),
    TaskDefinition(
      id: 'one_100km_banner',
      title: '100 km',
      description: 'Toplam 100 km koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeBanner,
      rewardId: '2',
      target: const TaskTarget(type: 'total_distance_m', value: 100000),
    ),
    TaskDefinition(
      id: 'one_200km_banner',
      title: '200 km',
      description: 'Toplam 200 km koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeBanner,
      rewardId: '3',
      target: const TaskTarget(type: 'total_distance_m', value: 200000),
    ),
    // --- Tek seferlik sıfat (seri) ---
    TaskDefinition(
      id: 'one_streak_3_title',
      title: '3 Gün Seri (Sıfat)',
      description: '3 gün üst üste koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'week_streak_3',
      target: const TaskTarget(type: 'streak_days', value: 3),
    ),
    TaskDefinition(
      id: 'one_streak_5_title',
      title: '5 Gün Seri (Sıfat)',
      description: '5 gün üst üste koş',
      taskType: RewardConstants.taskTypeOneTime,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'week_streak_5',
      target: const TaskTarget(type: 'streak_days', value: 5),
    ),
  ];

  /// Günlük / haftalık / aylık görevler → sıfat ödülü
  static final List<TaskDefinition> recurringTasks = [
    TaskDefinition(
      id: 'daily_run',
      title: 'Günün Koşucusu',
      description: 'Bugün en az 1 koşu tamamla',
      taskType: RewardConstants.taskTypeDaily,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'daily_runner',
      target: const TaskTarget(type: 'today_count', value: 1),
    ),
    TaskDefinition(
      id: 'weekly_3',
      title: 'Haftanın Aktifi',
      description: 'Bu hafta 3 koşu tamamla',
      taskType: RewardConstants.taskTypeWeekly,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'weekly_active',
      target: const TaskTarget(type: 'week_count', value: 3),
    ),
    TaskDefinition(
      id: 'monthly_5',
      title: 'Ayın 5 Koşusu',
      description: 'Bu ay 5 koşu tamamla',
      taskType: RewardConstants.taskTypeMonthly,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'month_runs_5',
      target: const TaskTarget(type: 'month_count', value: 5),
    ),
    TaskDefinition(
      id: 'monthly_10',
      title: 'Ayın 10 Koşusu',
      description: 'Bu ay 10 koşu tamamla',
      taskType: RewardConstants.taskTypeMonthly,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'month_runs_10',
      target: const TaskTarget(type: 'month_count', value: 10),
    ),
    TaskDefinition(
      id: 'monthly_15',
      title: 'Ayın Fatihi',
      description: 'Bu ay 15 koşu tamamla',
      taskType: RewardConstants.taskTypeMonthly,
      rewardType: RewardConstants.rewardTypeTitle,
      rewardId: 'monthly_champion',
      target: const TaskTarget(type: 'month_count', value: 15),
    ),
  ];

  /// Bu ödülü veren görevi döndürür (kilitli öğede "ne yapınca açılır" göstermek için).
  static TaskDefinition? getTaskForReward(String rewardType, String rewardId) {
    for (final t in all) {
      if (t.rewardType == rewardType && t.rewardId == rewardId) return t;
    }
    return null;
  }

  /// Görev tamamlanınca kazanılacak ödülün görünen adı (görev kartında göstermek için).
  static String rewardLabel(String rewardType, String rewardId) {
    switch (rewardType) {
      case RewardConstants.rewardTypeTitle:
        return RewardConstants.titleLabels[rewardId] ?? rewardId;
      case RewardConstants.rewardTypeAccessory:
        final id = int.tryParse(rewardId);
        return id != null ? OverlayConstants.overlayLabel(id) : rewardId;
      case RewardConstants.rewardTypeAvatar:
        return 'Premium Avatar';
      case RewardConstants.rewardTypeBanner:
        return 'Banner ${int.tryParse(rewardId) ?? rewardId}';
      default:
        return rewardId;
    }
  }

  /// Hedefi kullanıcıya okunabilir metin yapar (örn. "5 km", "10 koşu").
  static String targetShortText(TaskTarget target) {
    switch (target.type) {
      case 'total_distance_m':
        final km = target.value / 1000;
        return km >= 1
            ? '${km == km.toInt() ? km.toInt() : km.toStringAsFixed(1)} km'
            : '${target.value.toInt()} m';
      case 'polygon_count':
        return '${target.value.toInt()} koşu';
      case 'streak_days':
        return '${target.value.toInt()} gün seri';
      case 'today_count':
        return 'Bugün ${target.value.toInt()} koşu';
      case 'week_count':
        return 'Bu hafta ${target.value.toInt()} koşu';
      case 'month_count':
        return 'Bu ay ${target.value.toInt()} koşu';
      default:
        return target.value.toString();
    }
  }
}
