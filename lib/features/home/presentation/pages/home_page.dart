import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/coach_mark_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/metrics_section.dart';
import '../widgets/motivation_card.dart';
import '../widgets/stats_cards_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _prefKey = 'home_coach_completed';

  final _profileKey = GlobalKey();
  final _notificationKey = GlobalKey();
  final _conqueredAreaKey = GlobalKey();
  final _todayDistanceKey = GlobalKey();
  final _totalDistanceKey = GlobalKey();
  final _statisticsKey = GlobalKey();
  final _startButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMarks());
  }

  Future<void> _showCoachMarks() async {
    try {
      if (!mounted) return;
      final shouldShow = await CoachMarkHelper.shouldShow(_prefKey);
      if (!shouldShow || !mounted) return;

      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      // Phase 1: Basic UI elements (profile -> total distance)
      await CoachMarkHelper.show(
        context: context,
        prefKey: _prefKey,
        saveOnFinish: false,
        targets: [
          CoachMarkTarget(key: _profileKey, text: l10n.coachProfileIcon),
          CoachMarkTarget(key: _notificationKey, text: l10n.coachNotificationIcon),
          CoachMarkTarget(key: _conqueredAreaKey, text: l10n.coachConqueredArea),
          CoachMarkTarget(key: _todayDistanceKey, text: l10n.coachTodayDistance),
          CoachMarkTarget(key: _totalDistanceKey, text: l10n.coachTotalDistance),
        ],
      );
      if (!mounted) return;

      // Phase 2: Open stats, show statistics coach mark
      if (!homeProvider.showStats) homeProvider.toggleStats();
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      await CoachMarkHelper.show(
        context: context,
        prefKey: _prefKey,
        saveOnFinish: false,
        targets: [
          CoachMarkTarget(key: _statisticsKey, text: l10n.coachStatistics),
        ],
      );
      if (!mounted) return;

      // Phase 3: Close stats, show start button
      if (homeProvider.showStats) homeProvider.toggleStats();
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      await CoachMarkHelper.show(
        context: context,
        prefKey: _prefKey,
        saveOnFinish: true,
        targets: [
          CoachMarkTarget(key: _startButtonKey, text: l10n.coachStartButton),
        ],
      );
    } catch (_) {
      // Widget deactivated during coach mark flow; safe to ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(
                profileKey: _profileKey,
                notificationKey: _notificationKey,
              ),
              const SizedBox(height: 32),
              MetricsSection(
                conqueredAreaKey: _conqueredAreaKey,
                todayDistanceKey: _todayDistanceKey,
                totalDistanceKey: _totalDistanceKey,
                statisticsKey: _statisticsKey,
              ),
              const SizedBox(height: 24),
              const MotivationCard(),
              StatsCardsSection(startButtonKey: _startButtonKey),
            ],
          ),
        ),
      ),
    );
  }
}
