import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş')),
      body: const Center(
        child: Text('Geçmiş Sayfası', style: TextStyle(color: AppColors.white)),
      ),
    );
  }
}
