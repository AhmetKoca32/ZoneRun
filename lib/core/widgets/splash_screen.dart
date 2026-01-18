import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome(); // Disabled to keep splash screen permanent
  }

  _navigateToHome() async {
    // Record start time to ensure minimum 2 seconds
    final startTime = DateTime.now();

    // Wait for app initialization (e.g., data loading)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait for auth state to be determined - listen to loading state changes
    if (authProvider.isLoading) {
      // If still loading, wait for auth state to be determined
      await _waitForAuthState();
    }

    if (!mounted) return;

    // Ensure minimum 2 seconds have passed
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inMilliseconds < 2000) {
      await Future.delayed(
        Duration(milliseconds: 2000 - elapsed.inMilliseconds),
      );
    }

    if (!mounted) return;

    // Navigate based on auth state after auth check is complete
    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _waitForAuthState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait until auth state is determined (isLoading becomes false)
    int maxAttempts = 50; // 5 seconds max wait
    int attempts = 0;

    while (authProvider.isLoading && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (!mounted) return;
    }

    // If still loading after max attempts, proceed anyway
    // This ensures the app doesn't get stuck
    if (authProvider.isLoading) {
      // Force stop loading after timeout
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/Start_Logo-Transparent.png',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
    );
  }
}
