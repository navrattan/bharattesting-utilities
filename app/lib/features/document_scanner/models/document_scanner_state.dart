import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';
import 'package:bharattesting_core/core.dart';

part 'document_scanner_state.freezed.dart';

@freezed
class DocumentScannerState with _$DocumentScannerState {
  const factory DocumentScannerState({
    @Default([]) List<CameraDescription> availableCameras,
    CameraController? cameraController,
    @Default(ScannerMode.camera) ScannerMode mode,
    @Default(CameraPermissionStatus.unknown) CameraPermissionStatus permissionStatus,
    @Default(false) bool isCameraInitialized,
    @Default(false) bool isCapturing,
    @Default(false) bool isProcessing,
    @Default(0) int processingProgress,
    @Default([]) List<String> processingErrors,
    DocumentQuadrilateral? detectedDocument,
    @Default(false) bool isDocumentStable,
    @Default(0.0) double stabilityScore,
    @Default(DateTime.now()) DateTime lastDetectionTime,
    @Default([]) List<ScannedPage> scannedPages,
    ScannedPage? selectedPage,
    @Default(DocumentFilter.original) DocumentFilter selectedFilter,
    @Default(false) bool showFilterPreview,
    @Default(false) bool isAutoCapture,
    @Default(1.5) double autoCaptureDuration,
    @Default(false) bool showCropOverlay,
    @Default(false) bool enableFlash,
    @Default(0.0) double zoomLevel,
    @Default(ExportFormat.pdf) ExportFormat exportFormat,
    @Default(false) bool includeOcr,
    Uint8List? exportData,
    @Default('') String exportFileName,
    @Default(false) bool showPageThumbnails,
    @Default(false) bool showAdvancedSettings,
  }) = _DocumentScannerState;
}

/// Represents a scanned page
@freezed
class ScannedPage with _$ScannedPage {
  const factory ScannedPage({
    required String id,
    required Uint8List originalImageData,
    required int imageWidth,
    required int imageHeight,
    required DocumentQuadrilateral detectedCorners,
    Uint8List? correctedImageData,
    int? correctedWidth,
    int? correctedHeight,
    @Default(DocumentFilter.original) DocumentFilter appliedFilter,
    Uint8List? filteredImageData,
    OcrResult? ocrResult,
    @Default(PageStatus.captured) PageStatus status,
    @Default('') String error,
    @Default(DateTime.now()) DateTime captureTime,
    Uint8List? thumbnailData,
    @Default(false) bool isSelected,
    Map<String, dynamic>? metadata,
  }) = _ScannedPage;

  const ScannedPage._();

  /// Display name for the page
  String get displayName => 'Page ${captureTime.millisecondsSinceEpoch}';

  /// File size of original image
  int get originalFileSize => originalImageData.length;

  /// File size of processed image
  int get processedFileSize {
    if (filteredImageData != null) return filteredImageData!.length;
    if (correctedImageData != null) return correctedImageData!.length;
    return originalFileSize;
  }

  /// Formatted file size
  String get fileSizeText {
    if (processedFileSize < 1024 * 1024) {
      return '${(processedFileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(processedFileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Check if page has been processed
  bool get isProcessed => correctedImageData != null;

  /// Check if page has OCR data
  bool get hasOcrText => ocrResult != null && ocrResult!.fullText.isNotEmpty;

  /// Get the best available image data
  Uint8List get bestImageData {
    if (filteredImageData != null) return filteredImageData!;
    if (correctedImageData != null) return correctedImageData!;
    return originalImageData;
  }

  /// Get the dimensions of the best image
  (int, int) get bestImageDimensions {
    if (filteredImageData != null && correctedWidth != null) {
      return (correctedWidth!, correctedHeight!);
    }
    if (correctedImageData != null && correctedWidth != null) {
      return (correctedWidth!, correctedHeight!);
    }
    return (imageWidth, imageHeight);
  }
}

/// Scanner operation modes
enum ScannerMode {
  camera,
  upload,
  batch,
}

/// Camera permission status
enum CameraPermissionStatus {
  unknown,
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

/// Page processing status
enum PageStatus {
  captured,
  processing,
  processed,
  error,
}

/// Export formats
enum ExportFormat {
  pdf,
  images,
  zip,
}

/// Scanner operation for state management
@freezed
class ScannerOperation with _$ScannerOperation {
  const factory ScannerOperation({
    required String id,
    required OperationType type,
    @Default(OperationState.pending) OperationState state,
    @Default(0) int progress,
    @Default('') String message,
    @Default('') String error,
    DateTime? startTime,
    DateTime? endTime,
    Map<String, dynamic>? result,
  }) = _ScannerOperation;

  const ScannerOperation._();

  /// Operation duration
  Duration? get duration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  /// Check if operation is active
  bool get isActive => state == OperationState.processing;
}

/// Types of scanner operations
enum OperationType {
  capture,
  process,
  filter,
  export,
  ocr,
}

/// Operation states
enum OperationState {
  pending,
  processing,
  completed,
  error,
  cancelled,
}

/// Document detection metrics for UI feedback
@freezed
class DetectionMetrics with _$DetectionMetrics {
  const factory DetectionMetrics({
    @Default(0.0) double confidence,
    @Default(0.0) double stability,
    @Default(false) bool hasQuadrilateral,
    @Default(0.0) double area,
    @Default(0.0) double aspectRatio,
    @Default([]) List<Point> corners,
    @Default(Duration.zero) Duration timeSinceDetection,
  }) = _DetectionMetrics;

  const DetectionMetrics._();

  /// Check if detection is good enough for capture
  bool get isGoodForCapture => confidence > 0.7 && stability > 0.8 && hasQuadrilateral;

  /// Check if document is ready for auto-capture
  bool get isReadyForAutoCapture => isGoodForCapture && timeSinceDetection.inMilliseconds > 1500;
}

/// Camera configuration settings
@freezed
class CameraSettings with _$CameraSettings {
  const factory CameraSettings({
    @Default(ResolutionPreset.high) ResolutionPreset resolution,
    @Default(false) bool enableFlash,
    @Default(FlashMode.off) FlashMode flashMode,
    @Default(0.0) double zoomLevel,
    @Default(FocusMode.auto) FocusMode focusMode,
    @Default(ExposureMode.auto) ExposureMode exposureMode,
    @Default(false) bool enableAudio,
    @Default(30.0) double frameRate,
  }) = _CameraSettings;
}

/// Export configuration
@freezed
class ExportConfig with _$ExportConfig {
  const factory ExportConfig({
    @Default(ExportFormat.pdf) ExportFormat format,
    @Default(true) bool includeOcr,
    @Default('BharatTesting Scan') String fileName,
    @Default(PdfGenerationOptions()) PdfGenerationOptions pdfOptions,
    @Default(false) bool compressImages,
    @Default(80) int imageQuality,
  }) = _ExportConfig;
}

/// Batch scanning session
@freezed
class BatchSession with _$BatchSession {
  const factory BatchSession({
    required String id,
    @Default([]) List<ScannedPage> pages,
    @Default(DateTime.now()) DateTime startTime,
    DateTime? endTime,
    @Default('') String name,
    @Default(BatchStatus.active) BatchStatus status,
  }) = _BatchSession;

  const BatchSession._();

  /// Session duration
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Number of pages in session
  int get pageCount => pages.length;

  /// Total size of all pages
  int get totalSize => pages.fold(0, (sum, page) => sum + page.processedFileSize);

  /// Formatted total size
  String get totalSizeText {
    if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Batch session status
enum BatchStatus {
  active,
  completed,
  cancelled,
}

/// Extensions for enum display names
extension ScannerModeExtension on ScannerMode {
  String get displayName {
    switch (this) {
      case ScannerMode.camera:
        return 'Camera';
      case ScannerMode.upload:
        return 'Upload';
      case ScannerMode.batch:
        return 'Batch';
    }
  }

  String get description {
    switch (this) {
      case ScannerMode.camera:
        return 'Scan documents using camera';
      case ScannerMode.upload:
        return 'Upload images to scan';
      case ScannerMode.batch:
        return 'Scan multiple documents';
    }
  }
}

extension CameraPermissionStatusExtension on CameraPermissionStatus {
  String get displayName {
    switch (this) {
      case CameraPermissionStatus.unknown:
        return 'Unknown';
      case CameraPermissionStatus.granted:
        return 'Granted';
      case CameraPermissionStatus.denied:
        return 'Denied';
      case CameraPermissionStatus.restricted:
        return 'Restricted';
      case CameraPermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
    }
  }

  bool get isGranted => this == CameraPermissionStatus.granted;
  bool get isDenied => this == CameraPermissionStatus.denied ||
                       this == CameraPermissionStatus.permanentlyDenied;
}

extension ExportFormatExtension on ExportFormat {
  String get displayName {
    switch (this) {
      case ExportFormat.pdf:
        return 'PDF Document';
      case ExportFormat.images:
        return 'Individual Images';
      case ExportFormat.zip:
        return 'ZIP Archive';
    }
  }

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
}

extension PageStatusExtension on PageStatus {
  String get displayName {
    switch (this) {
      case PageStatus.captured:
        return 'Captured';
      case PageStatus.processing:
        return 'Processing...';
      case PageStatus.processed:
        return 'Processed';
      case PageStatus.error:
        return 'Error';
    }
  }

  bool get isProcessing => this == PageStatus.processing;
  bool get isProcessed => this == PageStatus.processed;
  bool get hasError => this == PageStatus.error;
}