import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Stack(
          children: [
            // ZoneRun Logo - Centered
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Image.asset(
                  'assets/icons/zonerun-high-resolution-logo-transparent.png',
                  height: 32,
                  fit: BoxFit.contain,
                  color: theme.textPrimary, // Logo rengini tema'ya göre ayarla
                  colorBlendMode:
                      BlendMode.srcIn, // Beyaz logoyu tema rengine çevir
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
                    color: theme.textPrimary,
                    iconSize: 24,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: theme.textPrimary,
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
