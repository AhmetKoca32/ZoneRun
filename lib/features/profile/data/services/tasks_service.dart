import '../../../../core/constants/reward_constants.dart';
import '../../../history/data/services/history_service.dart';
import '../models/task_model.dart';
import 'firestore_user_service.dart';
import 'task_definitions.dart';

/// Görev ilerlemesini hesaplar, tamamlanan görevlerde ödül verir.
class TasksService {
  final HistoryService _historyService = HistoryService();
  final FirestoreUserService _firestoreUserService = FirestoreUserService();

  /// Tüm görevler için mevcut ilerlemeyi döndürür.
  /// [unlockedTitleIds], [unlockedAvatarIds], [unlockedBannerIds], [unlockedAccessoryIds]
  /// ile ödülün daha önce verilip verilmediği kontrol edilir.
  Future<List<TaskProgress>> getProgress({
    required List<String> unlockedTitleIds,
    required List<int> unlockedAvatarIds,
    required List<int> unlockedBannerIds,
    required List<int> unlockedAccessoryIds,
  }) async {
    final totalDistance = await _historyService.getTotalDistance();
    final polygonCount = await _historyService.getPolygonCount();
    final streak = await _historyService.getCurrentStreak();
    final todayCount = (await _historyService.getTodayPolygons()).length;
    final weekCount = (await _historyService.getThisWeekPolygons()).length;
    final monthCount = (await _historyService.getThisMonthPolygons()).length;

    final list = <TaskProgress>[];
    for (final def in TaskDefinitions.all) {
      num current = 0;
      switch (def.target.type) {
        case 'total_distance_m':
          current = totalDistance;
          break;
        case 'polygon_count':
          current = polygonCount;
          break;
        case 'streak_days':
          current = streak;
          break;
        case 'today_count':
          current = todayCount;
          break;
        case 'week_count':
          current = weekCount;
          break;
        case 'month_count':
          current = monthCount;
          break;
        default:
          current = 0;
      }
      final target = def.target.value;
      final completed = current >= target;
      final rewardClaimed = _isRewardClaimed(
        def,
        unlockedTitleIds,
        unlockedAvatarIds,
        unlockedBannerIds,
        unlockedAccessoryIds,
      );
      list.add(
        TaskProgress(
          definition: def,
          current: current,
          target: target,
          completed: completed,
          rewardClaimed: rewardClaimed,
        ),
      );
    }
    return list;
  }

  bool _isRewardClaimed(
    TaskDefinition def,
    List<String> unlockedTitleIds,
    List<int> unlockedAvatarIds,
    List<int> unlockedBannerIds,
    List<int> unlockedAccessoryIds,
  ) {
    switch (def.rewardType) {
      case RewardConstants.rewardTypeTitle:
        return unlockedTitleIds.contains(def.rewardId);
      case RewardConstants.rewardTypeAvatar:
        return unlockedAvatarIds.contains(int.tryParse(def.rewardId) ?? -1);
      case RewardConstants.rewardTypeBanner:
        return unlockedBannerIds.contains(int.tryParse(def.rewardId) ?? -1);
      case RewardConstants.rewardTypeAccessory:
        return unlockedAccessoryIds.contains(int.tryParse(def.rewardId) ?? -1);
      default:
        return false;
    }
  }

  /// Tamamlanmış ama henüz ödülü verilmemiş görevlerin ödülünü verir.
  /// [onClaim] ile ödül yerelde (provider) verilir; Firestore kullanılmaz.
  Future<void> claimCompletedRewards({
    required List<String> unlockedTitleIds,
    required List<int> unlockedAvatarIds,
    required List<int> unlockedBannerIds,
    required List<int> unlockedAccessoryIds,
    required Future<void> Function(String rewardType, String rewardId) onClaim,
  }) async {
    final progress = await getProgress(
      unlockedTitleIds: unlockedTitleIds,
      unlockedAvatarIds: unlockedAvatarIds,
      unlockedBannerIds: unlockedBannerIds,
      unlockedAccessoryIds: unlockedAccessoryIds,
    );
    for (final p in progress) {
      if (!p.completed || p.rewardClaimed) continue;
      final def = p.definition;
      switch (def.rewardType) {
        case RewardConstants.rewardTypeTitle:
          await onClaim(RewardConstants.rewardTypeTitle, def.rewardId);
          break;
        case RewardConstants.rewardTypeAvatar:
          await onClaim(RewardConstants.rewardTypeAvatar, def.rewardId);
          break;
        case RewardConstants.rewardTypeBanner:
          await onClaim(RewardConstants.rewardTypeBanner, def.rewardId);
          break;
        case RewardConstants.rewardTypeAccessory:
          await onClaim(RewardConstants.rewardTypeAccessory, def.rewardId);
          break;
      }
    }
  }
}
