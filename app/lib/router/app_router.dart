/// BharatTesting app routing - GoRouter configuration
library app_router;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/data_faker/faker_screen.dart';
import '../features/home/home_screen.dart';
import '../features/image_reducer/image_reducer_screen.dart';
import '../features/json_converter/json_converter_screen.dart';
import '../features/pdf_merger/pdf_merger_screen.dart';
import '../features/document_scanner/screens/document_scanner_screen.dart';
import '../shared/coming_soon_screen.dart';
import '../shared/widgets/tool_scaffold.dart';

/// Application router using GoRouter for type-safe navigation
///
/// Routes:
/// - / → Home screen with tool cards
/// - /indian-data-faker → Indian Data Faker tool
/// - /string-to-json → JSON Converter tool
/// - /image-reducer → Image Size Reducer tool
/// - /pdf-merger → PDF Merger tool
/// - /document-scanner → Document Scanner tool
/// - /about → About page
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/indian-data-faker',
        name: 'indian-data-faker',
        builder: (context, state) => const FakerScreen(),
      ),
      GoRoute(
        path: '/string-to-json',
        name: 'string-to-json',
        builder: (context, state) => const JsonConverterScreen(),
      ),
      GoRoute(
        path: '/image-reducer',
        name: 'image-reducer',
        builder: (context, state) => const ImageReducerScreen(),
      ),
      GoRoute(
        path: '/pdf-merger',
        name: 'pdf-merger',
        builder: (context, state) => const PdfMergerScreen(),
      ),
      GoRoute(
        path: '/document-scanner',
        name: 'document-scanner',
        builder: (context, state) => const DocumentScannerScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const _AboutScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.path}" does not exist.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Navigation destinations for responsive navigation
  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Faker',
    ),
    NavigationDestination(
      icon: Icon(Icons.code_outlined),
      selectedIcon: Icon(Icons.code),
      label: 'JSON',
    ),
    NavigationDestination(
      icon: Icon(Icons.photo_size_select_large_outlined),
      selectedIcon: Icon(Icons.photo_size_select_large),
      label: 'Images',
    ),
    NavigationDestination(
      icon: Icon(Icons.picture_as_pdf_outlined),
      selectedIcon: Icon(Icons.picture_as_pdf),
      label: 'PDF',
    ),
    NavigationDestination(
      icon: Icon(Icons.info_outline),
      selectedIcon: Icon(Icons.info),
      label: 'About',
    ),
  ];

  /// Get current route index for navigation
  static int getCurrentIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/indian-data-faker')) return 1;
    if (location.startsWith('/string-to-json')) return 2;
    if (location.startsWith('/image-reducer')) return 3;
    if (location.startsWith('/pdf-merger')) return 4;
    if (location.startsWith('/about')) return 5;
    return 0;
  }

  /// Navigate to tool by index
  static void navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/indian-data-faker');
        break;
      case 2:
        context.go('/string-to-json');
        break;
      case 3:
        context.go('/image-reducer');
        break;
      case 4:
        context.go('/pdf-merger');
        break;
      case 5:
        context.go('/about');
        break;
    }
  }
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About BharatTesting')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BT Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF58A6FF), Color(0xFF0969DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'BT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'BharatTesting Utilities',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Free, privacy-first, 100% offline developer tools',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'Built by BTQA Services Pvt Ltd',
                style: TextStyle(fontSize: 14),
              ),
              const Text(
                'Open Source • Made in Bengaluru',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 40),
              const Text(
                'v1.0.0+1',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
