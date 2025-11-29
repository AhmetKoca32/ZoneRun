import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Stack(
          children: [
            // ZoneRun Title - Centered
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'ZoneRun',
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 22,
                    fontWeight: AppTypography.light,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            // Profile and Notification Icons - Right aligned
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person_3_outlined),
                    color: AppColors.white,
                    iconSize: 24,
                    onPressed: () {
                      // Navigate to profile
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.white,
                    iconSize: 24,
                    onPressed: () {
                      // Show notifications
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
