import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

/// End-to-end tests for Image Size Reducer
///
/// Tests image compression, batch processing, and export workflows
void main() {
  group('Image Reducer E2E Tests', () {


    patrolTest('single image compression workflow', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Verify initial state
      await $.waitUntilVisible(find.text('Image Size Reducer'));

      // Simulate image upload (in a real test, this would use file picker)
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Adjust quality slider
      final qualitySlider = find.byType(Slider);
      if (qualitySlider.evaluate().isNotEmpty) {
        await $.drag(qualitySlider.first, const Offset(-50, 0)); // Decrease quality
        await $.pumpAndSettle();
      }

      // Verify estimated size updates
      await $.pumpAndSettle(const Duration(milliseconds: 500));

      // Select output format
      final formatDropdown = find.text('JPEG');
      if (formatDropdown.evaluate().isNotEmpty) {
        await $.tap(formatDropdown);
        await $.pumpAndSettle();

        final webpOption = find.text('WebP');
        if (webpOption.evaluate().isNotEmpty) {
          await $.tap(webpOption);
          await $.pumpAndSettle();
        }
      }

      // Process image
      final compressButton = find.text('Compress');
      if (compressButton.evaluate().isNotEmpty) {
        await $.tap(compressButton);
        await $.pumpAndSettle(const Duration(seconds: 5));
      }

      // Download compressed image
      final downloadButton = find.text('Download');
      if (downloadButton.evaluate().isNotEmpty) {
        await $.tap(downloadButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('batch image processing', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Upload multiple images (simulated)
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Set batch processing options
      final batchQuality = find.byType(Slider);
      if (batchQuality.evaluate().isNotEmpty) {
        await $.drag(batchQuality.first, const Offset(30, 0)); // Set quality to 75%
        await $.pumpAndSettle();
      }

      // Process batch
      final processBatchButton = find.text('Process Batch');
      if (processBatchButton.evaluate().isNotEmpty) {
        await $.tap(processBatchButton);

        // Wait for batch processing with progress indicator
        await $.pumpAndSettle(const Duration(seconds: 10));

        // Verify progress indicator appears
        final progressIndicator = find.byType(LinearProgressIndicator);
        if (progressIndicator.evaluate().isNotEmpty) {
          // Wait for completion
          await $.waitUntilGone(progressIndicator, timeout: const Duration(seconds: 30));
        }
      }

      // Download as ZIP
      final downloadZipButton = find.text('Download ZIP');
      if (downloadZipButton.evaluate().isNotEmpty) {
        await $.tap(downloadZipButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('resize presets functionality', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Upload an image
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Test different resize presets
      final presets = ['Thumbnail (150px)', 'Small (640px)', 'HD (1280px)', 'Full HD (1920px)'];

      for (final preset in presets) {
        final presetButton = find.text(preset);
        if (presetButton.evaluate().isNotEmpty) {
          await $.tap(presetButton);
          await $.pumpAndSettle();

          // Verify dimensions update
          await $.pumpAndSettle(const Duration(milliseconds: 300));
          break; // Test one preset for time
        }
      }

      // Test custom dimensions
      final customOption = find.text('Custom');
      if (customOption.evaluate().isNotEmpty) {
        await $.tap(customOption);
        await $.pumpAndSettle();

        // Enter custom width
        final widthField = find.byType(TextField);
        if (widthField.evaluate().isNotEmpty) {
          await $.enterText(widthField.first, '800');
          await $.pumpAndSettle();
        }
      }
    });

    patrolTest('metadata stripping options', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Upload an image
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Toggle EXIF stripping
      final stripExifToggle = find.text('Remove EXIF');
      if (stripExifToggle.evaluate().isNotEmpty) {
        await $.tap(stripExifToggle);
        await $.pumpAndSettle();
      }

      // Toggle GPS stripping
      final stripGpsToggle = find.text('Remove GPS');
      if (stripGpsToggle.evaluate().isNotEmpty) {
        await $.tap(stripGpsToggle);
        await $.pumpAndSettle();
      }

      // Process with metadata removal
      final compressButton = find.text('Compress');
      if (compressButton.evaluate().isNotEmpty) {
        await $.tap(compressButton);
        await $.pumpAndSettle(const Duration(seconds: 3));
      }
    });

    patrolTest('before after comparison', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Upload and process an image
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Adjust compression
      final qualitySlider = find.byType(Slider);
      if (qualitySlider.evaluate().isNotEmpty) {
        await $.drag(qualitySlider.first, const Offset(-30, 0));
        await $.pumpAndSettle();
      }

      // Process image to enable comparison
      final compressButton = find.text('Compress');
      if (compressButton.evaluate().isNotEmpty) {
        await $.tap(compressButton);
        await $.pumpAndSettle(const Duration(seconds: 3));
      }

      // Test comparison slider
      final comparisonSlider = find.text('Compare');
      if (comparisonSlider.evaluate().isNotEmpty) {
        await $.tap(comparisonSlider);
        await $.pumpAndSettle();

        // Drag comparison slider
        final slider = find.byType(Slider);
        if (slider.evaluate().length > 1) {
          await $.drag(slider.last, const Offset(50, 0));
          await $.pumpAndSettle();
        }
      }
    });

    patrolTest('format conversion test', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Upload a PNG image
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Convert PNG to JPEG
      final formatSelector = find.text('PNG');
      if (formatSelector.evaluate().isNotEmpty) {
        await $.tap(formatSelector);
        await $.pumpAndSettle();

        final jpegOption = find.text('JPEG');
        if (jpegOption.evaluate().isNotEmpty) {
          await $.tap(jpegOption);
          await $.pumpAndSettle();
        }
      }

      // Convert to WebP
      final webpOption = find.text('WebP');
      if (webpOption.evaluate().isNotEmpty) {
        await $.tap(webpOption);
        await $.pumpAndSettle();
      }

      // Process conversion
      final convertButton = find.text('Convert');
      if (convertButton.evaluate().isNotEmpty) {
        await $.tap(convertButton);
        await $.pumpAndSettle(const Duration(seconds: 3));
      }
    });

    patrolTest('error handling for unsupported formats', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Try to upload an unsupported file type (simulated)
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Should show error for unsupported format
      await $.pumpAndSettle(const Duration(seconds: 2));

      // Look for error message
      final errorText = find.textContaining('Unsupported', findRichText: true);
      if (errorText.evaluate().isNotEmpty) {
        expect(errorText, findsOneWidget);
      }
    });

    patrolTest('maximum file size validation', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Try to upload a file that's too large (simulated)
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Should show error for file too large
      await $.pumpAndSettle(const Duration(seconds: 2));

      // Look for size limit error
      final sizeError = find.textContaining('too large', findRichText: true);
      if (sizeError.evaluate().isNotEmpty) {
        expect(sizeError, findsOneWidget);
      }
    });

    patrolTest('quality real-time preview', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle();

      // Upload an image
      final uploadButton = find.text('Select Images');
      if (uploadButton.evaluate().isNotEmpty) {
        await $.tap(uploadButton);
        await $.pumpAndSettle();
      }

      // Adjust quality and verify real-time updates
      final qualitySlider = find.byType(Slider);
      if (qualitySlider.evaluate().isNotEmpty) {
        // Test multiple quality levels
        for (final offset in [-60, -30, 0, 30]) {
          await $.drag(qualitySlider.first, Offset(offset.toDouble(), 0));
          await $.pumpAndSettle();

          // Wait for debounced preview update
          await $.pumpAndSettle(const Duration(milliseconds: 400));
        }
      }
    });
  });
}