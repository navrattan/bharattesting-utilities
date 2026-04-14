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
import '../shared/widgets/tool_scaffold.dart';

/// Application router using GoRouter for type-safe navigation
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/indian-data-faker', // Directly start with Indian Data Faker
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ToolScaffold(child: child),
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
          // Keep other routes for direct link access but hide from UI
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
      ),
    ],
  );

  /// Navigation destinations - Simplified to only show Faker and Home
  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Indian Data Faker',
    ),
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.info_outline),
      selectedIcon: Icon(Icons.info),
      label: 'About',
    ),
  ];

  /// Get current route index for navigation
  static int getCurrentIndex(String location) {
    if (location.startsWith('/indian-data-faker')) return 0;
    if (location == '/') return 1;
    if (location.startsWith('/about')) return 2;
    return 0;
  }

  /// Navigate to tool by index
  static void navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/indian-data-faker');
        break;
      case 1:
        context.go('/');
        break;
      case 2:
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
