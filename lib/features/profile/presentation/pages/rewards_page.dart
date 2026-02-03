import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/banner_constants.dart';
import '../../../../core/constants/overlay_constants.dart';
import '../../../../core/constants/reward_constants.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/services/task_definitions.dart';
import '../providers/profile_provider.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _precacheAvatarImages();
    });
  }

  void _precacheAvatarImages() {
    const size = 128;
    final defaultCount = RewardConstants.defaultAvatarCount;
    final premiumCount = RewardConstants.premiumAvatarCount;
    final premiumStart = RewardConstants.premiumAvatarStartId;
    for (var i = 0; i < defaultCount; i++) {
      final path = AppConstants.avatarAssetPath(i);
      precacheImage(
        ResizeImage.resizeIfNeeded(size, size, AssetImage(path)),
        context,
      );
    }
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      for (var i = 0; i < premiumCount; i++) {
        final path = AppConstants.avatarAssetPath(premiumStart + i);
        precacheImage(
          ResizeImage.resizeIfNeeded(size, size, AssetImage(path)),
          context,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          'Ödüller',
          style: AppTypography.headlineSmall.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {}),
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelColor: theme.accent,
          unselectedLabelColor: theme.textSecondary,
          indicatorColor: theme.accent,
          labelStyle: AppTypography.bodyMedium.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          tabs: const [
            Tab(text: 'Avatarlar'),
            Tab(text: 'Bannerlar'),
            Tab(text: 'Sıfatlar'),
            Tab(text: 'Aksesuarlar'),
          ],
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          switch (_tabController.index) {
            case 0:
              return _AvatarsTab(
                avatarIndex: provider.avatarIndex,
                unlockedAvatarIds: provider.unlockedAvatarIds,
                onSelect: (index) => provider.updateAvatar(index),
              );
            case 1:
              return _BannersTab(
                selectedBannerId: provider.selectedBannerId,
                unlockedBannerIds: provider.unlockedBannerIds,
                onSelect: provider.updateSelectedBanner,
              );
            case 2:
              return _TitlesTab(
                selectedTitleId: provider.selectedTitleId,
                unlockedTitleIds: provider.unlockedTitleIds,
                onSelect: provider.updateSelectedTitle,
              );
            case 3:
              return _AccessoriesTab(
                selectedAccessoryIds: provider.selectedAccessoryIds,
                unlockedAccessoryIds: provider.unlockedAccessoryIds,
                onToggle: provider.toggleAccessory,
              );
            default:
              return _AvatarsTab(
                avatarIndex: provider.avatarIndex,
                unlockedAvatarIds: provider.unlockedAvatarIds,
                onSelect: (index) => provider.updateAvatar(index),
              );
          }
        },
      ),
    );
  }
}

class _AccessoriesTab extends StatelessWidget {
  final List<int> selectedAccessoryIds;
  final List<int> unlockedAccessoryIds;
  final ValueChanged<int> onToggle;

  const _AccessoriesTab({
    required this.selectedAccessoryIds,
    required this.unlockedAccessoryIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    // 0 = Yok, 1..5 = crown, star, fire, cup, bandage
    const ids = [0, 1, 2, 3, 4, 5];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          'Avatar üzerinde gösterilecek aksesuarı seçin. Görevle açılanlar kullanılabilir.',
          style: AppTypography.bodySmall.copyWith(color: theme.textSecondary),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: ids.length,
          itemBuilder: (context, i) {
            final id = ids[i];
            // 0 = Yok (seçimi temizler); 1..5 = toggle ile birden fazla seçilebilir
            final isUnlocked = id == 0 || unlockedAccessoryIds.contains(id);
            final isSelected = id == 0
                ? selectedAccessoryIds.isEmpty
                : selectedAccessoryIds.contains(id);
            final assetPath = id == 0
                ? null
                : OverlayConstants.overlayAssetPath(id);
            final label = id == 0 ? 'Yok' : OverlayConstants.overlayLabel(id);
            final task = id == 0
                ? null
                : TaskDefinitions.getTaskForReward(
                    RewardConstants.rewardTypeAccessory,
                    id.toString(),
                  );
            final unlockHint = task == null
                ? null
                : '${task.title}: ${TaskDefinitions.targetShortText(task.target)}';
            return RepaintBoundary(
              child: _AccessoryTile(
                accessoryId: id,
                label: label,
                assetPath: assetPath,
                isSelected: isSelected,
                isUnlocked: isUnlocked,
                unlockHint: unlockHint,
                onTap: isUnlocked ? () => onToggle(id) : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AccessoryTile extends StatelessWidget {
  final int accessoryId;
  final String label;
  final String? assetPath;
  final bool isSelected;
  final bool isUnlocked;
  final String? unlockHint;
  final VoidCallback? onTap;

  const _AccessoryTile({
    required this.accessoryId,
    required this.label,
    this.assetPath,
    required this.isSelected,
    required this.isUnlocked,
    this.unlockHint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: theme.secondaryBackground.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.accent : theme.border.withOpacity(0.5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.accent.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: accessoryId == 0
                    ? Icon(
                        Icons.person_outline,
                        color: theme.textSecondary,
                        size: 40,
                      )
                    : assetPath != null
                    ? Image.asset(
                        assetPath!,
                        fit: BoxFit.contain,
                        cacheWidth: 128,
                        cacheHeight: 128,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_not_supported,
                          color: theme.textSecondary,
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        color: theme.textSecondary,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? theme.accent : theme.textSecondary,
                  fontWeight: isSelected
                      ? AppTypography.semiBold
                      : AppTypography.medium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (!isUnlocked) ...[
              Icon(Icons.lock, color: theme.textSecondary, size: 18),
              if (unlockHint != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                  child: Text(
                    unlockHint!,
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.textSecondary,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AvatarsTab extends StatefulWidget {
  final int avatarIndex;
  final List<int> unlockedAvatarIds;
  final ValueChanged<int> onSelect;

  const _AvatarsTab({
    required this.avatarIndex,
    required this.unlockedAvatarIds,
    required this.onSelect,
  });

  @override
  State<_AvatarsTab> createState() => _AvatarsTabState();
}

class _AvatarsTabState extends State<_AvatarsTab> {
  bool _showPremium = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _showPremium = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final defaultCount = RewardConstants.defaultAvatarCount;
    final premiumStart = RewardConstants.premiumAvatarStartId;
    final premiumCount = RewardConstants.premiumAvatarCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          'Varsayılan avatarlar',
          style: AppTypography.bodyMedium.copyWith(
            color: theme.textSecondary,
            fontWeight: AppTypography.semiBold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: defaultCount,
          itemBuilder: (context, index) {
            final isSelected = widget.avatarIndex == index;
            return RepaintBoundary(
              child: _AvatarTile(
                index: index,
                isSelected: isSelected,
                isUnlocked: true,
                assetPath: AppConstants.avatarAssetPath(index),
                onTap: () => widget.onSelect(index),
              ),
            );
          },
        ),
        if (premiumCount > 0 && _showPremium) ...[
          const SizedBox(height: 24),
          Text(
            'Premium avatarlar (görevle aç)',
            style: AppTypography.bodyMedium.copyWith(
              color: theme.textSecondary,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: premiumCount,
            itemBuilder: (context, i) {
              final index = premiumStart + i;
              final isUnlocked = widget.unlockedAvatarIds.contains(index);
              final isSelected = widget.avatarIndex == index;
              final task = TaskDefinitions.getTaskForReward(
                RewardConstants.rewardTypeAvatar,
                index.toString(),
              );
              final unlockHint = task == null
                  ? null
                  : '${task.title}: ${TaskDefinitions.targetShortText(task.target)}';
              return RepaintBoundary(
                child: _AvatarTile(
                  index: index,
                  isSelected: isSelected,
                  isUnlocked: isUnlocked,
                  assetPath: AppConstants.avatarAssetPath(index),
                  unlockHint: unlockHint,
                  onTap: isUnlocked ? () => widget.onSelect(index) : null,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _AvatarTile extends StatelessWidget {
  final int index;
  final bool isSelected;
  final bool isUnlocked;
  final String? assetPath;
  final String? unlockHint;
  final VoidCallback? onTap;

  const _AvatarTile({
    required this.index,
    required this.isSelected,
    required this.isUnlocked,
    this.assetPath,
    this.unlockHint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? theme.accent : theme.border.withOpacity(0.5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.accent.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (assetPath != null)
                Image.asset(
                  assetPath!,
                  fit: BoxFit.cover,
                  cacheWidth: 128,
                  cacheHeight: 128,
                  errorBuilder: (_, __, ___) => _placeholder(theme),
                )
              else
                _placeholder(theme),
              if (!isUnlocked)
                Container(
                  color: theme.primaryBackground.withOpacity(0.7),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: theme.textSecondary, size: 28),
                      if (unlockHint != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          unlockHint!,
                          style: AppTypography.labelSmall.copyWith(
                            color: theme.textSecondary,
                            fontSize: 9,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              if (isSelected)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Icon(
                    Icons.check_circle,
                    color: theme.accent,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(dynamic theme) {
    return Container(
      color: theme.secondaryBackground,
      child: Icon(Icons.person, color: theme.textSecondary, size: 32),
    );
  }
}

class _BannersTab extends StatelessWidget {
  final int selectedBannerId;
  final List<int> unlockedBannerIds;
  final ValueChanged<int> onSelect;

  const _BannersTab({
    required this.selectedBannerId,
    required this.unlockedBannerIds,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final count = 1 + RewardConstants.rewardBannerCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          'Banner arka planı seçin. Varsayılan ve kazandığınız bannerlar görünür.',
          style: AppTypography.bodySmall.copyWith(color: theme.textSecondary),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: count,
          itemBuilder: (context, id) {
            final isUnlocked = id == 0 || unlockedBannerIds.contains(id);
            final isSelected = selectedBannerId == id;
            final task = id == 0
                ? null
                : TaskDefinitions.getTaskForReward(
                    RewardConstants.rewardTypeBanner,
                    id.toString(),
                  );
            final unlockHint = task == null
                ? null
                : '${task.title}: ${TaskDefinitions.targetShortText(task.target)}';
            return RepaintBoundary(
              child: _BannerTile(
                bannerId: id,
                label: BannerConstants.label(id),
                isSelected: isSelected,
                isUnlocked: isUnlocked,
                unlockHint: unlockHint,
                onTap: isUnlocked ? () => onSelect(id) : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _BannerTile extends StatelessWidget {
  final int bannerId;
  final String label;
  final bool isSelected;
  final bool isUnlocked;
  final String? unlockHint;
  final VoidCallback? onTap;

  const _BannerTile({
    required this.bannerId,
    required this.label,
    required this.isSelected,
    required this.isUnlocked,
    this.unlockHint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientList = BannerConstants.gradientColors(bannerId, isDark);
    final colors =
        gradientList ??
        [
          theme.surface,
          theme.surface.withOpacity(0.95),
          theme.secondaryBackground.withOpacity(0.7),
        ];
    final path = BannerConstants.imagePath(bannerId);
    final bgColors = isUnlocked
        ? colors
        : [theme.secondaryBackground, theme.secondaryBackground];
    final gradientBox = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgColors,
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.accent
                : (isDark
                      ? Colors.white.withOpacity(0.06)
                      : theme.border.withOpacity(0.5)),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: path != null && isUnlocked
                    ? Image.asset(
                        path,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => gradientBox,
                      )
                    : gradientBox,
              ),
              if (isUnlocked)
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.textPrimary.withOpacity(0.9),
                      fontWeight: AppTypography.semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!isUnlocked)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, color: theme.textSecondary, size: 40),
                        if (unlockHint != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            unlockHint!,
                            style: AppTypography.labelSmall.copyWith(
                              color: theme.textSecondary,
                              fontSize: 11,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: theme.accent,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitlesTab extends StatelessWidget {
  final String? selectedTitleId;
  final List<String> unlockedTitleIds;
  final ValueChanged<String?> onSelect;

  const _TitlesTab({
    required this.selectedTitleId,
    required this.unlockedTitleIds,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final entries = RewardConstants.titleLabels.entries.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          'Banner\'da isminizin altında görünecek sıfatı seçin. Görevlerle yeni sıfatlar kazanın.',
          style: AppTypography.bodySmall.copyWith(color: theme.textSecondary),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(
            'Sıfat yok',
            style: AppTypography.bodyLarge.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.medium,
            ),
          ),
          trailing: selectedTitleId == null
              ? Icon(Icons.check_circle, color: theme.accent, size: 24)
              : null,
          onTap: () => onSelect(null),
        ),
        const Divider(height: 1),
        ...entries.map((e) {
          final id = e.key;
          final label = e.value;
          final isUnlocked = unlockedTitleIds.contains(id);
          final isSelected = selectedTitleId == id;
          final task = TaskDefinitions.getTaskForReward(
            RewardConstants.rewardTypeTitle,
            id,
          );
          final unlockHint = task == null
              ? null
              : 'Açmak için: ${task.title} (${TaskDefinitions.targetShortText(task.target)})';
          return ListTile(
            title: Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                color: isUnlocked ? theme.textPrimary : theme.textSecondary,
                fontWeight: AppTypography.medium,
              ),
            ),
            subtitle: !isUnlocked && unlockHint != null
                ? Text(
                    unlockHint,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: !isUnlocked
                ? Icon(Icons.lock_outline, color: theme.textSecondary, size: 20)
                : (isSelected
                      ? Icon(Icons.check_circle, color: theme.accent, size: 24)
                      : null),
            onTap: isUnlocked ? () => onSelect(id) : null,
          );
        }),
      ],
    );
  }
}
