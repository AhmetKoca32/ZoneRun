import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/banner_constants.dart';
import '../../../../core/constants/overlay_constants.dart';
import '../../../../core/constants/reward_constants.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileHeroSection extends StatelessWidget {
  final String userName;
  final int avatarIndex;
  final String? avatarUrl;
  final DateTime? joinDate;
  final int selectedBannerId;
  final String? selectedTitleLabel;
  final List<int> selectedAccessoryIds;
  /// Banner'ın sağındaki paylaş butonuna tıklanınca çağrılır (edit açılmaz).
  final VoidCallback? onShareTap;

  const ProfileHeroSection({
    super.key,
    required this.userName,
    required this.avatarIndex,
    this.avatarUrl,
    this.joinDate,
    this.selectedBannerId = 0,
    this.selectedTitleLabel,
    this.selectedAccessoryIds = const [],
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : theme.border.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.textPrimary.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _BannerBackground(
                  bannerId: selectedBannerId,
                  theme: theme,
                  isDark: isDark,
                ),
              ),
            ),
            if (selectedBannerId > 0 &&
                BannerConstants.hasImage(selectedBannerId))
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.4),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            if (onShareTap != null)
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: onShareTap,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.share, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Row(
                children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.border,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                          color: theme.textPrimary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
                    child: (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                  ? ClipOval(
                      child: _buildAvatarImage(),
                    )
                        : _buildAvatarContent(),
            ),
                  const SizedBox(width: 20),
            Expanded(
              child: Column(
                      mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                        Text(
                          userName,
                          style: AppTypography.headlineMedium.copyWith(
                            color: theme.textPrimary,
                            fontWeight: AppTypography.semiBold,
                            fontSize: 26,
                            letterSpacing: -0.5,
                            shadows: _textShadowsForBanner(selectedBannerId),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        if (selectedTitleLabel != null &&
                            selectedTitleLabel!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            selectedTitleLabel!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.accent,
                              fontWeight: AppTypography.semiBold,
                              fontSize: 14,
                              shadows: _textShadowsForBanner(selectedBannerId),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                  const SizedBox(height: 8),
                  if (joinDate != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                                color: theme.textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${AppLocalizations.of(context)!.profileMembershipLabel}: ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(joinDate!)}',
                          style: AppTypography.bodySmall.copyWith(
                                  color: theme.textSecondary,
                            fontWeight: AppTypography.light,
                            fontSize: 13,
                                  shadows: _textShadowsForBanner(
                                    selectedBannerId,
                                  ),
                                ),
                        ),
                      ],
                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Premium (görsel) banner'da yazıların okunabilmesi için gölge; varsayılan banner'da boş.
  static List<Shadow>? _textShadowsForBanner(int bannerId) {
    if (bannerId <= 0 || !BannerConstants.hasImage(bannerId)) return null;
    return [
      Shadow(
        color: Colors.black.withOpacity(0.8),
        blurRadius: 6,
        offset: const Offset(0, 1),
      ),
      Shadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ];
  }

  Widget _BannerBackground({
    required int bannerId,
    required dynamic theme,
    required bool isDark,
  }) {
    final path = BannerConstants.imagePath(bannerId);
    final gradientColors =
        BannerConstants.gradientColors(bannerId, isDark) ??
        [
          theme.surface,
          theme.surface.withOpacity(0.95),
          theme.secondaryBackground.withOpacity(0.7),
        ];
    final gradientBox = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: gradientColors.length >= 3 ? const [0.0, 0.5, 1.0] : null,
        ),
      ),
    );
    if (path != null) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => gradientBox,
      );
    }
    return gradientBox;
  }

  Widget _buildAvatarImage() {
    // Check if it's a file path or URL
    if (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://')) {
      return Image.network(
        avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    } else {
      // Local file path
      return Image.file(
        File(avatarUrl!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }
  }

  Widget _buildAvatarContent() {
    final totalAvatars =
        AppConstants.avatarCount + RewardConstants.premiumAvatarCount;
    if (avatarIndex >= 0 && avatarIndex < totalAvatars) {
      final isPremiumAvatar =
          avatarIndex >= RewardConstants.premiumAvatarStartId;
      final overlayPaths = isPremiumAvatar
          ? <String>[]
          : selectedAccessoryIds
                .map((id) => OverlayConstants.overlayAssetPath(id))
                .whereType<String>()
                .toList();
      return ClipOval(
        child: SizedBox(
          width: 88,
          height: 88,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppConstants.avatarAssetPath(avatarIndex),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(),
              ),
              ...overlayPaths.map(
                (path) => Positioned.fill(
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        '👤',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

}

