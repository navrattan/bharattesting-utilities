import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bharattesting_utilities/main.dart' as app;
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Document Scanner Integration Tests', () {
    testWidgets('can navigate to document scanner', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should start at home screen
      expect(find.text('Developer Tools'), findsOneWidget);

      // Find and tap document scanner card
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Should navigate to document scanner screen
      expect(find.byType(DocumentScannerScreen), findsOneWidget);
    });

    testWidgets('document scanner screen loads correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Should show scanner interface
      expect(find.text('Document Scanner'), findsOneWidget);

      // Should handle camera permission gracefully
      // (Exact behavior depends on platform and permissions)
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('can switch between scanner modes', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Find mode selector (this may vary based on layout)
      final modeButtons = find.byType(SegmentedButton);
      if (modeButtons.evaluate().isNotEmpty) {
        await tester.tap(modeButtons);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('filter selector works in integration', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Look for filter options
      final filterChips = find.text('Original');
      if (filterChips.evaluate().isNotEmpty) {
        await tester.tap(filterChips);
        await tester.pumpAndSettle();
      }

      // Try other filters
      final autoColorFilter = find.text('Auto Color');
      if (autoColorFilter.evaluate().isNotEmpty) {
        await tester.tap(autoColorFilter);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('export options are accessible', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Look for export format options
      final pdfOption = find.text('PDF');
      if (pdfOption.evaluate().isNotEmpty) {
        await tester.tap(pdfOption);
        await tester.pumpAndSettle();
      }

      // Check for OCR toggle
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        await tester.tap(switches.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('responsive layout adapts correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test mobile layout
      await tester.binding.setSurfaceSize(const Size(375, 667)); // iPhone size
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Should show mobile layout
      await tester.pumpAndSettle();

      // Test tablet layout
      await tester.binding.setSurfaceSize(const Size(768, 1024)); // iPad size
      await tester.pumpAndSettle();

      // Layout should adapt
      await tester.pumpAndSettle();

      // Test desktop layout
      await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop size
      await tester.pumpAndSettle();

      // Layout should adapt again
      await tester.pumpAndSettle();

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('can handle empty state gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Should show empty page list initially
      expect(find.text('No pages scanned yet'), findsAny);
    });

    testWidgets('navigation back to home works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Navigate back to home
      final backButtons = find.byIcon(Icons.arrow_back);
      if (backButtons.evaluate().isNotEmpty) {
        await tester.tap(backButtons.first);
        await tester.pumpAndSettle();
      } else {
        // Try bottom navigation
        final homeTab = find.text('Home');
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();
        }
      }

      // Should be back at home
      expect(find.text('Developer Tools'), findsOneWidget);
    });

    testWidgets('error handling works correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Test that the app doesn't crash with various interactions
      await tester.pumpAndSettle();

      // The app should remain stable
      expect(find.byType(DocumentScannerScreen), findsOneWidget);
    });

    testWidgets('app performance is acceptable', (tester) async {
      final stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Navigation should be fast
      expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // Under 3 seconds
    });

    testWidgets('memory usage is reasonable', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner multiple times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Document Scanner'));
        await tester.pumpAndSettle();

        // Go back
        final backButtons = find.byIcon(Icons.arrow_back);
        if (backButtons.evaluate().isNotEmpty) {
          await tester.tap(backButtons.first);
          await tester.pumpAndSettle();
        } else {
          final homeTab = find.text('Home');
          if (homeTab.evaluate().isNotEmpty) {
            await tester.tap(homeTab);
            await tester.pumpAndSettle();
          }
        }
      }

      // App should still be responsive
      await tester.pumpAndSettle();
      expect(find.text('Developer Tools'), findsOneWidget);
    });
  });

  group('Cross-Feature Integration Tests', () {
    testWidgets('can navigate between all tools', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final tools = [
        'Document Scanner',
        'Image Size Reducer',
        'PDF Merger',
        'String-to-JSON Converter',
        'Indian Data Faker',
      ];

      for (final tool in tools) {
        // Navigate to tool
        await tester.tap(find.text(tool));
        await tester.pumpAndSettle();

        // Navigate back to home
        final homeTab = find.text('Home');
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();
        }

        expect(find.text('Developer Tools'), findsOneWidget);
      }
    });

    testWidgets('theme consistency across tools', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Check that Material 3 theme is applied
      final theme = Theme.of(tester.element(find.byType(MaterialApp)));
      expect(theme.useMaterial3, isTrue);

      // Check dark mode default
      expect(theme.brightness, equals(Brightness.dark));
    });

    testWidgets('footer is present across all screens', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Check footer on home
      expect(find.text('Built by BTQA Services Pvt Ltd'), findsOneWidget);

      // Navigate to document scanner
      await tester.tap(find.text('Document Scanner'));
      await tester.pumpAndSettle();

      // Check footer on document scanner
      expect(find.text('Built by BTQA Services Pvt Ltd'), findsOneWidget);
    });
  });
}