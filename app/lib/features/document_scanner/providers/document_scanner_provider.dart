import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharattesting_core/src/document_scanner/edge_detector.dart';
import 'package:bharattesting_core/src/document_scanner/image_enhancer.dart';
import 'package:bharattesting_core/src/document_scanner/ocr_processor.dart';
import 'package:bharattesting_core/src/document_scanner/perspective_corrector.dart';
import '../models/document_scanner_state.dart';

part 'document_scanner_provider.g.dart';

@riverpod
class DocumentScannerNotifier extends _$DocumentScannerNotifier {
  Timer? _detectionTimer;
  Timer? _stabilityTimer;
  StreamSubscription<CameraImage>? _imageSubscription;
  bool _isProcessingFrame = false;

  @override
  DocumentScannerState build() {
    ref.onDispose(() {
      _cleanup();
    });

    return const DocumentScannerState();
  }

  /// Initialize camera system
  Future<void> initializeCamera() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _initializeMobileCamera();
    } else {
      // Web fallback - no live camera, upload mode only
      state = state.copyWith(
        mode: ScannerMode.upload,
        permissionStatus: CameraPermissionStatus.granted,
      );
    }
  }

  /// Initialize mobile camera
  Future<void> _initializeMobileCamera() async {
    try {
      // Check camera permission
      final permissionStatus = await _checkCameraPermission();
      state = state.copyWith(permissionStatus: permissionStatus);

      if (!permissionStatus.isGranted) return;

      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(
          processingErrors: [...state.processingErrors, 'No cameras available'],
        );
        return;
      }

      // Initialize camera controller
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller.initialize();

      state = state.copyWith(
        availableCameras: cameras,
        cameraController: controller,
        isCameraInitialized: true,
      );

      // Start live detection
      if (state.mode == ScannerMode.camera) {
        _startLiveDetection();
      }

    } catch (e) {
      state = state.copyWith(
        processingErrors: [...state.processingErrors, 'Camera initialization failed: $e'],
      );
    }
  }

  /// Check and request camera permission
  Future<CameraPermissionStatus> _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      return CameraPermissionStatus.granted;
    } else if (status == PermissionStatus.denied) {
      final result = await Permission.camera.request();
      return result == PermissionStatus.granted
        ? CameraPermissionStatus.granted
        : CameraPermissionStatus.denied;
    } else if (status == PermissionStatus.permanentlyDenied) {
      return CameraPermissionStatus.permanentlyDenied;
    } else if (status == PermissionStatus.restricted) {
      return CameraPermissionStatus.restricted;
    }

    return CameraPermissionStatus.unknown;
  }

  /// Start live document detection
  void _startLiveDetection() {
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _processCurrentFrame();
    });
  }

  /// Process current camera frame for edge detection
  Future<void> _processCurrentFrame() async {
    if (_isProcessingFrame || state.cameraController == null || !state.isCameraInitialized) {
      return;
    }

    try {
      _isProcessingFrame = true;
      final controller = state.cameraController!;

      // Capture frame
      final image = await controller.takePicture();
      final imageBytes = await image.readAsBytes();

      // Decode image to get dimensions
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final width = frame.image.width;
      final height = frame.image.height;

      // Convert to RGB for processing
      final rgbData = await compute(_convertToRgb, {
        'imageBytes': imageBytes,
        'width': width,
        'height': height,
      });

      // Detect document edges
      final quadrilateral = await compute(_detectDocumentEdges, {
        'imageData': rgbData,
        'width': width,
        'height': height,
      });

      // Update detection state
      final now = DateTime.now();
      state = state.copyWith(
        detectedDocument: quadrilateral,
        lastDetectionTime: now,
        isDocumentStable: _checkStability(quadrilateral, now),
      );

      // Auto-capture if enabled and document is stable
      if (state.isAutoCapture && state.isDocumentStable && !state.isCapturing) {
        await _autoCapture();
      }

    } catch (e) {
      // Silently handle detection errors to avoid UI spam
      debugPrint('Frame processing error: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  /// Check if detected document is stable
  bool _checkStability(DocumentQuadrilateral? quad, DateTime now) {
    if (quad == null) return false;
    if (state.lastDetectionTime == null) return false;

    // Check if detection has been stable for required duration
    final timeSinceDetection = now.difference(state.lastDetectionTime!);
    return timeSinceDetection.inMilliseconds >= (state.autoCaptureDuration * 1000);
  }

  /// Auto-capture document when stable
  Future<void> _autoCapture() async {
    if (state.detectedDocument == null) return;

    await captureDocument();
  }

  /// Manually capture document
  Future<void> captureDocument() async {
    if (state.cameraController == null || state.isCapturing) return;

    try {
      state = state.copyWith(isCapturing: true, processingErrors: []);

      // Capture high-resolution image
      final image = await state.cameraController!.takePicture();
      final imageBytes = await image.readAsBytes();

      // Decode image
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final width = frame.image.width;
      final height = frame.image.height;

      // Convert to RGB
      final rgbData = await compute(_convertToRgb, {
        'imageBytes': imageBytes,
        'width': width,
        'height': height,
      });

      // Detect edges on high-res image
      final quadrilateral = await compute(_detectDocumentEdges, {
        'imageData': rgbData,
        'width': width,
        'height': height,
      });

      if (quadrilateral == null) {
        throw Exception('No document detected in captured image');
      }

      // Create scanned page
      final page = ScannedPage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalImageData: rgbData,
        imageWidth: width,
        imageHeight: height,
        detectedCorners: quadrilateral,
        captureTime: DateTime.now(),
      );

      state = state.copyWith(
        scannedPages: [...state.scannedPages, page],
        selectedPage: page,
      );

      // Process the page
      await _processPage(page.id);

    } catch (e) {
      state = state.copyWith(
        processingErrors: [...state.processingErrors, 'Capture failed: $e'],
      );
    } finally {
      state = state.copyWith(isCapturing: false);
    }
  }

  /// Process a captured page (perspective correction + filtering)
  Future<void> _processPage(String pageId) async {
    final page = state.scannedPages.firstWhere((p) => p.id == pageId);

    try {
      // Update page status
      _updatePageStatus(pageId, PageStatus.processing);

      // Perspective correction
      final corrected = await compute(_correctPerspective, {
        'imageData': page.originalImageData,
        'width': page.imageWidth,
        'height': page.imageHeight,
        'quadrilateral': page.detectedCorners,
      });

      // Apply current filter
      final filtered = await compute(_applyDocumentFilter, {
        'imageData': corrected.imageData,
        'width': corrected.width,
        'height': corrected.height,
        'filter': state.selectedFilter,
      });

      // Generate thumbnail
      final thumbnail = await compute(_generateThumbnail, {
        'imageData': filtered,
        'width': corrected.width,
        'height': corrected.height,
      });

      // Update page
      final updatedPage = page.copyWith(
        correctedImageData: corrected.imageData,
        correctedWidth: corrected.width,
        correctedHeight: corrected.height,
        appliedFilter: state.selectedFilter,
        filteredImageData: filtered,
        thumbnailData: thumbnail,
        status: PageStatus.processed,
      );

      _updatePage(updatedPage);

      // Run OCR if enabled
      if (state.includeOcr) {
        await _runOcrOnPage(pageId);
      }

    } catch (e) {
      _updatePageStatus(pageId, PageStatus.error, error: 'Processing failed: $e');
    }
  }

  /// Run OCR on a processed page
  Future<void> _runOcrOnPage(String pageId) async {
    final page = state.scannedPages.firstWhere((p) => p.id == pageId);

    if (page.filteredImageData == null) return;

    try {
      final ocrResult = await compute(_extractDocumentText, {
        'imageData': page.filteredImageData!,
        'width': page.correctedWidth ?? page.imageWidth,
        'height': page.correctedHeight ?? page.imageHeight,
      });

      final updatedPage = page.copyWith(ocrResult: ocrResult);
      _updatePage(updatedPage);

    } catch (e) {
      debugPrint('OCR failed for page $pageId: $e');
    }
  }

  /// Upload image file for processing
  Future<void> uploadImage(Uint8List imageBytes) async {
    try {
      state = state.copyWith(isProcessing: true, processingErrors: []);

      // Decode image
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final width = frame.image.width;
      final height = frame.image.height;

      // Convert to RGB
      final rgbData = await compute(_convertToRgb, {
        'imageBytes': imageBytes,
        'width': width,
        'height': height,
      });

      // Detect edges
      final quadrilateral = await compute(_detectDocumentEdges, {
        'imageData': rgbData,
        'width': width,
        'height': height,
      });

      if (quadrilateral == null) {
        throw Exception('No document detected in uploaded image');
      }

      // Create scanned page
      final page = ScannedPage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalImageData: rgbData,
        imageWidth: width,
        imageHeight: height,
        detectedCorners: quadrilateral,
        captureTime: DateTime.now(),
      );

      state = state.copyWith(
        scannedPages: [...state.scannedPages, page],
        selectedPage: page,
        isProcessing: false,
      );

      // Process the page
      await _processPage(page.id);

    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        processingErrors: [...state.processingErrors, 'Upload failed: $e'],
      );
    }
  }

  /// Change document filter
  Future<void> changeFilter(DocumentFilter filter) async {
    state = state.copyWith(selectedFilter: filter);

    // Re-apply filter to selected page
    if (state.selectedPage?.correctedImageData != null) {
      await _reapplyFilterToPage(state.selectedPage!.id);
    }
  }

  /// Re-apply filter to a page
  Future<void> _reapplyFilterToPage(String pageId) async {
    final page = state.scannedPages.firstWhere((p) => p.id == pageId);

    if (page.correctedImageData == null) return;

    try {
      final filtered = await compute(_applyDocumentFilter, {
        'imageData': page.correctedImageData!,
        'width': page.correctedWidth ?? page.imageWidth,
        'height': page.correctedHeight ?? page.imageHeight,
        'filter': state.selectedFilter,
      });

      final updatedPage = page.copyWith(
        appliedFilter: state.selectedFilter,
        filteredImageData: filtered,
      );

      _updatePage(updatedPage);

    } catch (e) {
      debugPrint('Filter application failed: $e');
    }
  }

  /// Export scanned documents
  Future<void> exportDocuments() async {
    if (state.scannedPages.isEmpty) return;

    try {
      state = state.copyWith(isProcessing: true, processingErrors: []);

      switch (state.exportFormat) {
        case ExportFormat.pdf:
          await _exportAsPdf();
          break;
        case ExportFormat.images:
          await _exportAsImages();
          break;
        case ExportFormat.zip:
          await _exportAsZip();
          break;
      }

    } catch (e) {
      state = state.copyWith(
        processingErrors: [...state.processingErrors, 'Export failed: $e'],
      );
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  /// Export as PDF
  Future<void> _exportAsPdf() async {
    final processedPages = state.scannedPages.where((p) => p.isProcessed).toList();
    if (processedPages.isEmpty) return;

    // Generate searchable PDF if OCR is enabled
    if (state.includeOcr && processedPages.any((p) => p.hasOcrText)) {
      final pdfData = await compute(_generateSearchablePdf, {
        'pages': processedPages,
        'fileName': state.exportFileName.isNotEmpty
          ? state.exportFileName
          : 'BharatTesting_Scan_${DateTime.now().millisecondsSinceEpoch}',
      });

      state = state.copyWith(
        exportData: pdfData,
        exportFileName: '${state.exportFileName}.pdf',
      );
    } else {
      // Regular PDF without OCR
      final pdfData = await compute(_generatePdf, {
        'pages': processedPages,
        'fileName': state.exportFileName.isNotEmpty
          ? state.exportFileName
          : 'BharatTesting_Scan_${DateTime.now().millisecondsSinceEpoch}',
      });

      state = state.copyWith(
        exportData: pdfData,
        exportFileName: '${state.exportFileName}.pdf',
      );
    }
  }

  /// Export as individual images
  Future<void> _exportAsImages() async {
    // For individual images, just set up for download
    // UI will handle individual downloads
    state = state.copyWith(
      exportData: null,
      exportFileName: 'images',
    );
  }

  /// Export as ZIP
  Future<void> _exportAsZip() async {
    final processedPages = state.scannedPages.where((p) => p.isProcessed).toList();
    if (processedPages.isEmpty) return;

    final zipData = await compute(_generateZip, {
      'pages': processedPages,
      'fileName': state.exportFileName.isNotEmpty
        ? state.exportFileName
        : 'BharatTesting_Scan_${DateTime.now().millisecondsSinceEpoch}',
    });

    state = state.copyWith(
      exportData: zipData,
      exportFileName: '${state.exportFileName}.zip',
    );
  }

  /// Switch scanner mode
  void changeScannerMode(ScannerMode mode) {
    state = state.copyWith(mode: mode);

    if (mode == ScannerMode.camera && state.isCameraInitialized) {
      _startLiveDetection();
    } else {
      _stopLiveDetection();
    }
  }

  /// Toggle auto-capture
  void toggleAutoCapture() {
    state = state.copyWith(isAutoCapture: !state.isAutoCapture);
  }

  /// Toggle flash
  Future<void> toggleFlash() async {
    if (state.cameraController == null) return;

    try {
      final newFlashState = !state.enableFlash;
      await state.cameraController!.setFlashMode(
        newFlashState ? FlashMode.torch : FlashMode.off,
      );

      state = state.copyWith(enableFlash: newFlashState);
    } catch (e) {
      debugPrint('Flash toggle failed: $e');
    }
  }

  /// Set zoom level
  Future<void> setZoomLevel(double zoom) async {
    if (state.cameraController == null) return;

    try {
      await state.cameraController!.setZoomLevel(zoom);
      state = state.copyWith(zoomLevel: zoom);
    } catch (e) {
      debugPrint('Zoom failed: $e');
    }
  }

  /// Delete page
  void deletePage(String pageId) {
    final updatedPages = state.scannedPages.where((p) => p.id != pageId).toList();
    final newSelectedPage = updatedPages.isNotEmpty ? updatedPages.last : null;

    state = state.copyWith(
      scannedPages: updatedPages,
      selectedPage: newSelectedPage,
    );
  }

  /// Reorder pages
  void reorderPages(int oldIndex, int newIndex) {
    final pages = List<ScannedPage>.from(state.scannedPages);
    final page = pages.removeAt(oldIndex);
    pages.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, page);

    state = state.copyWith(scannedPages: pages);
  }

  /// Clear all pages
  void clearPages() {
    state = state.copyWith(
      scannedPages: [],
      selectedPage: null,
      exportData: null,
      exportFileName: '',
    );
  }

  /// Select page
  void selectPage(String pageId) {
    final page = state.scannedPages.firstWhere((p) => p.id == pageId);
    state = state.copyWith(selectedPage: page);
  }

  /// Change export format
  void changeExportFormat(ExportFormat format) {
    state = state.copyWith(exportFormat: format);
  }

  /// Toggle OCR inclusion
  void toggleOcr() {
    state = state.copyWith(includeOcr: !state.includeOcr);
  }

  /// Set export file name
  void setExportFileName(String fileName) {
    state = state.copyWith(exportFileName: fileName);
  }

  /// Helper methods
  void _updatePageStatus(String pageId, PageStatus status, {String? error}) {
    final pageIndex = state.scannedPages.indexWhere((p) => p.id == pageId);
    if (pageIndex == -1) return;

    final updatedPage = state.scannedPages[pageIndex].copyWith(
      status: status,
      error: error ?? '',
    );

    final updatedPages = List<ScannedPage>.from(state.scannedPages);
    updatedPages[pageIndex] = updatedPage;

    state = state.copyWith(scannedPages: updatedPages);

    if (state.selectedPage?.id == pageId) {
      state = state.copyWith(selectedPage: updatedPage);
    }
  }

  void _updatePage(ScannedPage page) {
    final pageIndex = state.scannedPages.indexWhere((p) => p.id == page.id);
    if (pageIndex == -1) return;

    final updatedPages = List<ScannedPage>.from(state.scannedPages);
    updatedPages[pageIndex] = page;

    state = state.copyWith(scannedPages: updatedPages);

    if (state.selectedPage?.id == page.id) {
      state = state.copyWith(selectedPage: page);
    }
  }

  void _stopLiveDetection() {
    _detectionTimer?.cancel();
    _stabilityTimer?.cancel();
  }

  void _cleanup() {
    _detectionTimer?.cancel();
    _stabilityTimer?.cancel();
    _imageSubscription?.cancel();
    state.cameraController?.dispose();
  }
}

/// Compute functions for isolate processing

Future<DocumentQuadrilateral?> _detectDocumentEdges(Map<String, dynamic> params) {
  return DocumentEdgeDetector.detectDocumentEdges(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
  );
}

Future<CorrectedDocument> _correctPerspective(Map<String, dynamic> params) {
  return DocumentPerspectiveCorrector.correctPerspective(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
    params['quadrilateral'] as DocumentQuadrilateral,
  );
}

Future<Uint8List> _applyDocumentFilter(Map<String, dynamic> params) {
  return DocumentImageEnhancer.applyFilter(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
    params['filter'] as DocumentFilter,
  );
}

Future<OcrResult> _extractDocumentText(Map<String, dynamic> params) {
  return DocumentOcrProcessor.extractText(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
  );
}

/// Convert image bytes to RGB format
Future<Uint8List> _convertToRgb(Map<String, dynamic> params) async {
  final Uint8List imageBytes = params['imageBytes'];
  final int width = params['width'];
  final int height = params['height'];

  final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
  final ui.FrameInfo frame = await codec.getNextFrame();
  final ui.Image image = frame.image;

  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) throw Exception('Failed to convert image to RGB');

  final buffer = byteData.buffer.asUint8List();
  final rgbData = Uint8List(width * height * 3);

  // Convert RGBA to RGB
  for (int i = 0; i < width * height; i++) {
    rgbData[i * 3] = buffer[i * 4];         // R
    rgbData[i * 3 + 1] = buffer[i * 4 + 1]; // G
    rgbData[i * 3 + 2] = buffer[i * 4 + 2]; // B
    // Skip alpha channel
  }

  return rgbData;
}

/// Generate thumbnail from image data
Future<Uint8List> _generateThumbnail(Map<String, dynamic> params) async {
  // Implementation would resize image to thumbnail size
  // For now, return original data (placeholder)
  return params['imageData'] as Uint8List;
}

/// Generate regular PDF
Future<Uint8List> _generatePdf(Map<String, dynamic> params) async {
  // Implementation would create PDF from pages
  // Placeholder for now
  return Uint8List(0);
}

/// Generate searchable PDF with OCR
Future<Uint8List> _generateSearchablePdf(Map<String, dynamic> params) async {
  // Implementation would create searchable PDF
  // Placeholder for now
  return Uint8List(0);
}

/// Generate ZIP archive
Future<Uint8List> _generateZip(Map<String, dynamic> params) async {
  // Implementation would create ZIP from images
  // Placeholder for now
  return Uint8List(0);
}
