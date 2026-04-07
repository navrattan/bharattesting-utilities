/// BharatTesting main application widget
library app;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'generated/l10n/app_localizations.dart';

/// Main application widget
///
/// Features:
/// - Material 3 design with dark mode default
/// - GoRouter for type-safe navigation
/// - Internationalization ready (English only for now)
/// - Responsive layout support
class BharatTestingApp extends StatelessWidget {
  const BharatTestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BharatTesting Utilities',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // Dark mode default

      // Routing
      routerConfig: AppRouter.router,

      // Internationalization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English (US) - primary
        Locale('en', 'IN'), // English (India)
      ],

      // App metadata
      builder: (context, child) {
        // Add any global overlays or wrappers here if needed
        return child!;
      },
    );
  }
}