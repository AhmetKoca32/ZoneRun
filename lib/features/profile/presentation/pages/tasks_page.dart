import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/reward_constants.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/task_model.dart';
import '../../data/services/task_definitions.dart';
import '../../data/services/tasks_service.dart';
import '../providers/profile_provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TasksService _tasksService = TasksService();
  List<TaskProgress>? _progress;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final provider = context.read<ProfileProvider>();
    setState(() => _loading = true);
    try {
      await _tasksService.claimCompletedRewards(
        unlockedTitleIds: provider.unlockedTitleIds,
        unlockedAvatarIds: provider.unlockedAvatarIds,
        unlockedBannerIds: provider.unlockedBannerIds,
        unlockedAccessoryIds: provider.unlockedAccessoryIds,
        onClaim: (rewardType, rewardId) async {
          if (rewardType == RewardConstants.rewardTypeTitle) {
            await provider.addUnlockedTitleLocally(rewardId);
          } else if (rewardType == RewardConstants.rewardTypeAvatar) {
            final id = int.tryParse(rewardId);
            if (id != null) await provider.addUnlockedAvatarLocally(id);
          } else if (rewardType == RewardConstants.rewardTypeBanner) {
            final id = int.tryParse(rewardId);
            if (id != null) await provider.addUnlockedBannerLocally(id);
          } else if (rewardType == RewardConstants.rewardTypeAccessory) {
            final id = int.tryParse(rewardId);
            if (id != null) await provider.addUnlockedAccessoryLocally(id);
          }
        },
      );
      await provider.refreshUserProfile();
      final list = await _tasksService.getProgress(
        unlockedTitleIds: provider.unlockedTitleIds,
        unlockedAvatarIds: provider.unlockedAvatarIds,
        unlockedBannerIds: provider.unlockedBannerIds,
        unlockedAccessoryIds: provider.unlockedAccessoryIds,
      );
      if (mounted) {
        setState(() {
          _progress = list;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _progress = [];
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Görevler',
          style: AppTypography.headlineSmall.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: theme.accent))
          : RefreshIndicator(
              onRefresh: _loadProgress,
              color: theme.accent,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  _buildSection(
                    theme,
                    'Tek Seferlik Görevler',
                    'Avatar ve banner ödüllerini aç',
                    _progress!
                        .where(
                          (p) =>
                              p.definition.taskType ==
                              RewardConstants.taskTypeOneTime,
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    theme,
                    'Günlük / Haftalık / Aylık',
                    'Sıfat ödüllerini kazan',
                    _progress!
                        .where(
                          (p) =>
                              p.definition.taskType !=
                              RewardConstants.taskTypeOneTime,
                        )
                        .toList(),
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await context
                              .read<ProfileProvider>()
                              .unlockTitleForTesting('daily_runner');
                          if (mounted) _loadProgress();
                        },
                        child: Text(
                          'Test: "Günün Koşucusu" kilidini aç',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
    dynamic theme,
    String title,
    String subtitle,
    List<TaskProgress> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: theme.textSecondary,
            fontWeight: AppTypography.light,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((p) => _TaskCard(progress: p)),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskProgress progress;

  const _TaskCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final def = progress.definition;
    final isDone = progress.completed && progress.rewardClaimed;
    final isCompleteNotClaimed = progress.completed && !progress.rewardClaimed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone
              ? theme.accent.withOpacity(0.3)
              : theme.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDone
                      ? theme.accent.withOpacity(0.2)
                      : theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDone ? Icons.check_circle : Icons.flag_outlined,
                  color: isDone ? theme.accent : theme.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      def.title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    if (def.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        def.description!,
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isCompleteNotClaimed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ödül hazır',
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.accent,
                      fontWeight: AppTypography.semiBold,
                      fontSize: 11,
                    ),
                  ),
                )
              else if (isDone)
                Icon(Icons.check_circle, color: theme.accent, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.secondaryBackground.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.card_giftcard, size: 16, color: theme.accent),
                const SizedBox(width: 6),
                Text(
                  TaskDefinitions.rewardLabel(def.rewardType, def.rewardId),
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.textPrimary,
                    fontWeight: AppTypography.semiBold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.progressFraction.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: theme.secondaryBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress.completed ? theme.accent : theme.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatProgress(progress),
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textSecondary,
                  fontWeight: AppTypography.medium,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatProgress(TaskProgress p) {
    final t = p.definition.target;
    if (t.type == 'total_distance_m') {
      final km = p.current / 1000;
      final targetKm = p.target / 1000;
      return '${km.toStringAsFixed(1)} / ${targetKm.toStringAsFixed(0)} km';
    }
    return '${p.current.toInt()} / ${p.target.toInt()}';
  }
}
