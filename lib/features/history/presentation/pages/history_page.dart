import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(
        child: Text('History Page', style: TextStyle(color: AppColors.white)),
      ),
    );
  }
}
