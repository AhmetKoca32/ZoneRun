import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: const Center(
        child: Text(
          'Map Page',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}

