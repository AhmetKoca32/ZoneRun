import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_extension.dart';

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
    final extension = AppThemeExtension.dark();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: extension.primaryBackground,
      extensions: <ThemeExtension<dynamic>>[
        extension,
      ],
      colorScheme: ColorScheme.dark(
        primary: extension.accent,
        secondary: extension.accent,
        surface: extension.surface,
        background: extension.primaryBackground,
        error: extension.accent,
        onPrimary: extension.primaryBackground,
        onSecondary: extension.primaryBackground,
        onSurface: extension.textPrimary,
        onBackground: extension.textPrimary,
        onError: extension.primaryBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: extension.primaryBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: extension.textPrimary),
        titleTextStyle: TextStyle(
          color: extension.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: extension.primaryBackground,
        selectedItemColor: extension.textPrimary,
        unselectedItemColor: extension.textTertiary,
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
          color: extension.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        displaySmall: TextStyle(
          color: extension.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
        ),
        headlineMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: extension.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          color: extension.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodySmall: TextStyle(
          color: extension.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.1,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final extension = AppThemeExtension.light();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: extension.primaryBackground,
      extensions: <ThemeExtension<dynamic>>[
        extension,
      ],
      colorScheme: ColorScheme.light(
        primary: extension.accent,
        secondary: extension.accent,
        surface: extension.surface,
        background: extension.primaryBackground,
        error: extension.accent,
        onPrimary: extension.primaryBackground,
        onSecondary: extension.primaryBackground,
        onSurface: extension.textPrimary,
        onBackground: extension.textPrimary,
        onError: extension.primaryBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: extension.primaryBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: extension.textPrimary),
        titleTextStyle: TextStyle(
          color: extension.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: extension.primaryBackground,
        selectedItemColor: extension.textPrimary,
        unselectedItemColor: extension.textTertiary,
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
          color: extension.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        displaySmall: TextStyle(
          color: extension.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
        ),
        headlineMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: extension.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          color: extension.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: extension.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodySmall: TextStyle(
          color: extension.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

