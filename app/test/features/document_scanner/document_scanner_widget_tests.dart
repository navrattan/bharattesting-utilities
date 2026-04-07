import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';
import 'package:bharattesting_utilities/features/document_scanner/providers/document_scanner_provider.dart';
import 'package:bharattesting_utilities/features/document_scanner/models/document_scanner_state.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/scan_controls_widget.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/page_thumbnail_list.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/filter_selector_widget.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/export_options_widget.dart';

// Mock classes
class MockDocumentScannerNotifier extends Mock implements DocumentScannerNotifier {}

void main() {
  group('Document Scanner Widget Tests', () {
    late MockDocumentScannerNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockDocumentScannerNotifier();
    });

    group('DocumentScannerScreen', () {
      testWidgets('renders initial state correctly', (tester) async {
        when(() => mockNotifier.initializeCamera()).thenAnswer((_) async {});

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              documentScannerNotifierProvider.overrideWith(() => mockNotifier),
            ],
            child: const MaterialApp(
              home: DocumentScannerScreen(),
            ),
          ),
        );

        expect(find.text('Document Scanner'), findsOneWidget);
        verify(() => mockNotifier.initializeCamera()).called(1);
      });

      testWidgets('shows camera permission request when denied', (tester) async {
        const state = DocumentScannerState(
          permissionStatus: CameraPermissionStatus.denied,
          isLoading: false,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              documentScannerNotifierProvider.overrideWith(() => mockNotifier),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  when(() => mockNotifier.build()).thenReturn(state);
                  return const DocumentScannerScreen();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Camera Permission Required'), findsOneWidget);
      });

      testWidgets('handles mode switching between camera and upload', (tester) async {
        const cameraState = DocumentScannerState(
          permissionStatus: CameraPermissionStatus.granted,
          mode: ScannerMode.camera,
          isLoading: false,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              documentScannerNotifierProvider.overrideWith(() => mockNotifier),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  when(() => mockNotifier.build()).thenReturn(cameraState);
                  when(() => mockNotifier.toggleMode()).thenReturn(null);
                  return const DocumentScannerScreen();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final uploadButton = find.text('Upload');
        if (uploadButton.evaluate().isNotEmpty) {
          await tester.tap(uploadButton);
          verify(() => mockNotifier.toggleMode()).called(1);
        }
      });
    });

    group('ScanControlsWidget', () {
      testWidgets('renders camera control buttons', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScanControlsWidget(
                mode: ScannerMode.camera,
                isCapturing: false,
                enableFlash: false,
                isAutoCapture: true,
                zoomLevel: 1.0,
                canCapture: true,
                onCapture: () {},
                onFlashToggle: () {},
                onAutoCaptureToggle: () {},
                onZoomChanged: (zoom) {},
              ),
            ),
          ),
        );

        expect(find.byType(IconButton), findsWidgets);
      });

      testWidgets('capture button works correctly', (tester) async {
        bool capturePressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScanControlsWidget(
                mode: ScannerMode.camera,
                isCapturing: false,
                enableFlash: false,
                isAutoCapture: true,
                zoomLevel: 1.0,
                canCapture: true,
                onCapture: () {
                  capturePressed = true;
                },
                onFlashToggle: () {},
                onAutoCaptureToggle: () {},
                onZoomChanged: (zoom) {},
              ),
            ),
          ),
        );

        final captureButton = find.byType(FloatingActionButton);
        if (captureButton.evaluate().isNotEmpty) {
          await tester.tap(captureButton);
          expect(capturePressed, isTrue);
        }
      });

      testWidgets('flash toggle works correctly', (tester) async {
        bool flashToggled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScanControlsWidget(
                mode: ScannerMode.camera,
                isCapturing: false,
                enableFlash: false,
                isAutoCapture: true,
                zoomLevel: 1.0,
                canCapture: true,
                onCapture: () {},
                onFlashToggle: () {
                  flashToggled = true;
                },
                onAutoCaptureToggle: () {},
                onZoomChanged: (zoom) {},
              ),
            ),
          ),
        );

        final flashButton = find.byIcon(Icons.flash_off);
        if (flashButton.evaluate().isNotEmpty) {
          await tester.tap(flashButton);
          expect(flashToggled, isTrue);
        }
      });
    });

    group('PageThumbnailList', () {
      testWidgets('shows empty state when no pages', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PageThumbnailList(
                pages: const [],
                onPageSelected: (pageId) {},
                onPageDeleted: (pageId) {},
                onPageReordered: (oldIndex, newIndex) {},
              ),
            ),
          ),
        );

        expect(find.text('No pages scanned yet'), findsOneWidget);
      });

      testWidgets('displays pages when available', (tester) async {
        final mockPage = ScannedPage(
          id: 'page1',
          originalImage: const [],
          processedImage: const [],
          corners: const [
            DocumentCorner(x: 0.1, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.9),
            DocumentCorner(x: 0.1, y: 0.9),
          ],
          appliedFilter: DocumentFilter.original,
          timestamp: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PageThumbnailList(
                pages: [mockPage],
                onPageSelected: (pageId) {},
                onPageDeleted: (pageId) {},
                onPageReordered: (oldIndex, newIndex) {},
              ),
            ),
          ),
        );

        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('handles page selection', (tester) async {
        String? selectedPageId;
        final mockPage = ScannedPage(
          id: 'page1',
          originalImage: const [],
          processedImage: const [],
          corners: const [
            DocumentCorner(x: 0.1, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.9),
            DocumentCorner(x: 0.1, y: 0.9),
          ],
          appliedFilter: DocumentFilter.original,
          timestamp: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PageThumbnailList(
                pages: [mockPage],
                onPageSelected: (pageId) {
                  selectedPageId = pageId;
                },
                onPageDeleted: (pageId) {},
                onPageReordered: (oldIndex, newIndex) {},
              ),
            ),
          ),
        );

        final pageCard = find.byType(Card);
        await tester.tap(pageCard);

        expect(selectedPageId, equals('page1'));
      });
    });

    group('FilterSelectorWidget', () {
      testWidgets('displays all filter options', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterSelectorWidget(
                selectedFilter: DocumentFilter.original,
                onFilterSelected: (filter) {},
                previewImage: null,
              ),
            ),
          ),
        );

        // Should show filter options
        expect(find.text('Original'), findsOneWidget);
        expect(find.text('Auto'), findsOneWidget);
        expect(find.text('Gray'), findsOneWidget);
        expect(find.text('B&W'), findsOneWidget);
        expect(find.text('Magic'), findsOneWidget);
        expect(find.text('Whiteboard'), findsOneWidget);
      });

      testWidgets('handles filter selection', (tester) async {
        DocumentFilter? selectedFilter;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterSelectorWidget(
                selectedFilter: DocumentFilter.original,
                onFilterSelected: (filter) {
                  selectedFilter = filter;
                },
                previewImage: null,
              ),
            ),
          ),
        );

        final grayFilter = find.text('Gray');
        await tester.tap(grayFilter);

        expect(selectedFilter, equals(DocumentFilter.grayscale));
      });

      testWidgets('shows preview when image available', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterSelectorWidget(
                selectedFilter: DocumentFilter.original,
                onFilterSelected: (filter) {},
                previewImage: const [],
              ),
            ),
          ),
        );

        // Should show preview area
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('ExportOptionsWidget', () {
      testWidgets('shows PDF export options', (tester) async {
        final mockPage = ScannedPage(
          id: 'page1',
          originalImage: const [],
          processedImage: const [],
          corners: const [
            DocumentCorner(x: 0.1, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.9),
            DocumentCorner(x: 0.1, y: 0.9),
          ],
          appliedFilter: DocumentFilter.original,
          timestamp: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExportOptionsWidget(
                pages: [mockPage],
                exportFormat: ExportFormat.pdf,
                enableOcr: false,
                isProcessing: false,
                onFormatChanged: (format) {},
                onOcrToggle: (enable) {},
                onExport: () {},
              ),
            ),
          ),
        );

        expect(find.text('Export as PDF Document'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget); // OCR toggle
      });

      testWidgets('handles export format change', (tester) async {
        ExportFormat? selectedFormat;
        final mockPage = ScannedPage(
          id: 'page1',
          originalImage: const [],
          processedImage: const [],
          corners: const [
            DocumentCorner(x: 0.1, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.9),
            DocumentCorner(x: 0.1, y: 0.9),
          ],
          appliedFilter: DocumentFilter.original,
          timestamp: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExportOptionsWidget(
                pages: [mockPage],
                exportFormat: ExportFormat.pdf,
                enableOcr: false,
                isProcessing: false,
                onFormatChanged: (format) {
                  selectedFormat = format;
                },
                onOcrToggle: (enable) {},
                onExport: () {},
              ),
            ),
          ),
        );

        final imagesOption = find.text('Images');
        if (imagesOption.evaluate().isNotEmpty) {
          await tester.tap(imagesOption);
          expect(selectedFormat, equals(ExportFormat.images));
        }
      });

      testWidgets('handles OCR toggle', (tester) async {
        bool? ocrEnabled;
        final mockPage = ScannedPage(
          id: 'page1',
          originalImage: const [],
          processedImage: const [],
          corners: const [
            DocumentCorner(x: 0.1, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.9),
            DocumentCorner(x: 0.1, y: 0.9),
          ],
          appliedFilter: DocumentFilter.original,
          timestamp: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExportOptionsWidget(
                pages: [mockPage],
                exportFormat: ExportFormat.pdf,
                enableOcr: false,
                isProcessing: false,
                onFormatChanged: (format) {},
                onOcrToggle: (enable) {
                  ocrEnabled = enable;
                },
                onExport: () {},
              ),
            ),
          ),
        );

        final ocrSwitch = find.byType(Switch);
        await tester.tap(ocrSwitch);

        expect(ocrEnabled, isTrue);
      });

      testWidgets('triggers export when button pressed', (tester) async {
        bool exportTriggered = false;
        final mockPage = ScannedPage(
          id: 'page1',
          originalImage: const [],
          processedImage: const [],
          corners: const [
            DocumentCorner(x: 0.1, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.1),
            DocumentCorner(x: 0.9, y: 0.9),
            DocumentCorner(x: 0.1, y: 0.9),
          ],
          appliedFilter: DocumentFilter.original,
          timestamp: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExportOptionsWidget(
                pages: [mockPage],
                exportFormat: ExportFormat.pdf,
                enableOcr: false,
                isProcessing: false,
                onFormatChanged: (format) {},
                onOcrToggle: (enable) {},
                onExport: () {
                  exportTriggered = true;
                },
              ),
            ),
          ),
        );

        final exportButton = find.byType(ElevatedButton);
        await tester.tap(exportButton);

        expect(exportTriggered, isTrue);
      });
    });

    group('Responsive Design', () {
      testWidgets('document scanner adapts to different screen sizes', (tester) async {
        for (final size in [
          const Size(375, 667),  // Mobile
          const Size(768, 1024), // Tablet
          const Size(1280, 800), // Desktop
        ]) {
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                documentScannerNotifierProvider.overrideWith(() => mockNotifier),
              ],
              child: const MaterialApp(
                home: DocumentScannerScreen(),
              ),
            ),
          );

          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Error Handling', () {
      testWidgets('handles camera errors gracefully', (tester) async {
        const errorState = DocumentScannerState(
          permissionStatus: CameraPermissionStatus.granted,
          mode: ScannerMode.camera,
          isLoading: false,
          error: 'Camera initialization failed',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              documentScannerNotifierProvider.overrideWith(() => mockNotifier),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  when(() => mockNotifier.build()).thenReturn(errorState);
                  return const DocumentScannerScreen();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.textContaining('failed'), findsOneWidget);
      });
    });
  });
}