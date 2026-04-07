import 'package:alchemist/alchemist.dart';
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_test_config.dart';

/// Golden tests for the Document Scanner
///
/// Tests the camera interface, document detection,
/// filter applications, and scan management.
void main() {
  group('Document Scanner Golden Tests', () {
    goldenTest(
      'document scanner initial state',
      fileName: 'document_scanner_initial',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final themeName in GoldenTestConfig.themes.keys)
            for (final device in GoldenTestConfig.devices)
              GoldenTestConfig.createScenario(
                name: 'initial_${themeName}_${device.name}',
                theme: themeName,
                device: device,
                child: const DocumentScannerScreen(),
              ),
        ],
      ),
    );

    goldenTest(
      'document scanner camera permission',
      fileName: 'document_scanner_permission',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'permission_request_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withCameraPermissionRequest(
              const DocumentScannerScreen(),
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'permission_denied_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withCameraPermissionDenied(
              const DocumentScannerScreen(),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner camera interface',
      fileName: 'document_scanner_camera',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'camera_active_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withCameraActive(
              const DocumentScannerScreen(),
              showGrid: true,
              flashMode: 'auto',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'camera_controls_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withCameraControls(
              const DocumentScannerScreen(),
              zoomLevel: 1.5,
              focusPoint: const Offset(0.3, 0.4),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner document detection',
      fileName: 'document_scanner_detection',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'document_detected_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withDocumentDetected(
              const DocumentScannerScreen(),
              corners: [
                const Offset(0.1, 0.2),
                const Offset(0.9, 0.2),
                const Offset(0.9, 0.8),
                const Offset(0.1, 0.8),
              ],
              confidence: 0.95,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'detection_unstable_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withUnstableDetection(
              const DocumentScannerScreen(),
              stabilityProgress: 0.6,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner upload mode',
      fileName: 'document_scanner_upload',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'upload_zone_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withUploadMode(
              const DocumentScannerScreen(),
              showDropZone: true,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'image_uploaded_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withImageUploaded(
              const DocumentScannerScreen(),
              fileName: 'document.jpg',
              dimensions: '2048×1536',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner manual crop',
      fileName: 'document_scanner_crop',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'manual_crop_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withManualCrop(
              const DocumentScannerScreen(),
              cropHandles: [
                const Offset(0.15, 0.25),
                const Offset(0.85, 0.25),
                const Offset(0.85, 0.75),
                const Offset(0.15, 0.75),
              ],
              showHandles: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner filters',
      fileName: 'document_scanner_filters',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final filter in ['Original', 'Auto', 'Gray', 'B&W', 'Magic', 'Whiteboard'])
            GoldenTestConfig.createScenario(
              name: '${filter.toLowerCase()}_filter_dark_mobile',
              theme: 'dark',
              device: GoldenTestConfig.mobileDevice,
              child: GoldenTestConfig.withFilterApplied(
                const DocumentScannerScreen(),
                filterName: filter,
                showPreview: true,
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'document scanner page management',
      fileName: 'document_scanner_pages',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'multiple_pages_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withMultiplePages(
              const DocumentScannerScreen(),
              pageCount: 5,
              currentPage: 2,
              showThumbnails: true,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'page_reorder_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withPageReorder(
              const DocumentScannerScreen(),
              pages: 3,
              draggedPage: 1,
              targetPosition: 2,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner ocr processing',
      fileName: 'document_scanner_ocr',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'ocr_progress_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withOcrProgress(
              const DocumentScannerScreen(),
              progress: 0.7,
              currentPage: 3,
              totalPages: 5,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'ocr_results_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withOcrResults(
              const DocumentScannerScreen(),
              extractedText: GoldenTestData.sampleExtractedText,
              confidence: 0.89,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner export options',
      fileName: 'document_scanner_export',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'export_pdf_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withExportOptions(
              const DocumentScannerScreen(),
              exportFormat: 'PDF',
              includeOcr: true,
              pageCount: 4,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'export_images_light_mobile',
            theme: 'light',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withExportOptions(
              const DocumentScannerScreen(),
              exportFormat: 'Images',
              imageFormat: 'PNG',
              resolution: 'High',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'document scanner error states',
      fileName: 'document_scanner_errors',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'camera_error_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withError(
              const DocumentScannerScreen(),
              'Camera initialization failed. Please restart the app.',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'processing_error_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withError(
              const DocumentScannerScreen(),
              'Image processing failed. Please try again.',
            ),
          ),
        ],
      ),
    );
  });
}