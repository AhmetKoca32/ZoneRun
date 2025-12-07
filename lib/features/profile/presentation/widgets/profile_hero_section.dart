import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileHeroSection extends StatelessWidget {
  final String userName;
  final int avatarIndex;
  final String? avatarUrl;
  final bool isProMember;
  final DateTime? joinDate;

  const ProfileHeroSection({
    super.key,
    required this.userName,
    required this.avatarIndex,
    this.avatarUrl,
    required this.isProMember,
    this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.mediumGray,
              AppColors.mediumGray.withOpacity(0.8),
              AppColors.lightGray.withOpacity(0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withOpacity(0.2),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: avatarUrl != null
                  ? ClipOval(
                      child: _buildAvatarImage(),
                    )
                  : _buildDefaultAvatar(),
            ),
            const SizedBox(width: 20),

            // Name and Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: AppTypography.semiBold,
                            fontSize: 26,
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isProMember) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFD4AF37),
                                const Color(0xFFB8941F),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.black,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Pro',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.black,
                                  fontWeight: AppTypography.bold,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (joinDate != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.whiteWithOpacity70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Üyelik: ${_formatDate(joinDate!)}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.whiteWithOpacity70,
                            fontWeight: AppTypography.light,
                            fontSize: 13,
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
    );
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

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        '👤',
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

