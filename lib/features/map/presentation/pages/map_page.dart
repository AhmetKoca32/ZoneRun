import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harita'),
      ),
      body: const Center(
        child: Text(
          'Harita Sayfası',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}

