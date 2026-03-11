import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/firebase_service.dart';
import 'l10n/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/history/presentation/providers/history_provider.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/map/presentation/providers/map_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();

  // Initialize notifications (timezone + local notifications)
  await NotificationService.instance.initialize();
  await NotificationService.instance.refreshSchedulesIfNeeded();

  // Use local emulator in debug mode
  // Android emulator must use 10.0.2.2 to access host machine's localhost
  // iOS simulator can use 127.0.0.1 directly
  if (kDebugMode) {
    try {
      final host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
      print('✅ Configured Firebase Functions Emulator at $host:5001');
      if (Platform.isAndroid) {
        print(
          '   (Android emulator: 10.0.2.2 maps to host machine\'s 127.0.0.1)',
        );
      }
    } catch (e) {
      print('⚠️ Could not configure Functions Emulator: $e');
    }
  }
                                                                                                                  
  runApp(const ZoneRunApp());
}

class ZoneRunApp extends StatelessWidget {
  const ZoneRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return MaterialApp(
            title: 'ZoneRun',
            theme: profileProvider.isDarkTheme
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            locale: profileProvider.appLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

