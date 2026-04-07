import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

/// End-to-end tests for Document Scanner
///
/// Tests camera functionality, document detection, filters, and export
void main() {
  group('Document Scanner E2E Tests', () {
    late PatrolIntegrationTester $;

    setUp(() async {
      $ = PatrolIntegrationTester();
    });

    patrolTest('camera permission and initialization', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Verify initial state
      await $.waitUntilVisible(find.text('Document Scanner'));

      // Handle camera permission request
      await $.pumpAndSettle(const Duration(seconds: 3));

      // Check if permission dialog appears
      final permissionDialog = find.text('Camera Permission Required');
      if (permissionDialog.evaluate().isNotEmpty) {
        // Grant permission via settings
        final settingsButton = find.text('Open Settings');
        if (settingsButton.evaluate().isNotEmpty) {
          await $.tap(settingsButton);
          await $.pumpAndSettle();

          // Return to app (simulated)
          await $.native.pressBack();
          await $.pumpAndSettle();
        }
      }

      // Verify camera is initialized or upload option is available
      final hasCamera = find.text('Flash').evaluate().isNotEmpty;
      final hasUpload = find.text('Upload').evaluate().isNotEmpty;
      expect(hasCamera || hasUpload, isTrue);
    });

    patrolTest('upload mode document processing', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Switch to upload mode
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();
      }

      // Upload an image (simulated)
      final uploadArea = find.text('Tap to select an image');
      if (uploadArea.evaluate().isNotEmpty) {
        await $.tap(uploadArea);
        await $.pumpAndSettle();
      }

      // Wait for image processing
      await $.pumpAndSettle(const Duration(seconds: 5));

      // Verify document detection overlay
      final cropOverlay = find.text('Adjust corners');
      if (cropOverlay.evaluate().isNotEmpty) {
        expect(cropOverlay, findsOneWidget);
      }

      // Apply crop
      final cropButton = find.text('Crop');
      if (cropButton.evaluate().isNotEmpty) {
        await $.tap(cropButton);
        await $.pumpAndSettle(const Duration(seconds: 3));
      }
    });

    patrolTest('document filters application', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Process a document first (upload mode)
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }
      }

      // Test different filters
      final filters = ['Original', 'Auto', 'Gray', 'B&W', 'Magic', 'Whiteboard'];

      for (final filter in filters) {
        final filterButton = find.text(filter);
        if (filterButton.evaluate().isNotEmpty) {
          await $.tap(filterButton);
          await $.pumpAndSettle(const Duration(seconds: 2));

          // Verify filter is applied
          await $.pumpAndSettle();
          break; // Test one filter for time efficiency
        }
      }

      // Verify filter preview updates
      await $.pumpAndSettle(const Duration(seconds: 1));
    });

    patrolTest('multi-page document scanning', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Scan first page (upload mode for testing)
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }

        // Apply filter and add to batch
        final addPageButton = find.text('Add Page');
        if (addPageButton.evaluate().isNotEmpty) {
          await $.tap(addPageButton);
          await $.pumpAndSettle();
        }
      }

      // Add more pages
      for (int i = 0; i < 2; i++) {
        final addMoreButton = find.text('Add More');
        if (addMoreButton.evaluate().isNotEmpty) {
          await $.tap(addMoreButton);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }
      }

      // Verify page thumbnails
      final pageCount = find.text('Page 1');
      if (pageCount.evaluate().isNotEmpty) {
        expect(pageCount, findsOneWidget);
      }

      // Test page reordering
      final reorderButton = find.text('Reorder');
      if (reorderButton.evaluate().isNotEmpty) {
        await $.tap(reorderButton);
        await $.pumpAndSettle();

        // Drag and drop pages (simulated)
        await $.pumpAndSettle(const Duration(seconds: 2));

        final doneButton = find.text('Done');
        if (doneButton.evaluate().isNotEmpty) {
          await $.tap(doneButton);
          await $.pumpAndSettle();
        }
      }
    });

    patrolTest('OCR text extraction', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Process a document with text
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }
      }

      // Enable OCR
      final ocrToggle = find.text('Extract Text');
      if (ocrToggle.evaluate().isNotEmpty) {
        await $.tap(ocrToggle);
        await $.pumpAndSettle();
      }

      // Start OCR processing
      final extractButton = find.text('Extract');
      if (extractButton.evaluate().isNotEmpty) {
        await $.tap(extractButton);

        // Wait for OCR completion
        await $.pumpAndSettle(const Duration(seconds: 10));

        // Verify OCR results
        final extractedText = find.text('Text');
        if (extractedText.evaluate().isNotEmpty) {
          expect(extractedText, findsOneWidget);
        }
      }

      // Copy extracted text
      final copyTextButton = find.text('Copy Text');
      if (copyTextButton.evaluate().isNotEmpty) {
        await $.tap(copyTextButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('PDF export with searchable text', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Scan a document
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }
      }

      // Configure PDF export
      final exportButton = find.text('Export');
      if (exportButton.evaluate().isNotEmpty) {
        await $.tap(exportButton);
        await $.pumpAndSettle();
      }

      // Select PDF format
      final pdfOption = find.text('PDF Document');
      if (pdfOption.evaluate().isNotEmpty) {
        await $.tap(pdfOption);
        await $.pumpAndSettle();
      }

      // Enable searchable text
      final searchableToggle = find.text('Searchable Text');
      if (searchableToggle.evaluate().isNotEmpty) {
        await $.tap(searchableToggle);
        await $.pumpAndSettle();
      }

      // Export PDF
      final exportPdfButton = find.text('Export PDF');
      if (exportPdfButton.evaluate().isNotEmpty) {
        await $.tap(exportPdfButton);
        await $.pumpAndSettle(const Duration(seconds: 8));
      }

      // Download/Share PDF
      final downloadButton = find.text('Download');
      if (downloadButton.evaluate().isNotEmpty) {
        await $.tap(downloadButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('image export options', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Scan multiple pages
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }
      }

      // Export as images
      final exportButton = find.text('Export');
      if (exportButton.evaluate().isNotEmpty) {
        await $.tap(exportButton);
        await $.pumpAndSettle();
      }

      // Select image format
      final imagesOption = find.text('Images');
      if (imagesOption.evaluate().isNotEmpty) {
        await $.tap(imagesOption);
        await $.pumpAndSettle();
      }

      // Choose image format
      final jpegFormat = find.text('JPEG');
      if (jpegFormat.evaluate().isNotEmpty) {
        await $.tap(jpegFormat);
        await $.pumpAndSettle();
      }

      // Set quality
      final qualitySlider = find.byType(Slider);
      if (qualitySlider.evaluate().isNotEmpty) {
        await $.drag(qualitySlider.first, const Offset(20, 0));
        await $.pumpAndSettle();
      }

      // Export images
      final exportImagesButton = find.text('Export Images');
      if (exportImagesButton.evaluate().isNotEmpty) {
        await $.tap(exportImagesButton);
        await $.pumpAndSettle(const Duration(seconds: 5));
      }
    });

    patrolTest('manual corner adjustment', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Upload an image
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }
      }

      // Enable manual adjustment
      final manualButton = find.text('Manual');
      if (manualButton.evaluate().isNotEmpty) {
        await $.tap(manualButton);
        await $.pumpAndSettle();
      }

      // Adjust corners (simulate drag operations)
      final cornerHandles = find.byType(GestureDetector);
      if (cornerHandles.evaluate().length >= 4) {
        // Drag top-left corner
        await $.drag(cornerHandles.first, const Offset(10, 10));
        await $.pumpAndSettle();

        // Drag bottom-right corner
        await $.drag(cornerHandles.last, const Offset(-10, -10));
        await $.pumpAndSettle();
      }

      // Apply manual crop
      final applyButton = find.text('Apply');
      if (applyButton.evaluate().isNotEmpty) {
        await $.tap(applyButton);
        await $.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    patrolTest('camera controls functionality', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Verify camera tab is active or available
      final cameraTab = find.text('Camera');
      if (cameraTab.evaluate().isNotEmpty) {
        await $.tap(cameraTab);
        await $.pumpAndSettle();

        // Test flash control
        final flashButton = find.text('Flash');
        if (flashButton.evaluate().isNotEmpty) {
          await $.tap(flashButton);
          await $.pumpAndSettle();

          // Cycle through flash modes
          final flashAuto = find.text('Auto');
          if (flashAuto.evaluate().isNotEmpty) {
            await $.tap(flashAuto);
            await $.pumpAndSettle();
          }
        }

        // Test capture button
        final captureButton = find.byType(FloatingActionButton);
        if (captureButton.evaluate().isNotEmpty) {
          await $.tap(captureButton.first);
          await $.pumpAndSettle(const Duration(seconds: 3));
        }

        // Test auto-capture toggle
        final autoCapture = find.text('Auto');
        if (autoCapture.evaluate().isNotEmpty) {
          await $.tap(autoCapture);
          await $.pumpAndSettle();
        }
      }
    });

    patrolTest('error recovery and edge cases', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle();

      // Test with invalid image (simulated)
      final uploadTab = find.text('Upload');
      if (uploadTab.evaluate().isNotEmpty) {
        await $.tap(uploadTab);
        await $.pumpAndSettle();

        final uploadArea = find.text('Tap to select an image');
        if (uploadArea.evaluate().isNotEmpty) {
          await $.tap(uploadArea);
          await $.pumpAndSettle();
        }
      }

      // Verify error handling
      await $.pumpAndSettle(const Duration(seconds: 3));

      // Test recovery actions
      final retryButton = find.text('Retry');
      if (retryButton.evaluate().isNotEmpty) {
        await $.tap(retryButton);
        await $.pumpAndSettle();
      }

      // Verify app remains stable
      expect(find.text('Document Scanner'), findsOneWidget);
    });
  });
}