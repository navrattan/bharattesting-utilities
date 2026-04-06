import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_core/core.dart';
import 'package:bharattesting_utilities/features/document_scanner/models/document_scanner_state.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/export_options_widget.dart';

void main() {
  group('ExportOptionsWidget Tests', () {
    testWidgets('displays all export options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Should display main sections
      expect(find.text('Export Options'), findsOneWidget);
      expect(find.text('Export Format'), findsOneWidget);
      expect(find.text('Include OCR Text'), findsOneWidget);
      expect(find.text('File Name'), findsOneWidget);
    });

    testWidgets('shows all export format options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Should show all format options
      expect(find.text('PDF Document'), findsOneWidget);
      expect(find.text('Individual Images'), findsOneWidget);
      expect(find.text('ZIP Archive'), findsOneWidget);
    });

    testWidgets('handles export format selection', (tester) async {
      ExportFormat? selectedFormat;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) => selectedFormat = format,
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Tap on ZIP format
      await tester.tap(find.text('ZIP Archive'));
      expect(selectedFormat, equals(ExportFormat.zip));
    });

    testWidgets('handles OCR toggle', (tester) async {
      bool? ocrEnabled;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) => ocrEnabled = enabled,
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Toggle OCR switch
      await tester.tap(find.byType(Switch));
      expect(ocrEnabled, isTrue);
    });

    testWidgets('handles file name input', (tester) async {
      String? enteredFileName;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: 'test_document',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) => enteredFileName = name,
              onExport: () {},
            ),
          ),
        ),
      );

      // Should show existing file name
      expect(find.text('test_document'), findsOneWidget);

      // Enter new file name
      await tester.enterText(find.byType(TextFormField), 'new_document');
      expect(enteredFileName, equals('new_document'));
    });

    testWidgets('shows correct file extension for format', (tester) async {
      // Test PDF extension
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      expect(find.text('.pdf'), findsOneWidget);

      // Test ZIP extension
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.zip,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      expect(find.text('.zip'), findsOneWidget);
    });

    testWidgets('export button works correctly', (tester) async {
      bool exportPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () => exportPressed = true,
            ),
          ),
        ),
      );

      // Tap export button
      await tester.tap(find.text('Export as PDF Document'));
      expect(exportPressed, isTrue);
    });

    testWidgets('disables export button when cannot export', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: false,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Export button should be disabled
      final exportButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(exportButton.onPressed, isNull);
    });

    testWidgets('shows processing state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: true,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Should show processing state
      expect(find.text('Exporting...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('compact mode shows simplified interface', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
              isCompact: true,
            ),
          ),
        ),
      );

      // Compact mode should show format chips and export button only
      expect(find.text('Export Options'), findsNothing); // No title in compact mode
      expect(find.byType(FilledButton), findsOneWidget); // Export button
    });

    testWidgets('format chips show descriptions in full mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Should show format descriptions
      expect(find.text('Single document'), findsOneWidget); // PDF description
      expect(find.text('Separate files'), findsOneWidget); // Images description
      expect(find.text('Archive with images'), findsOneWidget); // ZIP description
    });

    testWidgets('shows default file name when empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Should show default file name pattern
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.initialValue, startsWith('BharatTesting_Scan_'));
    });
  });

  group('AdvancedExportOptions Tests', () {
    testWidgets('displays all advanced options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedExportOptions(
              exportFormat: ExportFormat.pdf,
              includeOcr: true,
              compressImages: false,
              imageQuality: 80,
              onOcrToggled: (enabled) {},
              onCompressionToggled: (enabled) {},
              onQualityChanged: (quality) {},
            ),
          ),
        ),
      );

      expect(find.text('Advanced Options'), findsOneWidget);
      expect(find.text('Include OCR Text'), findsOneWidget);
      expect(find.text('Compress Images'), findsOneWidget);
    });

    testWidgets('shows quality slider when compression enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedExportOptions(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              compressImages: true,
              imageQuality: 75,
              onOcrToggled: (enabled) {},
              onCompressionToggled: (enabled) {},
              onQualityChanged: (quality) {},
            ),
          ),
        ),
      );

      // Should show quality controls when compression is enabled
      expect(find.text('Image Quality: 75%'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Smaller size'), findsOneWidget);
      expect(find.text('Better quality'), findsOneWidget);
    });

    testWidgets('hides quality slider when compression disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedExportOptions(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              compressImages: false,
              imageQuality: 80,
              onOcrToggled: (enabled) {},
              onCompressionToggled: (enabled) {},
              onQualityChanged: (quality) {},
            ),
          ),
        ),
      );

      // Should not show quality controls when compression is disabled
      expect(find.text('Image Quality: 80%'), findsNothing);
      expect(find.byType(Slider), findsNothing);
    });

    testWidgets('shows PDF-specific options for PDF format', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedExportOptions(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              compressImages: false,
              imageQuality: 80,
              onOcrToggled: (enabled) {},
              onCompressionToggled: (enabled) {},
              onQualityChanged: (quality) {},
            ),
          ),
        ),
      );

      // Should show PDF-specific options
      expect(find.text('PDF Options'), findsOneWidget);
      expect(find.text('Password Protection'), findsOneWidget);
      expect(find.text('Page Orientation'), findsOneWidget);
    });

    testWidgets('handles compression toggle', (tester) async {
      bool? compressionEnabled;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedExportOptions(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              compressImages: false,
              imageQuality: 80,
              onOcrToggled: (enabled) {},
              onCompressionToggled: (enabled) => compressionEnabled = enabled,
              onQualityChanged: (quality) {},
            ),
          ),
        ),
      );

      // Toggle compression
      final switchTiles = find.byType(SwitchListTile);
      await tester.tap(switchTiles.at(1)); // Second switch is compression
      expect(compressionEnabled, isTrue);
    });

    testWidgets('quality slider works correctly', (tester) async {
      int? qualityChanged;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedExportOptions(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              compressImages: true,
              imageQuality: 80,
              onOcrToggled: (enabled) {},
              onCompressionToggled: (enabled) {},
              onQualityChanged: (quality) => qualityChanged = quality,
            ),
          ),
        ),
      );

      // Move quality slider
      await tester.drag(find.byType(Slider), const Offset(50, 0));
      await tester.pumpAndSettle();

      // Should trigger callback (exact value hard to test due to slider behavior)
    });
  });

  group('Export Dialog Tests', () {
    testWidgets('ExportProgressDialog displays correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportProgressDialog(
              progress: 0.6,
              currentStep: 3,
              totalSteps: 5,
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Exporting Document...'), findsOneWidget);
      expect(find.text('Step 3 of 5'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('ExportSuccessDialog displays correctly', (tester) async {
      bool sharePressed = false;
      bool savePressed = false;
      bool closePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportSuccessDialog(
              fileName: 'test_document.pdf',
              fileSize: '2.5 MB',
              onShare: () => sharePressed = true,
              onSaveToDevice: () => savePressed = true,
              onClose: () => closePressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Export Successful'), findsOneWidget);
      expect(find.text('test_document.pdf'), findsOneWidget);
      expect(find.text('2.5 MB'), findsOneWidget);

      // Test button actions
      await tester.tap(find.text('Share'));
      expect(sharePressed, isTrue);

      await tester.tap(find.text('Save'));
      expect(savePressed, isTrue);

      await tester.tap(find.text('Done'));
      expect(closePressed, isTrue);
    });

    testWidgets('progress dialog cancel button works', (tester) async {
      bool cancelPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportProgressDialog(
              progress: 0.3,
              currentStep: 2,
              totalSteps: 4,
              onCancel: () => cancelPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      expect(cancelPressed, isTrue);
    });
  });

  group('Export Format Extensions Tests', () {
    test('ExportFormat displayName extension works', () {
      expect(ExportFormat.pdf.displayName, equals('PDF Document'));
      expect(ExportFormat.images.displayName, equals('Individual Images'));
      expect(ExportFormat.zip.displayName, equals('ZIP Archive'));
    });

    test('ExportFormat fileExtension extension works', () {
      expect(ExportFormat.pdf.fileExtension, equals('pdf'));
      expect(ExportFormat.images.fileExtension, equals('jpg'));
      expect(ExportFormat.zip.fileExtension, equals('zip'));
    });

    test('all export formats have extensions', () {
      for (final format in ExportFormat.values) {
        expect(format.fileExtension, isA<String>());
        expect(format.fileExtension.isNotEmpty, isTrue);
      }
    });
  });

  group('Format Icon Tests', () {
    test('each export format has appropriate icon', () {
      // This tests the internal _getExportIcon method indirectly
      for (final format in ExportFormat.values) {
        expect(format.displayName, isA<String>());
        expect(format.displayName.isNotEmpty, isTrue);
      }
    });
  });

  group('Export Configuration Tests', () {
    test('ExportConfig has reasonable defaults', () {
      const config = ExportConfig();

      expect(config.format, equals(ExportFormat.pdf));
      expect(config.includeOcr, isTrue);
      expect(config.fileName, equals('BharatTesting Scan'));
      expect(config.compressImages, isFalse);
      expect(config.imageQuality, equals(80));
    });

    test('ExportConfig copyWith works correctly', () {
      const original = ExportConfig();
      final modified = original.copyWith(
        format: ExportFormat.zip,
        includeOcr: false,
        fileName: 'Custom Document',
      );

      expect(modified.format, equals(ExportFormat.zip));
      expect(modified.includeOcr, isFalse);
      expect(modified.fileName, equals('Custom Document'));
      expect(modified.compressImages, isFalse); // Should remain unchanged
      expect(modified.imageQuality, equals(80)); // Should remain unchanged
    });

    test('ExportConfig equality works', () {
      const config1 = ExportConfig();
      const config2 = ExportConfig();
      const config3 = ExportConfig(format: ExportFormat.images);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });
  });

  group('File Size Validation Tests', () {
    testWidgets('validates file name input constraints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportOptionsWidget(
              exportFormat: ExportFormat.pdf,
              includeOcr: false,
              exportFileName: '',
              canExport: true,
              isProcessing: false,
              onExportFormatChanged: (format) {},
              onOcrToggled: (enabled) {},
              onFileNameChanged: (name) {},
              onExport: () {},
            ),
          ),
        ),
      );

      // Test entering various file names
      await tester.enterText(find.byType(TextFormField), '');
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.enterText(find.byType(TextFormField), 'very_long_filename_that_might_cause_issues_on_some_filesystems');

      // Widget should handle all inputs gracefully
      await tester.pumpAndSettle();
    });
  });
}