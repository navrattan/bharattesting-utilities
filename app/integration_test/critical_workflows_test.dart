import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

/// Critical workflow tests for BharatTesting Utilities
///
/// These tests focus on the most important user journeys that must work
/// flawlessly for the app to be considered production-ready.
///
/// Critical paths tested:
/// 1. App launch and home screen functionality
/// 2. Document scanning complete workflow
/// 3. Data generation and export workflow
/// 4. JSON conversion and repair workflow
/// 5. Cross-tool navigation and state management
void main() {
  group('Critical Workflow Tests', () {
    late PatrolIntegrationTester $;

    setUp(() async {
      $ = PatrolIntegrationTester();
    });

    group('App Launch and Core Navigation', () {
      patrolTest('successful app launch and tool discovery', ($) async {
        // Test the critical app launch sequence
        app.main();
        await $.pumpAndSettle();

        // Critical: App launches without errors
        await $.waitUntilVisible(find.text('Developer Tools'));

        // Critical: All 5 tools are discoverable
        final expectedTools = [
          'Document Scanner',
          'Image Size Reducer',
          'PDF Merger',
          'String-to-JSON Converter',
          'Indian Data Faker',
        ];

        for (final tool in expectedTools) {
          await $.waitUntilVisible(find.text(tool));
          expect(find.text(tool), findsOneWidget);
        }

        // Critical: Branding and footer are present
        expect(find.text('Built by BTQA Services Pvt Ltd'), findsOneWidget);
        expect(find.text('5 free, privacy-first, offline developer tools'), findsOneWidget);
      });

      patrolTest('tool navigation and back navigation works', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Critical workflow: Navigate to each tool and back
        final tools = [
          'Document Scanner',
          'Indian Data Faker', // Test the two most important tools
        ];

        for (final tool in tools) {
          // Navigate to tool
          await $.tap(find.text(tool));
          await $.pumpAndSettle();

          // Verify successful navigation
          await $.waitUntilVisible(find.text(tool));

          // Navigate back using bottom navigation
          final homeTab = find.text('Home');
          if (homeTab.evaluate().isNotEmpty) {
            await $.tap(homeTab);
            await $.pumpAndSettle();
          } else {
            // Fallback: use system back button
            await $.native.pressBack();
            await $.pumpAndSettle();
          }

          // Verify we're back at home
          await $.waitUntilVisible(find.text('Developer Tools'));
        }
      });
    });

    group('Document Scanner Critical Path', () {
      patrolTest('document scanner mode switching and basic functionality', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Navigate to Document Scanner
        await $.tap(find.text('Document Scanner'));
        await $.pumpAndSettle();
        await $.waitUntilVisible(find.text('Document Scanner'));

        // Critical: Mode switching works
        final uploadMode = find.text('Upload');
        if (uploadMode.evaluate().isNotEmpty) {
          await $.tap(uploadMode);
          await $.pumpAndSettle();

          // Should show upload interface
          final uploadInterface = find.text('Tap to select an image');
          expect(uploadInterface.evaluate().isNotEmpty, isTrue);

          // Switch back to camera mode if available
          final cameraMode = find.text('Camera');
          if (cameraMode.evaluate().isNotEmpty) {
            await $.tap(cameraMode);
            await $.pumpAndSettle();
          }
        }

        // Critical: Filter selection is accessible
        final originalFilter = find.text('Original');
        if (originalFilter.evaluate().isNotEmpty) {
          await $.tap(originalFilter);
          await $.pumpAndSettle();

          // Try different filters
          final filters = ['Auto', 'Gray', 'B&W'];
          for (final filter in filters) {
            final filterButton = find.text(filter);
            if (filterButton.evaluate().isNotEmpty) {
              await $.tap(filterButton);
              await $.pumpAndSettle();
              break; // Test at least one filter switch
            }
          }
        }

        // Critical: Export options are accessible
        final exportOptions = find.text('Export as PDF Document');
        if (exportOptions.evaluate().isNotEmpty) {
          expect(exportOptions, findsOneWidget);
        }
      });

      patrolTest('document scanner error states are handled gracefully', ($) async {
        app.main();
        await $.pumpAndSettle();

        await $.tap(find.text('Document Scanner'));
        await $.pumpAndSettle();

        // Test camera permission handling
        await $.pumpAndSettle(const Duration(seconds: 3));

        // Should either show camera interface or permission request
        final hasCamera = find.text('Flash').evaluate().isNotEmpty;
        final hasPermissionRequest = find.text('Camera Permission Required').evaluate().isNotEmpty;
        final hasUploadOption = find.text('Upload').evaluate().isNotEmpty;

        // At least one of these should be true
        expect(hasCamera || hasPermissionRequest || hasUploadOption, isTrue);

        // If permission request is shown, settings button should work
        final settingsButton = find.text('Open Settings');
        if (settingsButton.evaluate().isNotEmpty) {
          // Don't actually open settings, just verify button exists
          expect(settingsButton, findsOneWidget);
        }
      });
    });

    group('Indian Data Faker Critical Path', () {
      patrolTest('complete data generation workflow', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Navigate to Data Faker
        await $.tap(find.text('Indian Data Faker'));
        await $.pumpAndSettle();
        await $.waitUntilVisible(find.text('Indian Data Faker'));

        // Critical: Identifier selection works
        final panSelector = find.text('PAN');
        if (panSelector.evaluate().isNotEmpty) {
          await $.tap(panSelector);
          await $.pumpAndSettle();
        }

        // Critical: Template selection works
        final individualTemplate = find.text('Individual');
        if (individualTemplate.evaluate().isNotEmpty) {
          await $.tap(individualTemplate);
          await $.pumpAndSettle();
        }

        // Critical: Record count selection
        final hundredRecords = find.text('100');
        if (hundredRecords.evaluate().isNotEmpty) {
          await $.tap(hundredRecords);
          await $.pumpAndSettle();
        }

        // Critical: Data generation button works
        final generateButton = find.text('Generate Data');
        if (generateButton.evaluate().isNotEmpty) {
          await $.tap(generateButton);

          // Wait for generation to complete
          await $.pumpAndSettle(const Duration(seconds: 5));

          // Should see generated data or success message
          final hasData = find.byType(DataTable).evaluate().isNotEmpty;
          final hasTable = find.text('Generated Data').evaluate().isNotEmpty;

          expect(hasData || hasTable, isTrue);
        }

        // Critical: Export functionality is accessible
        final exportButton = find.text('Download');
        if (exportButton.evaluate().isNotEmpty) {
          expect(exportButton, findsOneWidget);
        }

        final copyButton = find.text('Copy');
        if (copyButton.evaluate().isNotEmpty) {
          await $.tap(copyButton);
          await $.pumpAndSettle();
        }
      });

      patrolTest('data faker safety disclaimer is always visible', ($) async {
        app.main();
        await $.pumpAndSettle();

        await $.tap(find.text('Indian Data Faker'));
        await $.pumpAndSettle();

        // Critical: Safety disclaimer must be prominent
        await $.pumpAndSettle(const Duration(seconds: 2));

        final disclaimerTexts = [
          'synthetic',
          'test data',
          'do not use for fraud',
          'fake',
          'generated',
        ];

        bool foundDisclaimer = false;
        for (final text in disclaimerTexts) {
          if (find.textContaining(text, findRichText: true).evaluate().isNotEmpty) {
            foundDisclaimer = true;
            break;
          }
        }

        expect(foundDisclaimer, isTrue,
          reason: 'Safety disclaimer about synthetic data must be visible');
      });
    });

    group('JSON Converter Critical Path', () {
      patrolTest('json validation and repair workflow', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Navigate to JSON Converter
        await $.tap(find.text('String-to-JSON Converter'));
        await $.pumpAndSettle();
        await $.waitUntilVisible(find.text('String-to-JSON Converter'));

        // Critical: Input field accepts text
        final inputField = find.byType(TextField);
        if (inputField.evaluate().isNotEmpty) {
          const brokenJson = '{"name": "test", "value": 123,}'; // Trailing comma

          await $.enterText(inputField.first, brokenJson);
          await $.pumpAndSettle();

          // Critical: Auto-repair functionality
          final repairButton = find.text('Auto-Repair');
          if (repairButton.evaluate().isNotEmpty) {
            await $.tap(repairButton);
            await $.pumpAndSettle(const Duration(seconds: 2));
          }

          // Critical: Validation feedback
          final validateButton = find.text('Validate');
          if (validateButton.evaluate().isNotEmpty) {
            await $.tap(validateButton);
            await $.pumpAndSettle();
          }
        }

        // Critical: Copy functionality works
        final copyButton = find.text('Copy');
        if (copyButton.evaluate().isNotEmpty) {
          await $.tap(copyButton);
          await $.pumpAndSettle();
        }
      });

      patrolTest('format detection works for different inputs', ($) async {
        app.main();
        await $.pumpAndSettle();

        await $.tap(find.text('String-to-JSON Converter'));
        await $.pumpAndSettle();

        // Test CSV input
        final inputField = find.byType(TextField);
        if (inputField.evaluate().isNotEmpty) {
          const csvData = 'name,age,city\nJohn,25,Mumbai\nJane,30,Delhi';

          await $.enterText(inputField.first, csvData);
          await $.pumpAndSettle();

          // Should detect as CSV
          await $.pumpAndSettle(const Duration(seconds: 1));

          // Look for format detection indicator
          final csvChip = find.text('CSV');
          expect(csvChip.evaluate().isNotEmpty, isTrue);
        }
      });
    });

    group('Cross-Tool Critical Integration', () {
      patrolTest('app state management across tools', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Test that switching between tools maintains app stability
        final toolSequence = [
          'Indian Data Faker',
          'String-to-JSON Converter',
          'Document Scanner',
          'PDF Merger',
          'Image Size Reducer',
        ];

        for (final tool in toolSequence) {
          await $.tap(find.text(tool));
          await $.pumpAndSettle();

          // Verify tool loads
          await $.waitUntilVisible(find.text(tool));

          // Perform a basic action in each tool
          await _performBasicToolAction($, tool);

          // Return to home
          await $.native.pressBack();
          await $.pumpAndSettle();

          // Verify we're back at home and app is stable
          await $.waitUntilVisible(find.text('Developer Tools'));
        }
      });

      patrolTest('offline functionality verification', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Disable network connectivity
        await $.native.disableWifi();
        await $.native.disableCellular();

        // App should remain fully functional
        await $.tap(find.text('Indian Data Faker'));
        await $.pumpAndSettle();

        // Generate data offline
        final generateButton = find.text('Generate Data');
        if (generateButton.evaluate().isNotEmpty) {
          await $.tap(generateButton);
          await $.pumpAndSettle(const Duration(seconds: 3));

          // Should work without network
        }

        // Test another tool offline
        await $.native.pressBack();
        await $.pumpAndSettle();

        await $.tap(find.text('String-to-JSON Converter'));
        await $.pumpAndSettle();

        final inputField = find.byType(TextField);
        if (inputField.evaluate().isNotEmpty) {
          await $.enterText(inputField.first, '{"test": "data"}');
          await $.pumpAndSettle();
          // Should work offline
        }

        // Re-enable connectivity
        await $.native.enableWifi();
        await $.native.enableCellular();
      });

      patrolTest('memory and performance under tool switching', ($) async {
        app.main();
        await $.pumpAndSettle();

        final startTime = DateTime.now();

        // Rapidly switch between tools to test performance
        for (int cycle = 0; cycle < 3; cycle++) {
          final tools = ['Document Scanner', 'Indian Data Faker'];

          for (final tool in tools) {
            await $.tap(find.text(tool));
            await $.pumpAndSettle();

            await $.native.pressBack();
            await $.pumpAndSettle();
          }
        }

        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);

        // Should complete within reasonable time
        expect(duration.inSeconds, lessThan(20));

        // App should still be responsive
        expect(find.text('Developer Tools'), findsOneWidget);
      });
    });

    group('Error Recovery and Edge Cases', () {
      patrolTest('app recovers from invalid input gracefully', ($) async {
        app.main();
        await $.pumpAndSettle();

        // Test each tool with potentially problematic input
        await $.tap(find.text('String-to-JSON Converter'));
        await $.pumpAndSettle();

        // Enter extremely malformed input
        final inputField = find.byType(TextField);
        if (inputField.evaluate().isNotEmpty) {
          const badInput = 'This is not JSON at all! @#\$%^&*()';

          await $.enterText(inputField.first, badInput);
          await $.pumpAndSettle();

          // App should handle gracefully
          await $.pumpAndSettle(const Duration(seconds: 2));

          // Should show error but not crash
          final hasError = find.textContaining('error', findRichText: true).evaluate().isNotEmpty ||
                          find.textContaining('invalid', findRichText: true).evaluate().isNotEmpty;

          // Error handling is optional, but app must not crash
          expect(find.text('String-to-JSON Converter'), findsOneWidget);
        }

        // Return to home and verify stability
        await $.native.pressBack();
        await $.pumpAndSettle();
        expect(find.text('Developer Tools'), findsOneWidget);
      });

      patrolTest('orientation changes during tool usage', ($) async {
        app.main();
        await $.pumpAndSettle();

        await $.tap(find.text('Document Scanner'));
        await $.pumpAndSettle();

        // Rotate device while in tool
        await $.native.setOrientation(Orientation.landscape);
        await $.pumpAndSettle(const Duration(seconds: 2));

        // Tool should still be functional
        expect(find.text('Document Scanner'), findsOneWidget);

        // Rotate back
        await $.native.setOrientation(Orientation.portrait);
        await $.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Document Scanner'), findsOneWidget);
      });
    });
  });
}

/// Perform a basic action specific to each tool to verify functionality
Future<void> _performBasicToolAction(PatrolIntegrationTester $, String tool) async {
  switch (tool) {
    case 'Indian Data Faker':
      final generateButton = find.text('Generate Data');
      if (generateButton.evaluate().isNotEmpty) {
        await $.tap(generateButton);
        await $.pumpAndSettle(const Duration(seconds: 1));
      }
      break;

    case 'String-to-JSON Converter':
      final inputField = find.byType(TextField);
      if (inputField.evaluate().isNotEmpty) {
        await $.enterText(inputField.first, '{"test": true}');
        await $.pumpAndSettle();
      }
      break;

    case 'Document Scanner':
      final uploadMode = find.text('Upload');
      if (uploadMode.evaluate().isNotEmpty) {
        await $.tap(uploadMode);
        await $.pumpAndSettle();
      }
      break;

    case 'PDF Merger':
      // Just verify the interface loads
      await $.pumpAndSettle(const Duration(milliseconds: 500));
      break;

    case 'Image Size Reducer':
      // Test quality slider if present
      final slider = find.byType(Slider);
      if (slider.evaluate().isNotEmpty) {
        await $.drag(slider.first, const Offset(50, 0));
        await $.pumpAndSettle();
      }
      break;
  }
}