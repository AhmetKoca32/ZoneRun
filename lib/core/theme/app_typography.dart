import 'package:flutter/material.dart';

class AppTypography {
  // Font Family
  static const String fontFamily = 'Inter';
  static const String fallbackFontFamily = 'Roboto';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;

  // Display Styles
  static TextStyle get displayLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: bold,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: bold,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: semiBold,
        letterSpacing: letterSpacingTight,
      );

  // Headline Styles
  static TextStyle get headlineLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: semiBold,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: semiBold,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: semiBold,
        letterSpacing: letterSpacingTight,
      );

  // Title Styles
  static TextStyle get titleLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: semiBold,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: medium,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: letterSpacingNormal,
      );

  // Body Styles
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: regular,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: regular,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: letterSpacingNormal,
      );

  // Label Styles
  static TextStyle get labelLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: letterSpacingWide,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: medium,
        letterSpacing: letterSpacingWide,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: medium,
        letterSpacing: letterSpacingWide,
      );
}
