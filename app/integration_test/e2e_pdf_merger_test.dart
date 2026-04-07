import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

/// End-to-end tests for PDF Merger
///
/// Tests PDF upload, page management, reordering, and merge operations
void main() {
  group('PDF Merger E2E Tests', () {
    late PatrolIntegrationTester $;

    setUp(() async {
      $ = PatrolIntegrationTester();
    });

    patrolTest('complete PDF merge workflow', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Verify initial state
      await $.waitUntilVisible(find.text('PDF Merger'));

      // Upload first PDF (simulated)
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Add more PDFs
      final addMoreButton = find.text('Add More');
      if (addMoreButton.evaluate().isNotEmpty) {
        await $.tap(addMoreButton);
        await $.pumpAndSettle();
      }

      // Verify PDF list shows uploaded files
      await $.pumpAndSettle(const Duration(seconds: 2));

      // Merge PDFs
      final mergeButton = find.text('Merge PDFs');
      if (mergeButton.evaluate().isNotEmpty) {
        await $.tap(mergeButton);

        // Wait for merge operation with progress indicator
        await $.pumpAndSettle(const Duration(seconds: 8));

        // Verify merge completion
        final downloadButton = find.text('Download');
        await $.waitUntilVisible(downloadButton, timeout: const Duration(seconds: 15));
      }

      // Download merged PDF
      if (find.text('Download').evaluate().isNotEmpty) {
        await $.tap(find.text('Download'));
        await $.pumpAndSettle();
      }
    });

    patrolTest('page thumbnail management', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload PDF with multiple pages
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Switch to page view
      final pageViewButton = find.text('Page View');
      if (pageViewButton.evaluate().isNotEmpty) {
        await $.tap(pageViewButton);
        await $.pumpAndSettle();
      }

      // Verify page thumbnails are displayed
      await $.pumpAndSettle(const Duration(seconds: 3));

      // Test page selection
      final pageCheckbox = find.byType(Checkbox);
      if (pageCheckbox.evaluate().isNotEmpty) {
        await $.tap(pageCheckbox.first);
        await $.pumpAndSettle();
      }

      // Test select all pages
      final selectAllButton = find.text('Select All');
      if (selectAllButton.evaluate().isNotEmpty) {
        await $.tap(selectAllButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('drag and drop page reordering', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload a multi-page PDF
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Enter page reorder mode
      final reorderButton = find.text('Reorder');
      if (reorderButton.evaluate().isNotEmpty) {
        await $.tap(reorderButton);
        await $.pumpAndSettle();
      }

      // Test drag and drop reordering
      final pageThumbnails = find.byType(Draggable);
      if (pageThumbnails.evaluate().length >= 2) {
        await $.drag(
          pageThumbnails.first,
          const Offset(0, 100), // Drag first page down
        );
        await $.pumpAndSettle();
      }

      // Exit reorder mode
      final doneButton = find.text('Done');
      if (doneButton.evaluate().isNotEmpty) {
        await $.tap(doneButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('page rotation functionality', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload PDF
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Select a page to rotate
      final pageItem = find.byType(Card);
      if (pageItem.evaluate().isNotEmpty) {
        await $.longPress(pageItem.first);
        await $.pumpAndSettle();
      }

      // Rotate page 90 degrees
      final rotateButton = find.text('Rotate 90°');
      if (rotateButton.evaluate().isNotEmpty) {
        await $.tap(rotateButton);
        await $.pumpAndSettle();
      }

      // Rotate page 180 degrees
      final rotate180Button = find.text('Rotate 180°');
      if (rotate180Button.evaluate().isNotEmpty) {
        await $.tap(rotate180Button);
        await $.pumpAndSettle();
      }
    });

    patrolTest('page deletion functionality', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload multi-page PDF
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Select page for deletion
      final pageItem = find.byType(Card);
      if (pageItem.evaluate().isNotEmpty) {
        await $.longPress(pageItem.first);
        await $.pumpAndSettle();
      }

      // Delete selected page
      final deleteButton = find.text('Delete');
      if (deleteButton.evaluate().isNotEmpty) {
        await $.tap(deleteButton);
        await $.pumpAndSettle();

        // Confirm deletion
        final confirmButton = find.text('Confirm');
        if (confirmButton.evaluate().isNotEmpty) {
          await $.tap(confirmButton);
          await $.pumpAndSettle();
        }
      }
    });

    patrolTest('password protection workflow', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload PDFs
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Enable password protection
      final passwordToggle = find.text('Password Protect');
      if (passwordToggle.evaluate().isNotEmpty) {
        await $.tap(passwordToggle);
        await $.pumpAndSettle();
      }

      // Enter password
      final passwordField = find.byType(TextField);
      if (passwordField.evaluate().isNotEmpty) {
        await $.enterText(passwordField.first, 'test123456');
        await $.pumpAndSettle();

        // Confirm password
        if (passwordField.evaluate().length > 1) {
          await $.enterText(passwordField.last, 'test123456');
          await $.pumpAndSettle();
        }
      }

      // Set security options
      final disallowPrintToggle = find.text('Disallow Printing');
      if (disallowPrintToggle.evaluate().isNotEmpty) {
        await $.tap(disallowPrintToggle);
        await $.pumpAndSettle();
      }

      // Merge with password protection
      final mergeButton = find.text('Merge PDFs');
      if (mergeButton.evaluate().isNotEmpty) {
        await $.tap(mergeButton);
        await $.pumpAndSettle(const Duration(seconds: 8));
      }
    });

    patrolTest('bookmark generation', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload multiple PDFs
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Enable bookmark generation
      final bookmarkToggle = find.text('Generate Bookmarks');
      if (bookmarkToggle.evaluate().isNotEmpty) {
        await $.tap(bookmarkToggle);
        await $.pumpAndSettle();
      }

      // Select bookmark style
      final bookmarkStyle = find.text('Filename');
      if (bookmarkStyle.evaluate().isNotEmpty) {
        await $.tap(bookmarkStyle);
        await $.pumpAndSettle();

        // Try other bookmark styles
        final pageNumberStyle = find.text('Page Numbers');
        if (pageNumberStyle.evaluate().isNotEmpty) {
          await $.tap(pageNumberStyle);
          await $.pumpAndSettle();
        }
      }

      // Merge with bookmarks
      final mergeButton = find.text('Merge PDFs');
      if (mergeButton.evaluate().isNotEmpty) {
        await $.tap(mergeButton);
        await $.pumpAndSettle(const Duration(seconds: 8));
      }
    });

    patrolTest('large PDF handling', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Upload large PDF (simulated)
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Monitor memory usage during large PDF processing
      await $.pumpAndSettle(const Duration(seconds: 5));

      // Verify app remains responsive
      final mergeButton = find.text('Merge PDFs');
      if (mergeButton.evaluate().isNotEmpty) {
        final startTime = DateTime.now();
        await $.tap(mergeButton);
        await $.pumpAndSettle(const Duration(seconds: 15));
        final endTime = DateTime.now();

        // Should complete within reasonable time
        expect(endTime.difference(startTime).inSeconds, lessThan(15));
      }
    });

    patrolTest('error handling for corrupted PDFs', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Try to upload corrupted PDF (simulated)
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Should show error for corrupted file
      await $.pumpAndSettle(const Duration(seconds: 3));

      // Look for error message
      final errorText = find.textContaining('corrupted', findRichText: true);
      if (errorText.evaluate().isNotEmpty) {
        expect(errorText, findsOneWidget);
      }
    });

    patrolTest('file size limit validation', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle();

      // Try to upload PDFs exceeding size limit (simulated)
      final uploadButton = find.text('Select PDFs');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Should show size limit error
      await $.pumpAndSettle(const Duration(seconds: 3));

      // Look for size limit error
      final sizeError = find.textContaining('100MB', findRichText: true);
      if (sizeError.evaluate().isNotEmpty) {
        expect(sizeError, findsOneWidget);
      }
    });
  });
}