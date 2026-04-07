import 'dart:typed_data';
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_core/core.dart';
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/scan_controls_widget.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/filter_selector_widget.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/export_options_widget.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/page_thumbnail_list.dart';
import 'package:bharattesting_utilities/features/document_scanner/models/document_scanner_state.dart';
import 'golden_test_config.dart';

void main() {
  group('Document Scanner Golden Tests', () {
    goldenTest(
      'document scanner screen layouts',
      fileName: 'document_scanner_layouts',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'scanner',
          (theme, device) => const DocumentScannerScreen(),
        );
      },
    );

    goldenTest(
      'scanner control widgets',
      fileName: 'scanner_controls',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Camera mode controls
          scenarios.add(
            GoldenTestScenario(
              name: 'controls_camera_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ScanControlsWidget(
                    mode: ScannerMode.camera,
                    isCapturing: false,
                    enableFlash: false,
                    isAutoCapture: false,
                    zoomLevel: 1.0,
                    canCapture: true,
                    onCapture: () {},
                    onFlashToggle: () {},
                    onAutoCaptureToggle: () {},
                    onZoomChanged: (zoom) {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 100)),
            ),
          );

          // Controls with flash and auto-capture enabled
          scenarios.add(
            GoldenTestScenario(
              name: 'controls_active_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ScanControlsWidget(
                    mode: ScannerMode.camera,
                    isCapturing: false,
                    enableFlash: true,
                    isAutoCapture: true,
                    zoomLevel: 2.0,
                    canCapture: true,
                    onCapture: () {},
                    onFlashToggle: () {},
                    onAutoCaptureToggle: () {},
                    onZoomChanged: (zoom) {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 100)),
            ),
          );

          // Capturing state
          scenarios.add(
            GoldenTestScenario(
              name: 'controls_capturing_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ScanControlsWidget(
                    mode: ScannerMode.camera,
                    isCapturing: true,
                    enableFlash: false,
                    isAutoCapture: false,
                    zoomLevel: 1.0,
                    canCapture: false,
                    onCapture: () {},
                    onFlashToggle: () {},
                    onAutoCaptureToggle: () {},
                    onZoomChanged: (zoom) {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 100)),
            ),
          );

          // Upload mode (no controls)
          scenarios.add(
            GoldenTestScenario(
              name: 'controls_upload_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ScanControlsWidget(
                    mode: ScannerMode.upload,
                    isCapturing: false,
                    enableFlash: false,
                    isAutoCapture: false,
                    zoomLevel: 1.0,
                    canCapture: true,
                    onCapture: () {},
                    onFlashToggle: () {},
                    onAutoCaptureToggle: () {},
                    onZoomChanged: (zoom) {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 100)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'filter selector states',
      fileName: 'filter_selector',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // All filters displayed
          scenarios.add(
            GoldenTestScenario(
              name: 'filters_all_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 400,
                  child: FilterSelectorWidget(
                    selectedFilter: DocumentFilter.original,
                    onFilterChanged: (filter) {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 300)),
            ),
          );

          // Compact mode
          scenarios.add(
            GoldenTestScenario(
              name: 'filters_compact_$theme',
              child: GoldenTestConfig.themedWrapper(
                FilterSelectorWidget(
                  selectedFilter: DocumentFilter.autoColor,
                  onFilterChanged: (filter) {},
                  isCompact: true,
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 80)),
            ),
          );

          // With preview
          scenarios.add(
            GoldenTestScenario(
              name: 'filters_with_preview_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 400,
                  child: FilterSelectorWidget(
                    selectedFilter: DocumentFilter.grayscale,
                    onFilterChanged: (filter) {},
                    showPreview: true,
                    previewImageData: GoldenTestUtils.createTestImageData(100, 100),
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 400)),
            ),
          );

          // Each filter selected
          for (final filter in DocumentFilter.values) {
            scenarios.add(
              GoldenTestScenario(
                name: 'filter_${filter.name}_selected_$theme',
                child: GoldenTestConfig.themedWrapper(
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: 400,
                    child: FilterSelectorWidget(
                      selectedFilter: filter,
                      onFilterChanged: (f) {},
                    ),
                  ),
                  theme,
                ),
                constraints: const BoxConstraints.tight(Size(432, 300)),
              ),
            );
          }
        }

        return scenarios;
      },
    );

    goldenTest(
      'export options configurations',
      fileName: 'export_options',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // PDF export options
          scenarios.add(
            GoldenTestScenario(
              name: 'export_pdf_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 350,
                  child: ExportOptionsWidget(
                    exportFormat: ExportFormat.pdf,
                    includeOcr: true,
                    exportFileName: 'test_document',
                    canExport: true,
                    isProcessing: false,
                    onExportFormatChanged: (format) {},
                    onOcrToggled: (enabled) {},
                    onFileNameChanged: (name) {},
                    onExport: () {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 400)),
            ),
          );

          // Images export options
          scenarios.add(
            GoldenTestScenario(
              name: 'export_images_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 350,
                  child: ExportOptionsWidget(
                    exportFormat: ExportFormat.images,
                    includeOcr: false,
                    exportFileName: 'scan_images',
                    canExport: true,
                    isProcessing: false,
                    onExportFormatChanged: (format) {},
                    onOcrToggled: (enabled) {},
                    onFileNameChanged: (name) {},
                    onExport: () {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 400)),
            ),
          );

          // ZIP export options
          scenarios.add(
            GoldenTestScenario(
              name: 'export_zip_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 350,
                  child: ExportOptionsWidget(
                    exportFormat: ExportFormat.zip,
                    includeOcr: false,
                    exportFileName: 'document_archive',
                    canExport: true,
                    isProcessing: false,
                    onExportFormatChanged: (format) {},
                    onOcrToggled: (enabled) {},
                    onFileNameChanged: (name) {},
                    onExport: () {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 400)),
            ),
          );

          // Compact export options
          scenarios.add(
            GoldenTestScenario(
              name: 'export_compact_$theme',
              child: GoldenTestConfig.themedWrapper(
                ExportOptionsWidget(
                  exportFormat: ExportFormat.pdf,
                  includeOcr: true,
                  exportFileName: 'mobile_scan',
                  canExport: true,
                  isProcessing: false,
                  onExportFormatChanged: (format) {},
                  onOcrToggled: (enabled) {},
                  onFileNameChanged: (name) {},
                  onExport: () {},
                  isCompact: true,
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(375, 120)),
            ),
          );

          // Processing state
          scenarios.add(
            GoldenTestScenario(
              name: 'export_processing_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 350,
                  child: ExportOptionsWidget(
                    exportFormat: ExportFormat.pdf,
                    includeOcr: true,
                    exportFileName: 'processing_doc',
                    canExport: true,
                    isProcessing: true,
                    onExportFormatChanged: (format) {},
                    onOcrToggled: (enabled) {},
                    onFileNameChanged: (name) {},
                    onExport: () {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 400)),
            ),
          );

          // Disabled state
          scenarios.add(
            GoldenTestScenario(
              name: 'export_disabled_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 350,
                  child: ExportOptionsWidget(
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
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 400)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'page thumbnail states',
      fileName: 'page_thumbnails',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        // Create mock scanned pages
        final mockPages = [
          ScannedPage(
            id: '1',
            originalImageData: Uint8List(1000),
            imageWidth: 640,
            imageHeight: 480,
            detectedCorners: DocumentQuadrilateral([
              const Point(0, 0),
              const Point(640, 0),
              const Point(640, 480),
              const Point(0, 480),
            ]),
            status: PageStatus.processed,
            captureTime: GoldenTestData.fixedDateTime,
          ),
          ScannedPage(
            id: '2',
            originalImageData: Uint8List(1500),
            imageWidth: 800,
            imageHeight: 600,
            detectedCorners: DocumentQuadrilateral([
              const Point(0, 0),
              const Point(800, 0),
              const Point(800, 600),
              const Point(0, 600),
            ]),
            status: PageStatus.processing,
            captureTime: GoldenTestData.fixedDateTime.subtract(const Duration(minutes: 1)),
          ),
          ScannedPage(
            id: '3',
            originalImageData: Uint8List(2000),
            imageWidth: 1024,
            imageHeight: 768,
            detectedCorners: DocumentQuadrilateral([
              const Point(0, 0),
              const Point(1024, 0),
              const Point(1024, 768),
              const Point(0, 768),
            ]),
            status: PageStatus.error,
            error: 'Processing failed',
            captureTime: GoldenTestData.fixedDateTime.subtract(const Duration(minutes: 2)),
          ),
        ];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Empty state
          scenarios.add(
            GoldenTestScenario(
              name: 'thumbnails_empty_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  height: 120,
                  child: PageThumbnailList(
                    pages: const [],
                    onPageSelected: (id) {},
                    onPageDeleted: (id) {},
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 120)),
            ),
          );

          // Horizontal list with pages
          scenarios.add(
            GoldenTestScenario(
              name: 'thumbnails_horizontal_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  height: 120,
                  child: PageThumbnailList(
                    pages: mockPages,
                    selectedPageId: '1',
                    onPageSelected: (id) {},
                    onPageDeleted: (id) {},
                    isVertical: false,
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 120)),
            ),
          );

          // Vertical list with details
          scenarios.add(
            GoldenTestScenario(
              name: 'thumbnails_vertical_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 320,
                  height: 400,
                  child: PageThumbnailList(
                    pages: mockPages,
                    selectedPageId: '2',
                    onPageSelected: (id) {},
                    onPageDeleted: (id) {},
                    isVertical: true,
                    showDetails: true,
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(320, 400)),
            ),
          );

          // Grid layout
          scenarios.add(
            GoldenTestScenario(
              name: 'thumbnails_grid_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 300,
                  child: PageThumbnailGrid(
                    pages: mockPages,
                    selectedPageId: '3',
                    onPageSelected: (id) {},
                    onPageDeleted: (id) {},
                    crossAxisCount: 2,
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(400, 300)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'scanner error states',
      fileName: 'scanner_errors',
      builder: () {
        return GoldenTestConfig.errorScenarios(
          'scanner',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: GoldenTestConfig.themes[theme]!.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Camera Permission Denied',
                  style: GoldenTestConfig.themes[theme]!.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please allow camera access to scan documents',
                  style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Settings'),
                ),
              ],
            ),
          ),
        );
      },
    );

    goldenTest(
      'scanner loading states',
      fileName: 'scanner_loading',
      builder: () {
        return GoldenTestConfig.loadingScenarios(
          'scanner',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing camera...'),
              ],
            ),
          ),
        );
      },
    );
  });

  group('Document Scanner Responsive Golden Tests', () {
    goldenTest(
      'scanner responsive layouts',
      fileName: 'scanner_responsive',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        // Mobile portrait
        scenarios.add(
          GoldenTestConfig.createScenario(
            name: 'mobile_portrait',
            child: const DocumentScannerScreen(),
            theme: 'dark',
            device: const Device(name: 'mobile', size: Size(375, 667)),
          ),
        );

        // Mobile landscape
        scenarios.add(
          GoldenTestConfig.createScenario(
            name: 'mobile_landscape',
            child: const DocumentScannerScreen(),
            theme: 'dark',
            device: const Device(name: 'mobile', size: Size(667, 375)),
          ),
        );

        // Tablet portrait
        scenarios.add(
          GoldenTestConfig.createScenario(
            name: 'tablet_portrait',
            child: const DocumentScannerScreen(),
            theme: 'dark',
            device: const Device(name: 'tablet', size: Size(768, 1024)),
          ),
        );

        // Tablet landscape
        scenarios.add(
          GoldenTestConfig.createScenario(
            name: 'tablet_landscape',
            child: const DocumentScannerScreen(),
            theme: 'dark',
            device: const Device(name: 'tablet', size: Size(1024, 768)),
          ),
        );

        // Desktop
        scenarios.add(
          GoldenTestConfig.createScenario(
            name: 'desktop',
            child: const DocumentScannerScreen(),
            theme: 'dark',
            device: const Device(name: 'desktop', size: Size(1280, 800)),
          ),
        );

        // Ultra-wide desktop
        scenarios.add(
          GoldenTestConfig.createScenario(
            name: 'ultrawide',
            child: const DocumentScannerScreen(),
            theme: 'dark',
            device: const Device(name: 'ultrawide', size: Size(1920, 800)),
          ),
        );

        return scenarios;
      },
    );
  });
}