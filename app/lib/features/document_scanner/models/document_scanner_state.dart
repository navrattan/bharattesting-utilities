import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:bharattesting_core/core.dart' as core;

enum ScannerMode { camera, upload }
enum CameraPermissionStatus { unknown, granted, denied, permanentlyDenied, restricted }
enum DocumentFilter { original, auto, grayscale, blackAndWhite, magicColor, whiteboard }
enum PageStatus { pending, captured, processing, processed, error }

extension PageStatusX on PageStatus {
  String get displayName {
    switch (this) {
      case PageStatus.pending:
        return 'Pending';
      case PageStatus.captured:
        return 'Captured';
      case PageStatus.processing:
        return 'Processing';
      case PageStatus.processed:
        return 'Processed';
      case PageStatus.error:
        return 'Error';
    }
  }
}

enum ExportFormat { pdf, images, zip }

extension ExportFormatX on ExportFormat {
  String get fileExtension {
    switch (this) {
      case ExportFormat.pdf:
        return 'pdf';
      case ExportFormat.images:
        return 'jpg';
      case ExportFormat.zip:
        return 'zip';
    }
  }

  String get displayName {
    switch (this) {
      case ExportFormat.pdf:
        return 'PDF';
      case ExportFormat.images:
        return 'Images';
      case ExportFormat.zip:
        return 'ZIP Archive';
    }
  }
}

class DocumentScannerState {
  const DocumentScannerState({
    this.availableCameras = const [],
    this.cameraController,
    this.mode = ScannerMode.camera,
    this.permissionStatus = CameraPermissionStatus.unknown,
    this.isCameraInitialized = false,
    this.isCapturing = false,
    this.isProcessing = false,
    this.processingProgress = 0,
    this.processingErrors = const [],
    this.detectedDocument,
    this.isDocumentStable = false,
    this.stabilityScore = 0.0,
    this.lastDetectionTime,
    this.scannedPages = const [],
    this.selectedPage,
    this.selectedFilter = DocumentFilter.original,
    this.showFilterPreview = false,
    this.isAutoCapture = false,
    this.autoCaptureDuration = 2,
    this.cameraSettings = const CameraSettings(),
    this.exportConfig = const ExportConfig(),
    this.history = const [],
    this.currentSession,
    this.exportFormat = ExportFormat.pdf,
    this.exportFileName = '',
    this.exportData,
    this.enableFlash = false,
    this.zoomLevel = 1.0,
    this.includeOcr = true,
  });

  final List<CameraDescription> availableCameras;
  final CameraController? cameraController;
  final ScannerMode mode;
  final CameraPermissionStatus permissionStatus;
  final bool isCameraInitialized;
  final bool isCapturing;
  final bool isProcessing;
  final int processingProgress;
  final List<String> processingErrors;
  final core.DocumentQuadrilateral? detectedDocument;
  final bool isDocumentStable;
  final double stabilityScore;
  final DateTime? lastDetectionTime;
  final List<ScannedPage> scannedPages;
  final ScannedPage? selectedPage;
  final DocumentFilter selectedFilter;
  final bool showFilterPreview;
  final bool isAutoCapture;
  final int autoCaptureDuration;
  final CameraSettings cameraSettings;
  final ExportConfig exportConfig;
  final List<ScannerOperation> history;
  final BatchSession? currentSession;
  final ExportFormat exportFormat;
  final String exportFileName;
  final Uint8List? exportData;
  final bool enableFlash;
  final double zoomLevel;
  final bool includeOcr;

  DocumentScannerState copyWith({
    List<CameraDescription>? availableCameras,
    CameraController? cameraController,
    ScannerMode? mode,
    CameraPermissionStatus? permissionStatus,
    bool? isCameraInitialized,
    bool? isCapturing,
    bool? isProcessing,
    int? processingProgress,
    List<String>? processingErrors,
    core.DocumentQuadrilateral? detectedDocument,
    bool? isDocumentStable,
    double? stabilityScore,
    DateTime? lastDetectionTime,
    List<ScannedPage>? scannedPages,
    ScannedPage? selectedPage,
    DocumentFilter? selectedFilter,
    bool? showFilterPreview,
    bool? isAutoCapture,
    int? autoCaptureDuration,
    CameraSettings? cameraSettings,
    ExportConfig? exportConfig,
    List<ScannerOperation>? history,
    BatchSession? currentSession,
    ExportFormat? exportFormat,
    String? exportFileName,
    Uint8List? exportData,
    bool? enableFlash,
    double? zoomLevel,
    bool? includeOcr,
  }) {
    return DocumentScannerState(
      availableCameras: availableCameras ?? this.availableCameras,
      cameraController: cameraController ?? this.cameraController,
      mode: mode ?? this.mode,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isCapturing: isCapturing ?? this.isCapturing,
      isProcessing: isProcessing ?? this.isProcessing,
      processingProgress: processingProgress ?? this.processingProgress,
      processingErrors: processingErrors ?? this.processingErrors,
      detectedDocument: detectedDocument ?? this.detectedDocument,
      isDocumentStable: isDocumentStable ?? this.isDocumentStable,
      stabilityScore: stabilityScore ?? this.stabilityScore,
      lastDetectionTime: lastDetectionTime ?? this.lastDetectionTime,
      scannedPages: scannedPages ?? this.scannedPages,
      selectedPage: selectedPage ?? this.selectedPage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      showFilterPreview: showFilterPreview ?? this.showFilterPreview,
      isAutoCapture: isAutoCapture ?? this.isAutoCapture,
      autoCaptureDuration: autoCaptureDuration ?? this.autoCaptureDuration,
      cameraSettings: cameraSettings ?? this.cameraSettings,
      exportConfig: exportConfig ?? this.exportConfig,
      history: history ?? this.history,
      currentSession: currentSession ?? this.currentSession,
      exportFormat: exportFormat ?? this.exportFormat,
      exportFileName: exportFileName ?? this.exportFileName,
      exportData: exportData ?? this.exportData,
      enableFlash: enableFlash ?? this.enableFlash,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      includeOcr: includeOcr ?? this.includeOcr,
    );
  }
}

class ScannedPage {
  const ScannedPage({
    required this.id,
    required this.originalImageData,
    this.processedImageData,
    this.correctedImageData,
    this.filteredImageData,
    this.thumbnailData,
    required this.originalWidth,
    required this.originalHeight,
    required this.correctedWidth,
    required this.correctedHeight,
    required this.captureTime,
    this.appliedFilter = DocumentFilter.original,
    this.corners = const [],
    this.detectedCorners,
    this.ocrResult,
    this.isSelected = false,
    this.hasOcr = false,
    this.status = PageStatus.pending,
    this.error = '',
  });

  final String id;
  final Uint8List originalImageData;
  final Uint8List? processedImageData;
  final Uint8List? correctedImageData;
  final Uint8List? filteredImageData;
  final Uint8List? thumbnailData;
  final int originalWidth;
  final int originalHeight;
  final int correctedWidth;
  final int correctedHeight;
  final DateTime captureTime;
  final DocumentFilter appliedFilter;
  final List<Offset> corners;
  final core.DocumentQuadrilateral? detectedCorners;
  final String? ocrResult;
  final bool isSelected;
  final bool hasOcr;
  final PageStatus status;
  final String error;

  ScannedPage copyWith({
    String? id,
    Uint8List? originalImageData,
    Uint8List? processedImageData,
    Uint8List? correctedImageData,
    Uint8List? filteredImageData,
    Uint8List? thumbnailData,
    int? originalWidth,
    int? originalHeight,
    int? correctedWidth,
    int? correctedHeight,
    DateTime? captureTime,
    DocumentFilter? appliedFilter,
    List<Offset>? corners,
    core.DocumentQuadrilateral? detectedCorners,
    String? ocrResult,
    bool? isSelected,
    bool? hasOcr,
    PageStatus? status,
    String? error,
  }) {
    return ScannedPage(
      id: id ?? this.id,
      originalImageData: originalImageData ?? this.originalImageData,
      processedImageData: processedImageData ?? this.processedImageData,
      correctedImageData: correctedImageData ?? this.correctedImageData,
      filteredImageData: filteredImageData ?? this.filteredImageData,
      thumbnailData: thumbnailData ?? this.thumbnailData,
      originalWidth: originalWidth ?? this.originalWidth,
      originalHeight: originalHeight ?? this.originalHeight,
      correctedWidth: correctedWidth ?? this.correctedWidth,
      correctedHeight: correctedHeight ?? this.correctedHeight,
      captureTime: captureTime ?? this.captureTime,
      appliedFilter: appliedFilter ?? this.appliedFilter,
      corners: corners ?? this.corners,
      detectedCorners: detectedCorners ?? this.detectedCorners,
      ocrResult: ocrResult ?? this.ocrResult,
      isSelected: isSelected ?? this.isSelected,
      hasOcr: hasOcr ?? this.hasOcr,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  bool get isProcessed => status == PageStatus.processed;
  bool get hasOcrText => ocrResult != null && ocrResult!.isNotEmpty;
  int get imageWidth => originalWidth;
  int get imageHeight => originalHeight;

  Uint8List get bestImageData => filteredImageData ?? correctedImageData ?? originalImageData;
  (int, int) get bestImageDimensions => (correctedWidth, correctedHeight);
  String get fileSizeText => '${(bestImageData.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB';
}

class ScannerOperation {
  const ScannerOperation({
    required this.id,
    required this.message,
    required this.startTime,
    this.endTime,
    this.progress = 0.0,
    this.isCompleted = false,
    this.error,
  });

  final String id;
  final String message;
  final DateTime startTime;
  final DateTime? endTime;
  final double progress;
  final bool isCompleted;
  final String? error;

  ScannerOperation copyWith({
    String? id,
    String? message,
    DateTime? startTime,
    DateTime? endTime,
    double? progress,
    bool? isCompleted,
    String? error,
  }) {
    return ScannerOperation(
      id: id ?? this.id,
      message: message ?? this.message,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error ?? this.error,
    );
  }
}

class CameraSettings {
  const CameraSettings({
    this.flashMode = FlashMode.off,
    this.exposureMode = ExposureMode.auto,
    this.focusMode = FocusMode.auto,
    this.zoomLevel = 1.0,
    this.enableFlash = true,
    this.enableAudio = true,
    this.resolution = ResolutionPreset.high,
  });

  final FlashMode flashMode;
  final ExposureMode exposureMode;
  final FocusMode focusMode;
  final double zoomLevel;
  final bool enableFlash;
  final bool enableAudio;
  final ResolutionPreset resolution;

  CameraSettings copyWith({
    FlashMode? flashMode,
    ExposureMode? exposureMode,
    FocusMode? focusMode,
    double? zoomLevel,
    bool? enableFlash,
    bool? enableAudio,
    ResolutionPreset? resolution,
  }) {
    return CameraSettings(
      flashMode: flashMode ?? this.flashMode,
      exposureMode: exposureMode ?? this.exposureMode,
      focusMode: focusMode ?? this.focusMode,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      enableFlash: enableFlash ?? this.enableFlash,
      enableAudio: enableAudio ?? this.enableAudio,
      resolution: resolution ?? this.resolution,
    );
  }
}

class ExportConfig {
  const ExportConfig({
    this.fileName = 'scanned_document.pdf',
    this.format = 'pdf',
    this.imageQuality = 80,
    this.compressImages = true,
    this.includeOcrLayer = true,
  });

  final String fileName;
  final String format;
  final int imageQuality;
  final bool compressImages;
  final bool includeOcrLayer;

  ExportConfig copyWith({
    String? fileName,
    String? format,
    int? imageQuality,
    bool? compressImages,
    bool? includeOcrLayer,
  }) {
    return ExportConfig(
      fileName: fileName ?? this.fileName,
      format: format ?? this.format,
      imageQuality: imageQuality ?? this.imageQuality,
      compressImages: compressImages ?? this.compressImages,
      includeOcrLayer: includeOcrLayer ?? this.includeOcrLayer,
    );
  }
}

class BatchSession {
  const BatchSession({
    required this.id,
    required this.name,
    required this.startTime,
    this.endTime,
    this.pages = const [],
    this.isClosed = false,
  });

  final String id;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> pages;
  final bool isClosed;

  BatchSession copyWith({
    String? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? pages,
    bool? isClosed,
  }) {
    return BatchSession(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pages: pages ?? this.pages,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
