import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/custom_bottom_nav_bar.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/map/presentation/pages/map_page.dart';

void main() {
  runApp(const ZoneRunApp());
}

class ZoneRunApp extends StatelessWidget {
  const ZoneRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeProvider())],
      child: MaterialApp(
        title: 'ZoneRun',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), MapPage(), HistoryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
