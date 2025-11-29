import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  // Colors - Use AppColors instead
  static Color get black => AppColors.black;
  static Color get white => AppColors.white;
  static Color get darkGray => AppColors.darkGray;
  static Color get mediumGray => AppColors.mediumGray;

  // Background Gradient - Ultra smooth vertical gradient
  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: AppColors.smoothGradientColors,
    stops: AppColors.smoothGradientStops,
    tileMode: TileMode.clamp,
  );

  // Alternative: Radial gradient for even softer transition (optional)
  static RadialGradient get backgroundRadialGradient => RadialGradient(
    center: Alignment.topCenter,
    radius: 1.5,
    colors: AppColors.smoothGradientColors,
    stops: AppColors.smoothGradientStops,
    tileMode: TileMode.clamp,
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: ColorScheme.dark(
        primary: AppColors.white,
        secondary: AppColors.white,
        surface: AppColors.black,
        background: AppColors.black,
        error: AppColors.white,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.mediumGray,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.3,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.white,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        displaySmall: TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
        ),
        headlineMedium: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodySmall: TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

