/// BharatTesting app routing - GoRouter configuration
library app_router;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/data_faker/faker_screen_web.dart';
import '../features/home/home_screen.dart';
import '../features/json_converter/json_converter_screen_web.dart';
import '../shared/coming_soon_screen.dart';

/// Application router using GoRouter for type-safe navigation
///
/// Routes:
/// - / → Home screen with tool cards
/// - /indian-data-faker → Indian Data Faker tool (LIVE)
/// - /string-to-json → JSON Converter tool (LIVE)
/// - /image-reducer → Image Size Reducer tool (Coming Soon)
/// - /pdf-merger → PDF Merger tool (Coming Soon)
/// - /document-scanner → Document Scanner tool (Coming Soon)
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Home route
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Live tools
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

      // Coming soon tools
      GoRoute(
        path: '/image-reducer',
        name: 'image-reducer',
        builder: (context, state) => const ComingSoonScreen(
          toolName: 'Image Size Reducer',
          toolDescription: 'Compress, resize, and batch process images',
          toolIcon: Icons.photo_size_select_large,
          features: [
            'Quality slider with real-time preview',
            'Multiple formats: JPEG, PNG, WebP, AVIF',
            'Resize presets: Thumbnail, HD, 4K, Custom',
            'Batch processing up to 50 images',
            'EXIF metadata stripping for privacy',
            'Before/after comparison slider',
          ],
        ),
      ),
      GoRoute(
        path: '/pdf-merger',
        name: 'pdf-merger',
        builder: (context, state) => const ComingSoonScreen(
          toolName: 'PDF Merger',
          toolDescription: 'Merge, rotate, and password-protect PDFs',
          toolIcon: Icons.picture_as_pdf,
          features: [
            'Merge up to 20 PDFs, 100MB total',
            'Drag & drop page reordering',
            'Page rotation (90°/180°/270°)',
            'Visual thumbnail grid',
            'Password protection',
            'Auto-generated bookmarks',
          ],
        ),
      ),
      GoRoute(
        path: '/document-scanner',
        name: 'document-scanner',
        builder: (context, state) => const ComingSoonScreen(
          toolName: 'Document Scanner',
          toolDescription: 'Camera + OCR → Searchable PDF',
          toolIcon: Icons.document_scanner,
          features: [
            'Real-time edge detection',
            'Auto-capture with stability timer',
            '6 enhancement filters',
            'OCR with text recognition',
            'Multi-page scanning',
            'Searchable PDF export',
            'Web: Upload + manual crop',
          ],
        ),
      ),

      // About page
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('About BharatTesting')),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 64),
                  SizedBox(height: 24),
                  Text(
                    'BharatTesting Utilities',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '5 free, privacy-first, offline developer tools',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Built by BTQA Services Pvt Ltd',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Open Source • Made in Bengaluru',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
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
}
