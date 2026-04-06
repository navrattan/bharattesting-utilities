import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bharattesting_core/core.dart';

part 'pdf_merger_state.freezed.dart';

@freezed
class PdfMergerState with _$PdfMergerState {
  const factory PdfMergerState({
    @Default([]) List<PdfDocument> documents,
    @Default([]) List<PdfPageThumbnail> pages,
    @Default(false) bool isProcessing,
    @Default(0) int processingProgress,
    @Default([]) List<String> processingErrors,
    PdfDocument? selectedDocument,
    PdfPageThumbnail? selectedPage,
    @Default(false) bool showPasswordDialog,
    @Default(false) bool showAdvancedSettings,
    @Default(false) bool enableEncryption,
    @Default('') String encryptionPassword,
    @Default(PdfPermissions()) PdfPermissions permissions,
    @Default(PdfMergeOptions()) PdfMergeOptions mergeOptions,
    Uint8List? mergedPdfData,
    @Default('') String outputFileName,
  }) = _PdfMergerState;
}

/// Represents a PDF document in the merger
@freezed
class PdfDocument with _$PdfDocument {
  const factory PdfDocument({
    required String id,
    required String fileName,
    required Uint8List data,
    required int fileSize,
    required int pageCount,
    @Default([]) List<PdfPageThumbnail> pages,
    @Default(DocumentStatus.loaded) DocumentStatus status,
    @Default('') String error,
    String? password,
    @Default(false) bool isEncrypted,
    DateTime? lastModified,
    Map<String, dynamic>? metadata,
  }) = _PdfDocument;

  const PdfDocument._();

  /// Human-readable file size
  String get fileSizeText {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Display name without extension
  String get displayName {
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot > 0) {
      return fileName.substring(0, lastDot);
    }
    return fileName;
  }

  /// Check if document is ready for merging
  bool get isReady => status == DocumentStatus.loaded && error.isEmpty;

  /// Pages count text
  String get pageCountText {
    if (pageCount == 1) return '1 page';
    return '$pageCount pages';
  }
}

/// Represents a PDF page thumbnail for UI display
@freezed
class PdfPageThumbnail with _$PdfPageThumbnail {
  const factory PdfPageThumbnail({
    required String id,
    required String documentId,
    required int pageNumber,
    required int globalIndex, // Index in merged document
    required PageDimensions dimensions,
    @Default(PageRotation.none) PageRotation rotation,
    Uint8List? thumbnailData,
    @Default(false) bool isSelected,
    @Default(false) bool isDuplicate,
    @Default(false) bool isBlank,
    @Default(ThumbnailStatus.loading) ThumbnailStatus status,
  }) = _PdfPageThumbnail;

  const PdfPageThumbnail._();

  /// Page orientation
  PageOrientation get orientation {
    final rotatedDims = _getRotatedDimensions();
    if (rotatedDims.width > rotatedDims.height) {
      return PageOrientation.landscape;
    } else if (rotatedDims.width < rotatedDims.height) {
      return PageOrientation.portrait;
    }
    return PageOrientation.square;
  }

  /// Get dimensions after rotation
  PageDimensions _getRotatedDimensions() {
    if (rotation == PageRotation.rotate90 || rotation == PageRotation.rotate270) {
      return PageDimensions(width: dimensions.height, height: dimensions.width);
    }
    return dimensions;
  }

  /// Display page number (1-based)
  String get displayPageNumber => (pageNumber + 1).toString();

  /// Display global position
  String get displayGlobalNumber => (globalIndex + 1).toString();

  /// Check if thumbnail is ready to display
  bool get isReady => status == ThumbnailStatus.ready && thumbnailData != null;
}

/// Document processing status
enum DocumentStatus {
  loading,
  loaded,
  processing,
  error,
}

/// Thumbnail generation status
enum ThumbnailStatus {
  loading,
  ready,
  error,
}

/// PDF merger operation state
@freezed
class PdfMergerOperation with _$PdfMergerOperation {
  const factory PdfMergerOperation({
    required String id,
    @Default(OperationStatus.pending) OperationStatus status,
    @Default(0) int progress,
    @Default('') String message,
    @Default('') String error,
    DateTime? startTime,
    DateTime? endTime,
    Map<String, dynamic>? result,
  }) = _PdfMergerOperation;

  const PdfMergerOperation._();

  /// Operation duration
  Duration? get duration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  /// Check if operation is in progress
  bool get isInProgress => status == OperationStatus.processing;

  /// Check if operation completed successfully
  bool get isCompleted => status == OperationStatus.completed;

  /// Check if operation failed
  bool get hasFailed => status == OperationStatus.error;
}

/// Operation status enum
enum OperationStatus {
  pending,
  processing,
  completed,
  error,
  cancelled,
}

/// Merge statistics for UI display
@freezed
class MergeStatistics with _$MergeStatistics {
  const factory MergeStatistics({
    @Default(0) int totalDocuments,
    @Default(0) int totalPages,
    @Default(0) int totalSize,
    @Default(0) int estimatedOutputSize,
    @Default(0.0) double compressionRatio,
    @Default(Duration.zero) Duration estimatedTime,
    Map<String, int>? pageSizeDistribution,
    Map<PageOrientation, int>? orientationCounts,
  }) = _MergeStatistics;

  const MergeStatistics._();

  /// Human-readable total size
  String get totalSizeText {
    if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Human-readable estimated output size
  String get outputSizeText {
    if (estimatedOutputSize < 1024 * 1024) {
      return '${(estimatedOutputSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(estimatedOutputSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Compression percentage
  String get compressionText {
    if (totalSize > 0) {
      final percentage = ((totalSize - estimatedOutputSize) / totalSize * 100);
      return '${percentage.toStringAsFixed(1)}%';
    }
    return '0%';
  }

  /// Estimated time text
  String get estimatedTimeText {
    if (estimatedTime.inSeconds < 60) {
      return '${estimatedTime.inSeconds}s';
    }
    final minutes = estimatedTime.inMinutes;
    final seconds = estimatedTime.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}

/// Page reorder operation for drag-and-drop
@freezed
class PageReorderOperation with _$PageReorderOperation {
  const factory PageReorderOperation({
    required String pageId,
    required int fromIndex,
    required int toIndex,
    @Default(false) bool isActive,
    @Default(false) bool isValid,
  }) = _PageReorderOperation;
}

/// Batch operation for multiple pages
@freezed
class BatchPageOperation with _$BatchPageOperation {
  const factory BatchPageOperation({
    required BatchOperationType type,
    required List<String> pageIds,
    @Default(false) bool isProcessing,
    @Default(0) int progress,
    Map<String, dynamic>? parameters,
  }) = _BatchPageOperation;
}

/// Type of batch operations
enum BatchOperationType {
  rotate,
  delete,
  duplicate,
  extract,
}

extension DocumentStatusExtension on DocumentStatus {
  String get displayName {
    switch (this) {
      case DocumentStatus.loading:
        return 'Loading...';
      case DocumentStatus.loaded:
        return 'Ready';
      case DocumentStatus.processing:
        return 'Processing...';
      case DocumentStatus.error:
        return 'Error';
    }
  }

  bool get isLoading => this == DocumentStatus.loading;
  bool get isLoaded => this == DocumentStatus.loaded;
  bool get isProcessing => this == DocumentStatus.processing;
  bool get hasError => this == DocumentStatus.error;
}

extension ThumbnailStatusExtension on ThumbnailStatus {
  String get displayName {
    switch (this) {
      case ThumbnailStatus.loading:
        return 'Loading...';
      case ThumbnailStatus.ready:
        return 'Ready';
      case ThumbnailStatus.error:
        return 'Error';
    }
  }

  bool get isLoading => this == ThumbnailStatus.loading;
  bool get isReady => this == ThumbnailStatus.ready;
  bool get hasError => this == ThumbnailStatus.error;
}