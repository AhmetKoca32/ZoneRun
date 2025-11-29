import 'package:flutter/material.dart';

import '../widgets/home_header.dart';
import '../widgets/metrics_section.dart';
import '../widgets/motivation_card.dart';
import '../widgets/stats_cards_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 32),
              const MetricsSection(),
              const SizedBox(height: 24),
              const MotivationCard(),
              const StatsCardsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
