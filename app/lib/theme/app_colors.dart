import 'package:flutter/material.dart';

/// Professional color palette for BharatTesting
/// 
/// Theme: Digital India / Professional Trust
/// Primary: Deep Navy and Royal Blue
/// Accents: Indian Saffron and India Green
class AppColors {
  const AppColors._();

  // ============================================================================
  // BRAND COLORS
  // ============================================================================
  
  static const Color navyDeep = Color(0xFF002147); // Oxford Navy
  static const Color navyMedium = Color(0xFF003366); // Professional Navy
  static const Color royalBlue = Color(0xFF0056B3); // Primary Action Blue
  static const Color skyBlue = Color(0xFFE7F1FF); // Light background blue
  
  static const Color indianSaffron = Color(0xFFFF9933); // CTA / Highlights
  static const Color indiaGreen = Color(0xFF138808); // Success / New
  static const Color ashGrey = Color(0xFFF8F9FA); // Off-white background

  // ============================================================================
  // DARK THEME COLORS
  // ============================================================================
  
  static const Color primaryDark = Color(0xFF58A6FF);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color primaryContainerDark = Color(0xFF003366);
  static const Color onPrimaryContainerDark = Color(0xFFD1E4FF);
  
  static const Color secondaryDark = Color(0xFF79C0FF);
  static const Color onSecondaryDark = Color(0xFF002147);
  static const Color secondaryContainerDark = Color(0xFF004A77);
  static const Color onSecondaryContainerDark = Color(0xFFC2E7FF);
  
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color onBackgroundDark = Color(0xFFC9D1D9);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color onSurfaceDark = Color(0xFFF0F6FC);
  static const Color surfaceVariantDark = Color(0xFF21262D);
  static const Color onSurfaceVariantDark = Color(0xFF8B949E);
  
  static const Color outlineDark = Color(0xFF30363D);
  static const Color outlineVariantDark = Color(0xFF484F58);
  
  static const Color errorDark = Color(0xFFF85149);
  static const Color onErrorDark = Color(0xFFFFFFFF);
  static const Color errorContainerDark = Color(0xFFDA3633);
  static const Color onErrorContainerDark = Color(0xFFFFD1D1);

  // ============================================================================
  // LIGHT THEME COLORS (New "Professional" Palette)
  // ============================================================================
  
  static const Color primaryLight = navyMedium;
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = skyBlue;
  static const Color onPrimaryContainerLight = navyDeep;
  
  static const Color secondaryLight = royalBlue;
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFD0E4FF);
  static const Color onSecondaryContainerLight = Color(0xFF001D35);
  
  static const Color backgroundLight = ashGrey;
  static const Color onBackgroundLight = Color(0xFF1A1C1E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1A1C1E);
  static const Color surfaceVariantLight = Color(0xFFE1E2EC);
  static const Color onSurfaceVariantLight = Color(0xFF44474E);
  
  static const Color outlineLight = Color(0xFF74777F);
  static const Color outlineVariantLight = Color(0xFFC4C6D0);
  
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color onErrorContainerLight = Color(0xFF410002);
  
  // Inverse
  static const Color inverseSurfaceDark = Color(0xFFF0F6FC);
  static const Color onInverseSurfaceDark = Color(0xFF0D1117);
  static const Color inversePrimaryDark = Color(0xFF0056B3);
  
  static const Color inverseSurfaceLight = Color(0xFF2F3033);
  static const Color onInverseSurfaceLight = Color(0xFFF1F0F4);
  static const Color inversePrimaryLight = Color(0xFFADC6FF);
}
