import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/banner_constants.dart';
import '../../../../core/constants/reward_constants.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';

/// Paylaşım görseli için kullanılan kart: banner arka plan + isim + istatistikler + sağda büyük avatar.
/// Sabit boyut (400x280) ile tutarlı görsel üretimi için kullanılır.
class ShareCard extends StatelessWidget {
  final String userName;
  final String? titleLabel;
  final int selectedBannerId;
  final List<String> statLines;
  final int avatarIndex;
  final String? avatarUrl;

  const ShareCard({
    super.key,
    required this.userName,
    this.titleLabel,
    this.selectedBannerId = 0,
    this.statLines = const [],
    this.avatarIndex = 0,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 400,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: _BannerBackground(
              bannerId: selectedBannerId,
              theme: theme,
              isDark: isDark,
            ),
          ),
          if (selectedBannerId > 0 &&
              BannerConstants.hasImage(selectedBannerId))
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: AppTypography.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTypography.semiBold,
                          fontSize: 24,
                          shadows: _shadows,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (titleLabel != null && titleLabel!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          titleLabel!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: AppTypography.semiBold,
                            fontSize: 14,
                            shadows: _shadows,
                          ),
                        ),
                      ],
                      if (statLines.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ...statLines.map(
                          (line) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              line,
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                shadows: _shadows,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildAvatar(),
              ],
            ),
          ),
          const Positioned(
            bottom: 12,
            right: 16,
            child: Text(
              'ZoneRun',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<Shadow> _shadows = [
    Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
  ];

  static const double _avatarSize = 130;

  Widget _buildAvatar() {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
            ? _buildAvatarFromUrl()
            : _buildAvatarFromAsset(),
      ),
    );
  }

  Widget _buildAvatarFromUrl() {
    if (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://')) {
      return Image.network(
        avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
      );
    }
    return Image.file(
      File(avatarUrl!),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
    );
  }

  Widget _buildAvatarFromAsset() {
    final totalAvatars =
        AppConstants.avatarCount + RewardConstants.premiumAvatarCount;
    if (avatarIndex >= 0 && avatarIndex < totalAvatars) {
      return Image.asset(
        AppConstants.avatarAssetPath(avatarIndex),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.white24,
      child: Icon(Icons.person, size: _avatarSize * 0.6, color: Colors.white70),
    );
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
}
