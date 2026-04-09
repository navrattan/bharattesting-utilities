import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/document_scanner_state.dart';

part 'document_scanner_provider.g.dart';

@riverpod
class DocumentScannerNotifier extends _$DocumentScannerNotifier {
  Timer? _detectionTimer;
  bool _isDetecting = false;

  @override
  DocumentScannerState build() {
    ref.onDispose(() {
      _detectionTimer?.cancel();
      state.cameraController?.dispose();
    });

    return const DocumentScannerState();
  }

  /// Initialize camera and start live detection
  Future<void> initialize() async {
    final status = await _checkCameraPermission();
    
    state = state.copyWith(
      permissionStatus: status,
      isCameraInitialized: false,
    );

    if (status != CameraPermissionStatus.granted) {
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();
      
      state = state.copyWith(
        cameraController: controller,
        isCameraInitialized: true,
        availableCameras: cameras,
      );

      _startLiveDetection();
    } catch (e) {
      state = state.copyWith(
        isCameraInitialized: false,
        processingErrors: [...state.processingErrors, 'Camera initialization failed: $e'],
      );
    }
  }

  /// Alias for initialize used by screen
  Future<void> initializeCamera() => initialize();

  /// Alias for setScannerMode used by screen
  void changeScannerMode(ScannerMode mode) => setScannerMode(mode);

  /// Check and request camera permission
  Future<CameraPermissionStatus> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) return CameraPermissionStatus.granted;
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted ? CameraPermissionStatus.granted : CameraPermissionStatus.denied;
    }
    if (status.isPermanentlyDenied) return CameraPermissionStatus.permanentlyDenied;
    if (status.isRestricted) return CameraPermissionStatus.restricted;
    
    return CameraPermissionStatus.unknown;
  }

  void _startLiveDetection() {
    _detectionTimer?.cancel();
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (_isDetecting || state.cameraController == null || !state.cameraController!.value.isInitialized) {
        return;
      }

      if (state.mode != ScannerMode.camera || state.scannedPages.length >= 20) {
        return;
      }

      _isDetecting = true;
      try {
        final image = await state.cameraController!.takePicture();
        final bytes = await image.readAsBytes();
        
        // Use isolate for edge detection
        final coreQuad = await compute(_detectDocumentEdges, {
          'imageData': bytes,
          'width': 1080,
          'height': 1920,
        });

        if (coreQuad != null) {
          state = state.copyWith(detectedDocument: coreQuad);
          
          if (state.isAutoCapture) {
            await captureDocument();
          }
        } else {
          state = state.copyWith(detectedDocument: null);
        }
      } catch (_) {
        // Ignore detection errors in live preview
      } finally {
        _isDetecting = false;
      }
    });
  }

  /// Toggle auto-capture
  void toggleAutoCapture() {
    state = state.copyWith(isAutoCapture: !state.isAutoCapture);
  }

  /// Toggle flash
  Future<void> toggleFlash() async {
    if (state.cameraController == null) return;
    
    final newMode = state.enableFlash ? FlashMode.off : FlashMode.torch;
    await state.cameraController!.setFlashMode(newMode);
    state = state.copyWith(enableFlash: !state.enableFlash);
  }

  /// Change scanner mode
  void setScannerMode(ScannerMode mode) {
    state = state.copyWith(mode: mode);
    if (mode == ScannerMode.camera) {
      _startLiveDetection();
    } else {
      _detectionTimer?.cancel();
    }
  }

  /// Set zoom level
  Future<void> setZoomLevel(double zoom) async {
    if (state.cameraController == null) return;
    await state.cameraController!.setZoomLevel(zoom);
    state = state.copyWith(zoomLevel: zoom);
  }

  /// Pick images from gallery
  Future<void> uploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result != null) {
        for (final file in result.files) {
          if (file.bytes != null) {
            final page = ScannedPage(
              id: DateTime.now().millisecondsSinceEpoch.toString() + file.name,
              originalImageData: file.bytes!,
              originalWidth: 1080, // Approximate
              originalHeight: 1920,
              correctedWidth: 1080,
              correctedHeight: 1920,
              captureTime: DateTime.now(),
              status: PageStatus.captured,
            );
            state = state.copyWith(scannedPages: [...state.scannedPages, page]);
            _processPage(page);
          }
        }
      }
    } catch (e) {
      _addError('Upload failed: $e');
    }
  }

  /// Manually capture document
  Future<void> captureDocument() async {
    if (state.cameraController == null || state.isCapturing) return;

    try {
      state = state.copyWith(isCapturing: true);
      
      final image = await state.cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      
      final page = ScannedPage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalImageData: bytes,
        originalWidth: 1080,
        originalHeight: 1920,
        correctedWidth: 1080,
        correctedHeight: 1920,
        captureTime: DateTime.now(),
        status: PageStatus.captured,
      );

      state = state.copyWith(
        scannedPages: [...state.scannedPages, page],
        isCapturing: false,
      );

      _processPage(page);

    } catch (e) {
      state = state.copyWith(
        isCapturing: false,
        processingErrors: [...state.processingErrors, 'Capture failed: $e'],
      );
    }
  }

  Future<void> _processPage(ScannedPage page) async {
    try {
      _updatePageStatus(page.id, PageStatus.processing);

      final coreQuad = state.detectedDocument ?? core.DocumentQuadrilateral([
        const core.Point(0, 0),
        const core.Point(1080, 0),
        const core.Point(1080, 1920),
        const core.Point(0, 1920),
      ]);

      final correctedDoc = await compute(_correctPerspective, {
        'imageData': page.originalImageData,
        'width': page.originalWidth,
        'height': page.originalHeight,
        'quadrilateral': coreQuad,
      });

      final enhancedBytes = await compute(_applyFilter, {
        'imageData': correctedDoc.imageData,
        'width': correctedDoc.width,
        'height': correctedDoc.height,
        'filter': core.DocumentFilter.autoColor,
      });

      _updatePage(page.id, page.copyWith(
        processedImageData: enhancedBytes,
        correctedWidth: correctedDoc.width,
        correctedHeight: correctedDoc.height,
        status: PageStatus.processed,
      ));

    } catch (e) {
      _updatePageStatus(page.id, PageStatus.error);
      _addError('Processing failed for page: $e');
    }
  }

  /// Update page filter
  Future<void> updatePageFilter(String pageId, DocumentFilter filter) async {
    final pageIndex = state.scannedPages.indexWhere((p) => p.id == pageId);
    if (pageIndex == -1) return;
    
    final page = state.scannedPages[pageIndex];
    
    try {
      _updatePageStatus(pageId, PageStatus.processing);

      // Map app DocumentFilter to core DocumentFilter
      final coreFilter = _mapAppToCoreFilter(filter);

      final filteredBytes = await compute(_applyFilter, {
        'imageData': page.originalImageData,
        'width': page.originalWidth,
        'height': page.originalHeight,
        'filter': coreFilter,
      });

      _updatePage(page.id, page.copyWith(
        processedImageData: filteredBytes,
        status: PageStatus.processed,
      ));
    } catch (e) {
      _updatePageStatus(pageId, PageStatus.error);
      _addError('Filter application failed: $e');
    }
  }

  /// Remove a page
  void removePage(String pageId) {
    state = state.copyWith(
      scannedPages: state.scannedPages.where((p) => p.id != pageId).toList(),
    );
  }

  /// Alias for removePage used by screen
  void deletePage(String pageId) => removePage(pageId);

  /// Reorder pages
  void reorderPages(int oldIndex, int newIndex) {
    final pages = List<ScannedPage>.from(state.scannedPages);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = pages.removeAt(oldIndex);
    pages.insert(newIndex, item);
    state = state.copyWith(scannedPages: pages);
  }

  /// Select a page
  void selectPage(ScannedPage? page) {
    state = state.copyWith(selectedPage: page);
  }

  /// Clear all pages
  void clearAll() {
    state = state.copyWith(scannedPages: [], detectedDocument: null);
  }

  /// Perform OCR on current page
  Future<void> performOcr(String pageId) async {
    final pageIndex = state.scannedPages.indexWhere((p) => p.id == pageId);
    if (pageIndex == -1) return;
    
    final page = state.scannedPages[pageIndex];
    if (page.processedImageData == null) return;

    state = state.copyWith(isCapturing: true);

    try {
      final result = await compute(_performOcr, {
        'imageData': page.processedImageData!,
        'width': page.correctedWidth,
        'height': page.correctedHeight,
      });

      _updatePage(page.id, page.copyWith(
        ocrResult: result.fullText,
        hasOcr: true,
      ));
    } catch (e) {
      _addError('OCR failed: $e');
    } finally {
      state = state.copyWith(isCapturing: false);
    }
  }

  /// Generate final PDF
  Future<void> exportPdf() async {
    if (state.scannedPages.isEmpty) return;

    state = state.copyWith(isProcessing: true);

    try {
      final pdfBytes = await compute(_generatePdf, {
        'pages': state.scannedPages.map((p) => p.processedImageData ?? p.originalImageData).toList(),
      });

      state = state.copyWith(
        isProcessing: false,
        exportData: pdfBytes,
      );
    } catch (e) {
      _addError('PDF export failed: $e');
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  /// Alias for exportPdf used by screen
  Future<void> exportDocuments() => exportPdf();

  // Helper methods
  void _updatePage(String id, ScannedPage newPage) {
    state = state.copyWith(
      scannedPages: state.scannedPages.map((p) => p.id == id ? newPage : p).toList(),
    );
  }

  void _updatePageStatus(String id, PageStatus status) {
    final pageIndex = state.scannedPages.indexWhere((p) => p.id == id);
    if (pageIndex != -1) {
      final page = state.scannedPages[pageIndex];
      _updatePage(id, page.copyWith(status: status));
    }
  }

  void _addError(String message) {
    state = state.copyWith(processingErrors: [...state.processingErrors, message]);
  }

  core.DocumentFilter _mapAppToCoreFilter(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original: return core.DocumentFilter.original;
      case DocumentFilter.auto: return core.DocumentFilter.autoColor;
      case DocumentFilter.grayscale: return core.DocumentFilter.grayscale;
      case DocumentFilter.blackAndWhite: return core.DocumentFilter.blackAndWhite;
      case DocumentFilter.magicColor: return core.DocumentFilter.magicColor;
      case DocumentFilter.whiteboard: return core.DocumentFilter.whiteboard;
    }
    return core.DocumentFilter.original;
  }
}

// Isolate functions for heavy processing

Future<core.DocumentQuadrilateral?> _detectDocumentEdges(Map<String, dynamic> params) {
  return core.DocumentEdgeDetector.detectDocumentEdges(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
  );
}

Future<core.CorrectedDocument> _correctPerspective(Map<String, dynamic> params) {
  return core.DocumentPerspectiveCorrector.correctPerspective(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
    params['quadrilateral'] as core.DocumentQuadrilateral,
  );
}

Future<Uint8List> _applyFilter(Map<String, dynamic> params) {
  return core.DocumentImageEnhancer.applyFilter(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
    params['filter'] as core.DocumentFilter,
  );
}

Future<core.OcrResult> _performOcr(Map<String, dynamic> params) {
  return core.DocumentOcrProcessor.extractText(
    params['imageData'] as Uint8List,
    params['width'] as int,
    params['height'] as int,
  );
}

Future<Uint8List> _generatePdf(Map<String, dynamic> params) async {
  // Real implementation using PdfMerger would go here
  return Uint8List(0);
}
