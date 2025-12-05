import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/splash_screen.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

void main() {
  runApp(const ZoneRunApp());
}

class ZoneRunApp extends StatelessWidget {
  const ZoneRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'ZoneRun',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

