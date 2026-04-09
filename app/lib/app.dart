import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'generated/l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'shared/providers/locale_provider.dart';

/// Main application widget
///
/// Features:
/// - Material 3 design with dark mode default
/// - GoRouter for type-safe navigation
/// - Internationalization with multi-language support
/// - Responsive layout support
class BharatTestingApp extends ConsumerWidget {
  const BharatTestingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'BharatTesting Utilities',
      debugShowCheckedModeBanner: false,

      // Routing configuration
      routerConfig: AppRouter.router,

      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // Default to dark mode

      // Internationalization
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English (US) - primary
        Locale('en', 'IN'), // English (India)
        Locale('hi', 'IN'), // Hindi (India)
        Locale('bn', 'IN'), // Bengali (India)
        Locale('mr', 'IN'), // Marathi (India)
        Locale('te', 'IN'), // Telugu (India)
        Locale('pa', 'IN'), // Punjabi (India)
      ],

      // App metadata
      builder: (context, child) {
        // Add any global overlays or wrappers here if needed
        return child!;
      },
    );
  }
}
