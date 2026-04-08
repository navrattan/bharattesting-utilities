import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_merger_state.freezed.dart';

class PdfPermissions {
  const PdfPermissions({
    this.allowPrinting = true,
    this.allowCopy = true,
    this.allowModification = true,
    this.allowAnnotations = true,
  });

  final bool allowPrinting;
  final bool allowCopy;
  final bool allowModification;
  final bool allowAnnotations;

  PdfPermissions copyWith({
    bool? allowPrinting,
    bool? allowCopy,
    bool? allowModification,
    bool? allowAnnotations,
  }) {
    return PdfPermissions(
      allowPrinting: allowPrinting ?? this.allowPrinting,
      allowCopy: allowCopy ?? this.allowCopy,
      allowModification: allowModification ?? this.allowModification,
      allowAnnotations: allowAnnotations ?? this.allowAnnotations,
    );
  }
}

class PdfMergeOptions {
  const PdfMergeOptions({
    this.generateBookmarks = true,
    this.preserveMetadata = true,
    this.optimizeForSize = false,
    this.encryptOutput = false,
    this.ownerPassword = '',
    this.userPassword = '',
  });

  final bool generateBookmarks;
  final bool preserveMetadata;
  final bool optimizeForSize;
  final bool encryptOutput;
  final String ownerPassword;
  final String userPassword;

  PdfMergeOptions copyWith({
    bool? generateBookmarks,
    bool? preserveMetadata,
    bool? optimizeForSize,
    bool? encryptOutput,
    String? ownerPassword,
    String? userPassword,
  }) {
    return PdfMergeOptions(
      generateBookmarks: generateBookmarks ?? this.generateBookmarks,
      preserveMetadata: preserveMetadata ?? this.preserveMetadata,
      optimizeForSize: optimizeForSize ?? this.optimizeForSize,
      encryptOutput: encryptOutput ?? this.encryptOutput,
      ownerPassword: ownerPassword ?? this.ownerPassword,
      userPassword: userPassword ?? this.userPassword,
    );
  }
}

enum PageRotation {
  none(0),
  rotate90(90),
  rotate180(180),
  rotate270(270);

  const PageRotation(this.degrees);
  final int degrees;

  static PageRotation fromDegrees(int degrees) {
    switch (degrees % 360) {
      case 90:
        return PageRotation.rotate90;
      case 180:
        return PageRotation.rotate180;
      case 270:
        return PageRotation.rotate270;
      default:
        return PageRotation.none;
    }
  }
}

class PageDimensions {
  const PageDimensions({required this.width, required this.height});
  final double width;
  final double height;

  factory PageDimensions.a4() => const PageDimensions(width: 595, height: 842);

  double get aspectRatio => height > 0 ? width / height : 1.0;
}

enum PageOrientation {
  portrait,
  landscape,
  square,
}

@freezed
abstract class PdfMergerState with _$PdfMergerState {
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
    @Default('merged_document.pdf') String outputFileName,
  }) = _PdfMergerState;
}

@freezed
abstract class PdfDocument with _$PdfDocument {
  const factory PdfDocument({
    required String id,
    required String fileName,
    required Uint8List data,
    required int fileSize,
    required int pageCount,
    @Default(DocumentStatus.ready) DocumentStatus status,
    String? error,
  }) = _PdfDocument;

  const PdfDocument._();

  String get displayName => fileName;
  String get fileSizeText => '${(fileSize / 1024).toStringAsFixed(1)} KB';
  String get pageCountText => '$pageCount page${pageCount == 1 ? '' : 's'}';
}

enum DocumentStatus { loading, ready, error }

@freezed
abstract class PdfPageThumbnail with _$PdfPageThumbnail {
  const factory PdfPageThumbnail({
    required String id,
    required String documentId,
    required int pageNumber,
    required int globalIndex,
    required PageDimensions dimensions,
    @Default(PageRotation.none) PageRotation rotation,
    Uint8List? thumbnailData,
    @Default(false) bool isSelected,
    @Default(false) bool isDuplicate,
    @Default(false) bool isBlank,
    @Default(ThumbnailStatus.loading) ThumbnailStatus status,
  }) = _PdfPageThumbnail;

  const PdfPageThumbnail._();

  int get displayGlobalNumber => globalIndex + 1;
  bool get isReady => status == ThumbnailStatus.ready;
}

enum ThumbnailStatus { loading, ready, error }

@freezed
abstract class PdfMergerOperation with _$PdfMergerOperation {
  const factory PdfMergerOperation({
    required String id,
    required String message,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0.0) double progress,
    @Default(false) bool isCompleted,
    String? error,
  }) = _PdfMergerOperation;
}

@freezed
abstract class MergeStatistics with _$MergeStatistics {
  const factory MergeStatistics({
    required int totalDocuments,
    required int totalPages,
    required int totalSize,
    required int estimatedOutputSize,
    @Default(0.0) double compressionRatio,
    @Default(Duration.zero) Duration estimatedTime,
    @Default({}) Map<String, int> orientationCounts,
    @Default(0) int duplicateCount,
  }) = _MergeStatistics;

  const MergeStatistics._();

  String get totalSizeText => '${(totalSize / 1024 / 1024).toStringAsFixed(2)} MB';
  String get outputSizeText => '${(estimatedOutputSize / 1024 / 1024).toStringAsFixed(2)} MB';
  String get compressionText => '${(compressionRatio * 100).toStringAsFixed(0)}%';
  String get estimatedTimeText => '${estimatedTime.inSeconds}s';
}

@freezed
abstract class PageReorderOperation with _$PageReorderOperation {
  const factory PageReorderOperation({
    required String pageId,
    required int fromIndex,
    required int toIndex,
    @Default(true) bool isValid,
    @Default(false) bool isActive,
  }) = _PageReorderOperation;
}

@freezed
abstract class BatchPageOperation with _$BatchPageOperation {
  const factory BatchPageOperation({
    required List<String> pageIds,
    required String operationType,
    @Default({}) Map<String, dynamic> parameters,
    @Default(0.0) double progress,
    @Default(false) bool isProcessing,
  }) = _BatchPageOperation;
}
