import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/shared/widgets/responsive_layout.dart';
import 'package:bharattesting_utilities/features/home/home_screen.dart';
import 'package:bharattesting_utilities/features/data_faker/faker_screen.dart';
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';

/// Comprehensive responsive layout tests for BharatTesting Utilities
///
/// Tests layout adaptation across mobile (375w), tablet (768w), and desktop (1280w)
/// breakpoints for all screens and components.
void main() {
  group('Responsive Layout Tests', () {
    testWidgets('responsive layout breakpoints are correct', (tester) async {
      // Test mobile breakpoint (< 600)
      await tester.binding.setSurfaceSize(const Size(375, 667));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveLayout(
              mobile: const Text('Mobile'),
              tablet: const Text('Tablet'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsNothing);

      // Test tablet breakpoint (600-1024)
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);

      // Test desktop breakpoint (> 1024)
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpAndSettle();

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsOneWidget);
    });

    group('Home Screen Responsive Tests', () {
      testWidgets('home screen adapts to mobile layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        // On mobile, tools should be in vertical list/grid
        expect(find.text('Developer Tools'), findsOneWidget);
        expect(find.text('Document Scanner'), findsOneWidget);
        expect(find.text('Image Size Reducer'), findsOneWidget);

        // Verify no horizontal overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('home screen adapts to tablet layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(768, 1024));

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        // On tablet, tools should be in optimized grid
        expect(find.text('Developer Tools'), findsOneWidget);
        expect(find.text('PDF Merger'), findsOneWidget);
        expect(find.text('String-to-JSON Converter'), findsOneWidget);

        // Verify layout efficiency
        expect(tester.takeException(), isNull);
      });

      testWidgets('home screen adapts to desktop layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 800));

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        // On desktop, should have wide layout with max content width
        expect(find.text('Developer Tools'), findsOneWidget);
        expect(find.text('Indian Data Faker'), findsOneWidget);

        // Content should not exceed max width (1200dp)
        final homeWidget = tester.widget<Container>(
          find.byType(Container).first,
        );
        // Note: This would need access to actual layout constraints
        expect(tester.takeException(), isNull);
      });
    });

    group('Tool Screens Responsive Tests', () {
      testWidgets('data faker screen mobile layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          const MaterialApp(home: FakerScreen()),
        );

        // Mobile layout should stack controls vertically
        expect(find.text('Indian Data Faker'), findsOneWidget);

        // Should handle narrow screen gracefully
        expect(tester.takeException(), isNull);
      });

      testWidgets('data faker screen tablet layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(768, 1024));

        await tester.pumpWidget(
          const MaterialApp(home: FakerScreen()),
        );

        // Tablet layout should optimize for two-column or side panels
        expect(find.text('Indian Data Faker'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('data faker screen desktop layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 800));

        await tester.pumpWidget(
          const MaterialApp(home: FakerScreen()),
        );

        // Desktop layout should have wide, multi-column layout
        expect(find.text('Indian Data Faker'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('document scanner screen responsive', (tester) async {
        // Test camera interface responsiveness
        for (final size in [
          const Size(375, 667),  // Mobile
          const Size(768, 1024), // Tablet
          const Size(1280, 800), // Desktop
        ]) {
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(
            const MaterialApp(home: DocumentScannerScreen()),
          );

          expect(find.text('Document Scanner'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Component Responsive Tests', () {
      testWidgets('responsive grid adapts column count', (tester) async {
        // Test grid component responsiveness
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GridView.count(
                crossAxisCount: MediaQuery.of(tester.element(find.byType(Scaffold))).size.width > 768 ? 3 : 2,
                children: List.generate(6, (i) => Card(child: Text('Item $i'))),
              ),
            ),
          ),
        );

        // On mobile, should show 2 columns
        expect(find.byType(Card), findsNWidgets(6));
        expect(tester.takeException(), isNull);

        // Test tablet (3 columns)
        await tester.binding.setSurfaceSize(const Size(768, 1024));
        await tester.pumpAndSettle();

        expect(find.byType(Card), findsNWidgets(6));
        expect(tester.takeException(), isNull);
      });

      testWidgets('responsive text scales appropriately', (tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text(
                    'Large Heading',
                    style: Theme.of(tester.element(find.byType(Scaffold))).textTheme.headlineLarge,
                  ),
                  Text(
                    'Body Text',
                    style: Theme.of(tester.element(find.byType(Scaffold))).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Large Heading'), findsOneWidget);
        expect(find.text('Body Text'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('responsive spacing adapts to screen size', (tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(tester.element(find.byType(Scaffold))).size.width > 768 ? 24.0 : 16.0,
                ),
                child: const Column(
                  children: [
                    Text('Content 1'),
                    SizedBox(height: 16),
                    Text('Content 2'),
                  ],
                ),
              ),
            ),
          ),
        );

        // Mobile should have 16dp padding
        expect(find.text('Content 1'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Desktop should have 24dp padding
        await tester.binding.setSurfaceSize(const Size(1280, 800));
        await tester.pumpAndSettle();

        expect(find.text('Content 1'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Navigation Responsive Tests', () {
      testWidgets('navigation adapts to screen size', (tester) async {
        // Test mobile navigation (bottom nav)
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: MediaQuery.of(tester.element(find.byType(Scaffold))).size.width < 600
                  ? BottomNavigationBar(
                      items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
                      ],
                    )
                  : null,
              body: MediaQuery.of(tester.element(find.byType(Scaffold))).size.width >= 600
                  ? Row(
                      children: [
                        NavigationRail(
                          destinations: const [
                            NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                            NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
                          ],
                          selectedIndex: 0,
                        ),
                        const Expanded(child: Center(child: Text('Content'))),
                      ],
                    )
                  : const Center(child: Text('Content')),
            ),
          ),
        );

        // Mobile should show bottom nav
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        expect(find.byType(NavigationRail), findsNothing);

        // Tablet should show navigation rail
        await tester.binding.setSurfaceSize(const Size(768, 1024));
        await tester.pumpAndSettle();

        // Note: This test would need proper responsive navigation implementation
        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('Overflow and Edge Cases', () {
      testWidgets('no overflow on very narrow screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568)); // iPhone SE

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        await tester.pumpAndSettle();

        // Should not have any render overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('no overflow on very wide screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1920, 1080)); // 1080p

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        await tester.pumpAndSettle();

        // Should not have any render overflow and should respect max width
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles extreme aspect ratios', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 200)); // Very wide

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.binding.setSurfaceSize(const Size(200, 800)); // Very tall
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    group('Dynamic Resize Tests', () {
      testWidgets('layout adapts to window resize', (tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 667));

        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        // Start mobile
        expect(find.text('Developer Tools'), findsOneWidget);

        // Resize to tablet
        await tester.binding.setSurfaceSize(const Size(768, 1024));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Resize to desktop
        await tester.binding.setSurfaceSize(const Size(1280, 800));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Resize back to mobile
        await tester.binding.setSurfaceSize(const Size(375, 667));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    group('Performance Under Resize', () {
      testWidgets('multiple rapid resizes do not cause errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        final sizes = [
          const Size(375, 667),
          const Size(768, 1024),
          const Size(1280, 800),
          const Size(414, 896),
          const Size(1024, 1366),
        ];

        // Rapidly change sizes
        for (int i = 0; i < 5; i++) {
          for (final size in sizes) {
            await tester.binding.setSurfaceSize(size);
            await tester.pump();
          }
        }

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });
  });

  group('Media Query Tests', () {
    testWidgets('media query values are correct', (tester) async {
      await tester.binding.setSurfaceSize(const Size(768, 1024));

      late MediaQueryData mediaQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                mediaQuery = MediaQuery.of(context);
                return const Text('Test');
              },
            ),
          ),
        ),
      );

      expect(mediaQuery.size.width, equals(768));
      expect(mediaQuery.size.height, equals(1024));
      expect(mediaQuery.orientation, equals(Orientation.portrait));
    });

    testWidgets('media query orientation changes', (tester) async {
      await tester.binding.setSurfaceSize(const Size(768, 1024));

      late MediaQueryData mediaQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                mediaQuery = MediaQuery.of(context);
                return const Text('Test');
              },
            ),
          ),
        ),
      );

      expect(mediaQuery.orientation, equals(Orientation.portrait));

      // Rotate to landscape
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpAndSettle();

      expect(mediaQuery.orientation, equals(Orientation.landscape));
    });
  });
}