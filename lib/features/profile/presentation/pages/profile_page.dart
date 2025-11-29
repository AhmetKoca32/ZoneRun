import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}

