import 'dart:typed_data';
import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';
import 'package:bharattesting_core/core.dart' as core;

part 'document_scanner_state.freezed.dart';

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

@freezed
abstract class DocumentScannerState with _$DocumentScannerState {
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
    core.DocumentQuadrilateral? detectedDocument,
    @Default(false) bool isDocumentStable,
    @Default(0.0) double stabilityScore,
    DateTime? lastDetectionTime,
    @Default([]) List<ScannedPage> scannedPages,
    ScannedPage? selectedPage,
    @Default(DocumentFilter.original) DocumentFilter selectedFilter,
    @Default(false) bool showFilterPreview,
    @Default(false) bool isAutoCapture,
    @Default(2) int autoCaptureDuration, // seconds
    @Default(CameraSettings()) CameraSettings cameraSettings,
    @Default(ExportConfig()) ExportConfig exportConfig,
    @Default([]) List<ScannerOperation> history,
    @Default(null) BatchSession? currentSession,
    @Default(ExportFormat.pdf) ExportFormat exportFormat,
    @Default('') String exportFileName,
    Uint8List? exportData,
    @Default(false) bool enableFlash,
    @Default(1.0) double zoomLevel,
    @Default(true) bool includeOcr,
  }) = _DocumentScannerState;
}

@freezed
abstract class ScannedPage with _$ScannedPage {
  const factory ScannedPage({
    required String id,
    required Uint8List originalImageData,
    Uint8List? processedImageData,
    Uint8List? correctedImageData,
    Uint8List? filteredImageData,
    Uint8List? thumbnailData,
    required int originalWidth,
    required int originalHeight,
    required int correctedWidth,
    required int correctedHeight,
    required DateTime captureTime,
    @Default(DocumentFilter.original) DocumentFilter appliedFilter,
    @Default([]) List<Offset> corners,
    core.DocumentQuadrilateral? detectedCorners,
    String? ocrResult,
    @Default(false) bool isSelected,
    @Default(false) bool hasOcr,
    @Default(PageStatus.pending) PageStatus status,
    @Default('') String error,
  }) = _ScannedPage;

  const ScannedPage._();

  bool get isProcessed => status == PageStatus.processed;
  bool get hasOcrText => ocrResult != null && ocrResult!.isNotEmpty;
  int get imageWidth => originalWidth;
  int get imageHeight => originalHeight;

  Uint8List get bestImageData => filteredImageData ?? correctedImageData ?? originalImageData;
  (int, int) get bestImageDimensions => (correctedWidth, correctedHeight);
  String get fileSizeText => '${(bestImageData.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB';
}

@freezed
abstract class ScannerOperation with _$ScannerOperation {
  const factory ScannerOperation({
    required String id,
    required String message,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0.0) double progress,
    @Default(false) bool isCompleted,
    String? error,
  }) = _ScannerOperation;
}

@freezed
abstract class CameraSettings with _$CameraSettings {
  const factory CameraSettings({
    @Default(FlashMode.off) FlashMode flashMode,
    @Default(ExposureMode.auto) ExposureMode exposureMode,
    @Default(FocusMode.auto) FocusMode focusMode,
    @Default(1.0) double zoomLevel,
    @Default(true) bool enableFlash,
    @Default(true) bool enableAudio,
    @Default(ResolutionPreset.high) ResolutionPreset resolution,
  }) = _CameraSettings;
}

@freezed
abstract class ExportConfig with _$ExportConfig {
  const factory ExportConfig({
    @Default('scanned_document.pdf') String fileName,
    @Default('pdf') String format,
    @Default(80) int imageQuality,
    @Default(true) bool compressImages,
    @Default(true) bool includeOcrLayer,
  }) = _ExportConfig;
}

@freezed
abstract class BatchSession with _$BatchSession {
  const factory BatchSession({
    required String id,
    required String name,
    required DateTime startTime,
    DateTime? endTime,
    @Default([]) List<String> pages,
    @Default(false) bool isClosed,
  }) = _BatchSession;
}
