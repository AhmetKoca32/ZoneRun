import '../../../../l10n/app_localizations.dart';
import '../../data/models/task_model.dart';

/// Görev ve ödül metinlerini locale'e göre döndürür (tasks sayfası, rewards sayfası kilit açıklamaları).
class TaskL10nHelper {
  TaskL10nHelper._();

  static String getTargetShortText(AppLocalizations l10n, TaskTarget target) {
    switch (target.type) {
      case 'total_distance_m':
        final km = target.value / 1000;
        if (km >= 1) {
          final value = km == km.toInt() ? km.toInt().toString() : km.toStringAsFixed(1);
          return l10n.targetKm(value);
        }
        return l10n.targetM(target.value.toInt().toString());
      case 'polygon_count':
        return l10n.targetRuns(target.value.toInt());
      case 'streak_days':
        return l10n.targetStreakDays(target.value.toInt());
      case 'today_count':
        return l10n.targetTodayRuns(target.value.toInt());
      case 'week_count':
        return l10n.targetWeekRuns(target.value.toInt());
      case 'month_count':
        return l10n.targetMonthRuns(target.value.toInt());
      default:
        return target.value.toString();
    }
  }

  static String getTaskTitle(AppLocalizations l10n, String taskId) {
    return getTaskTitleDescription(l10n, taskId).title;
  }

  static String getTaskDescription(AppLocalizations l10n, String taskId) {
    return getTaskTitleDescription(l10n, taskId).description;
  }

  static ({String title, String description}) getTaskTitleDescription(
    AppLocalizations l10n,
    String taskId,
  ) {
    switch (taskId) {
      case 'one_first_run':
        return (title: l10n.task_one_first_run_title, description: l10n.task_one_first_run_description);
      case 'one_1km':
        return (title: l10n.task_one_1km_title, description: l10n.task_one_1km_description);
      case 'one_2streak':
        return (title: l10n.task_one_2streak_title, description: l10n.task_one_2streak_description);
      case 'one_3runs':
        return (title: l10n.task_one_3runs_title, description: l10n.task_one_3runs_description);
      case 'one_3streak':
        return (title: l10n.task_one_3streak_title, description: l10n.task_one_3streak_description);
      case 'one_10runs':
        return (title: l10n.task_one_10runs_title, description: l10n.task_one_10runs_description);
      case 'one_25km':
        return (title: l10n.task_one_25km_title, description: l10n.task_one_25km_description);
      case 'one_7streak':
        return (title: l10n.task_one_7streak_title, description: l10n.task_one_7streak_description);
      case 'one_20runs':
        return (title: l10n.task_one_20runs_title, description: l10n.task_one_20runs_description);
      case 'one_30runs':
        return (title: l10n.task_one_30runs_title, description: l10n.task_one_30runs_description);
      case 'one_50km_avatar':
        return (title: l10n.task_one_50km_avatar_title, description: l10n.task_one_50km_avatar_description);
      case 'one_10streak':
        return (title: l10n.task_one_10streak_title, description: l10n.task_one_10streak_description);
      case 'one_50runs':
        return (title: l10n.task_one_50runs_title, description: l10n.task_one_50runs_description);
      case 'one_50km_banner':
        return (title: l10n.task_one_50km_banner_title, description: l10n.task_one_50km_banner_description);
      case 'one_100km_banner':
        return (title: l10n.task_one_100km_banner_title, description: l10n.task_one_100km_banner_description);
      case 'one_200km_banner':
        return (title: l10n.task_one_200km_banner_title, description: l10n.task_one_200km_banner_description);
      case 'one_streak_3_title':
        return (title: l10n.task_one_streak_3_title_title, description: l10n.task_one_streak_3_title_description);
      case 'one_streak_5_title':
        return (title: l10n.task_one_streak_5_title_title, description: l10n.task_one_streak_5_title_description);
      case 'daily_run':
        return (title: l10n.task_daily_run_title, description: l10n.task_daily_run_description);
      case 'weekly_3':
        return (title: l10n.task_weekly_3_title, description: l10n.task_weekly_3_description);
      case 'monthly_5':
        return (title: l10n.task_monthly_5_title, description: l10n.task_monthly_5_description);
      case 'monthly_10':
        return (title: l10n.task_monthly_10_title, description: l10n.task_monthly_10_description);
      case 'monthly_15':
        return (title: l10n.task_monthly_15_title, description: l10n.task_monthly_15_description);
      default:
        return (title: taskId, description: '');
    }
  }

  static String getTitleLabel(AppLocalizations l10n, String titleId) {
    switch (titleId) {
      case 'daily_runner':
        return l10n.rewardTitleDailyRunner;
      case 'weekly_active':
        return l10n.rewardTitleWeeklyActive;
      case 'monthly_champion':
        return l10n.rewardTitleMonthlyChampion;
      case 'week_streak_3':
        return l10n.rewardTitleWeekStreak3;
      case 'week_streak_5':
        return l10n.rewardTitleWeekStreak5;
      case 'month_runs_5':
        return l10n.rewardTitleMonthRuns5;
      case 'month_runs_10':
        return l10n.rewardTitleMonthRuns10;
      default:
        return titleId;
    }
  }

  static String getOverlayLabel(AppLocalizations l10n, int id) {
    switch (id) {
      case 0:
        return l10n.overlayNone;
      case 1:
        return l10n.overlayCrown;
      case 2:
        return l10n.overlayStar;
      case 3:
        return l10n.overlayFire;
      case 4:
        return l10n.overlayCup;
      case 5:
        return l10n.overlayBandage;
      default:
        return l10n.overlayAccessoryId(id.toString());
    }
  }

  static String getBannerLabel(AppLocalizations l10n, int bannerId) {
    switch (bannerId) {
      case 0:
        return l10n.bannerDefault;
      case 1:
        return l10n.bannerAurora;
      case 2:
        return l10n.bannerFire;
      case 3:
        return l10n.bannerRise;
      default:
        return 'Banner $bannerId';
    }
  }
}
