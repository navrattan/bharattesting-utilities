/// BharatTesting app theme - Material 3 with dark mode default
library app_theme;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Theme configuration for BharatTesting Utilities
///
/// Features:
/// - Material 3 design system
/// - Dark mode as default
/// - GitHub-inspired color palette
/// - Consistent spacing and radius values
/// - Optimized for developer tools UI
class AppTheme {
  const AppTheme._();

  // ============================================================================
  // SPACING & SIZING
  // ============================================================================

  /// Standard spacing unit (4dp)
  static const double spacing = 4.0;

  /// Common spacing values
  static const double spacingXs = spacing; // 4dp
  static const double spacingSm = spacing * 2; // 8dp
  static const double spacingMd = spacing * 3; // 12dp
  static const double spacingLg = spacing * 4; // 16dp
  static const double spacingXl = spacing * 6; // 24dp
  static const double spacingXxl = spacing * 8; // 32dp

  /// Border radius values
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  /// Card and container radius
  static const double cardRadius = radiusMd; // 12dp
  static const double buttonRadius = radiusSm; // 8dp

  /// Touch target sizes
  static const double minTouchTarget = 48.0;
  static const double iconSize = 24.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeLg = 32.0;

  // ============================================================================
  // DARK THEME (Default)
  // ============================================================================

  /// Primary dark theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // Color scheme
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryDark,
          onPrimary: AppColors.onPrimaryDark,
          primaryContainer: AppColors.primaryContainerDark,
          onPrimaryContainer: AppColors.onPrimaryContainerDark,
          secondary: AppColors.secondaryDark,
          onSecondary: AppColors.onSecondaryDark,
          secondaryContainer: AppColors.secondaryContainerDark,
          onSecondaryContainer: AppColors.onSecondaryContainerDark,
          error: AppColors.errorDark,
          onError: AppColors.onErrorDark,
          errorContainer: AppColors.errorContainerDark,
          onErrorContainer: AppColors.onErrorContainerDark,
          background: AppColors.backgroundDark,
          onBackground: AppColors.onBackgroundDark,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.onSurfaceDark,
          surfaceVariant: AppColors.surfaceVariantDark,
          onSurfaceVariant: AppColors.onSurfaceVariantDark,
          outline: AppColors.outlineDark,
          outlineVariant: AppColors.outlineVariantDark,
          inverseSurface: AppColors.inverseSurfaceDark,
          onInverseSurface: AppColors.onInverseSurfaceDark,
          inversePrimary: AppColors.inversePrimaryDark,
        ),

        // Typography
        textTheme: GoogleFonts.notoSansTextTheme(AppTypography.darkTextTheme),

        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.onSurfaceDark,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceDark,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        // Card theme
        cardTheme: CardTheme(
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
            side: const BorderSide(
              color: AppColors.outlineDark,
              width: 1,
            ),
          ),
        ),

        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: AppColors.onPrimaryDark,
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondaryDark,
            foregroundColor: AppColors.onSecondaryDark,
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onSurfaceDark,
            side: const BorderSide(color: AppColors.outlineDark),
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariantDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.outlineDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.outlineDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.errorDark),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
        ),

        // Navigation bar theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          indicatorColor: AppColors.primaryContainerDark,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
        ),

        // Bottom sheet theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
          ),
        ),

        // Divider theme
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineDark,
          space: 1,
          thickness: 1,
        ),
      );

  // ============================================================================
  // LIGHT THEME
  // ============================================================================

  /// Light theme (for users who prefer light mode)
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // Color scheme
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryLight,
          onPrimary: AppColors.onPrimaryLight,
          primaryContainer: AppColors.primaryContainerLight,
          onPrimaryContainer: AppColors.onPrimaryContainerLight,
          secondary: AppColors.secondaryLight,
          onSecondary: AppColors.onSecondaryLight,
          secondaryContainer: AppColors.secondaryContainerLight,
          onSecondaryContainer: AppColors.onSecondaryContainerLight,
          error: AppColors.errorLight,
          onError: AppColors.onErrorLight,
          errorContainer: AppColors.errorContainerLight,
          onErrorContainer: AppColors.onErrorContainerLight,
          background: AppColors.backgroundLight,
          onBackground: AppColors.onBackgroundLight,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.onSurfaceLight,
          surfaceVariant: AppColors.surfaceVariantLight,
          onSurfaceVariant: AppColors.onSurfaceVariantLight,
          outline: AppColors.outlineLight,
          outlineVariant: AppColors.outlineVariantLight,
          inverseSurface: AppColors.inverseSurfaceLight,
          onInverseSurface: AppColors.onInverseSurfaceLight,
          inversePrimary: AppColors.inversePrimaryLight,
        ),

        // Typography
        textTheme: GoogleFonts.notoSansTextTheme(AppTypography.lightTextTheme),

        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.onSurfaceLight,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceLight,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        // Card theme
        cardTheme: CardTheme(
          color: AppColors.surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
            side: const BorderSide(
              color: AppColors.outlineLight,
              width: 1,
            ),
          ),
        ),

        // Button themes (similar structure to dark theme)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.onPrimaryLight,
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondaryLight,
            foregroundColor: AppColors.onSecondaryLight,
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onSurfaceLight,
            side: const BorderSide(color: AppColors.outlineLight),
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            minimumSize: const Size(minTouchTarget, minTouchTarget),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariantLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.outlineLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.outlineLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: AppColors.errorLight),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
        ),

        // Navigation bar theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          indicatorColor: AppColors.primaryContainerLight,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
        ),

        // Bottom sheet theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
          ),
        ),

        // Divider theme
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineLight,
          space: 1,
          thickness: 1,
        ),
      );
}