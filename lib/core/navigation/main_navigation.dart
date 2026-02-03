import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../extensions/theme_extension_helper.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), MapPage(), HistoryPage()];

  void switchToTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return MainNavigationInherited(
      switchToTab: switchToTab,
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: theme.backgroundGradient),
          child: _pages[_currentIndex],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              context.read<HomeProvider>().refreshStats();
            }
          },
        ),
      ),
    );
  }
}

class MainNavigationInherited extends InheritedWidget {
  final void Function(int) switchToTab;

  const MainNavigationInherited({
    super.key,
    required this.switchToTab,
    required super.child,
  });

  static MainNavigationInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainNavigationInherited>();
  }

  @override
  bool updateShouldNotify(MainNavigationInherited oldWidget) {
    return switchToTab != oldWidget.switchToTab;
  }
}
