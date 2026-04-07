/// BharatTesting app routing - GoRouter configuration
library app_router;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/data_faker/faker_screen.dart';
import '../features/document_scanner/screens/document_scanner_screen.dart';
import '../features/home/home_screen.dart';
import '../features/image_reducer/image_reducer_screen.dart';
import '../features/json_converter/json_converter_screen.dart';
import '../features/pdf_merger/pdf_merger_screen.dart';
import '../shared/widgets/tool_scaffold.dart';

/// Application router using GoRouter for type-safe navigation
///
/// Routes:
/// - / → Home screen with tool cards
/// - /document-scanner → Document Scanner tool
/// - /image-reducer → Image Size Reducer tool
/// - /pdf-merger → PDF Merger tool
/// - /string-to-json → JSON Converter tool
/// - /indian-data-faker → Indian Data Faker tool
/// - /about → About page
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ToolScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/document-scanner',
            name: 'document-scanner',
            builder: (context, state) => const DocumentScannerScreen(),
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
            path: '/string-to-json',
            name: 'string-to-json',
            builder: (context, state) => const JsonConverterScreen(),
          ),
          GoRoute(
            path: '/indian-data-faker',
            name: 'indian-data-faker',
            builder: (context, state) => const FakerScreen(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => const Placeholder(
              child: Center(
                child: Text('About BharatTesting\nComing Soon'),
              ),
            ),
          ),
        ],
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
      icon: Icon(Icons.document_scanner_outlined),
      selectedIcon: Icon(Icons.document_scanner),
      label: 'Scanner',
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
      icon: Icon(Icons.code_outlined),
      selectedIcon: Icon(Icons.code),
      label: 'JSON',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Faker',
    ),
  ];

  /// Get current route index for navigation
  static int getCurrentIndex(String location) {
    switch (location) {
      case '/':
        return 0;
      case '/document-scanner':
        return 1;
      case '/image-reducer':
        return 2;
      case '/pdf-merger':
        return 3;
      case '/string-to-json':
        return 4;
      case '/indian-data-faker':
        return 5;
      default:
        return 0;
    }
  }

  /// Navigate to tool by index
  static void navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/document-scanner');
        break;
      case 2:
        context.go('/image-reducer');
        break;
      case 3:
        context.go('/pdf-merger');
        break;
      case 4:
        context.go('/string-to-json');
        break;
      case 5:
        context.go('/indian-data-faker');
        break;
    }
  }
}

class _ComingSoonScreen extends StatelessWidget {
  const _ComingSoonScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction_outlined, size: 64),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Temporarily unavailable while we stabilize the build.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
