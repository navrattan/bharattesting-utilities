import 'dart:typed_data';
import 'package:bharattesting_core/core.dart' as core;

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

class PdfMergerState {
  const PdfMergerState({
    this.documents = const [],
    this.pages = const [],
    this.isProcessing = false,
    this.processingProgress = 0,
    this.processingErrors = const [],
    this.selectedDocument,
    this.selectedPage,
    this.showPasswordDialog = false,
    this.showAdvancedSettings = false,
    this.enableEncryption = false,
    this.encryptionPassword = '',
    this.permissions = const core.PdfPermissions(),
    this.mergeOptions = const core.PdfMergeOptions(),
    this.mergedPdfData,
    this.outputFileName = 'merged_document.pdf',
  });

  final List<PdfDocument> documents;
  final List<PdfPageThumbnail> pages;
  final bool isProcessing;
  final int processingProgress;
  final List<String> processingErrors;
  final PdfDocument? selectedDocument;
  final PdfPageThumbnail? selectedPage;
  final bool showPasswordDialog;
  final bool showAdvancedSettings;
  final bool enableEncryption;
  final String encryptionPassword;
  final core.PdfPermissions permissions;
  final core.PdfMergeOptions mergeOptions;
  final Uint8List? mergedPdfData;
  final String outputFileName;

  PdfMergerState copyWith({
    List<PdfDocument>? documents,
    List<PdfPageThumbnail>? pages,
    bool? isProcessing,
    int? processingProgress,
    List<String>? processingErrors,
    PdfDocument? selectedDocument,
    PdfPageThumbnail? selectedPage,
    bool? showPasswordDialog,
    bool? showAdvancedSettings,
    bool? enableEncryption,
    String? encryptionPassword,
    core.PdfPermissions? permissions,
    core.PdfMergeOptions? mergeOptions,
    Uint8List? mergedPdfData,
    String? outputFileName,
  }) {
    return PdfMergerState(
      documents: documents ?? this.documents,
      pages: pages ?? this.pages,
      isProcessing: isProcessing ?? this.isProcessing,
      processingProgress: processingProgress ?? this.processingProgress,
      processingErrors: processingErrors ?? this.processingErrors,
      selectedDocument: selectedDocument ?? this.selectedDocument,
      selectedPage: selectedPage ?? this.selectedPage,
      showPasswordDialog: showPasswordDialog ?? this.showPasswordDialog,
      showAdvancedSettings: showAdvancedSettings ?? this.showAdvancedSettings,
      enableEncryption: enableEncryption ?? this.enableEncryption,
      encryptionPassword: encryptionPassword ?? this.encryptionPassword,
      permissions: permissions ?? this.permissions,
      mergeOptions: mergeOptions ?? this.mergeOptions,
      mergedPdfData: mergedPdfData ?? this.mergedPdfData,
      outputFileName: outputFileName ?? this.outputFileName,
    );
  }
}

class PdfDocument {
  const PdfDocument({
    required this.id,
    required this.fileName,
    required this.data,
    required this.fileSize,
    required this.pageCount,
    this.status = DocumentStatus.ready,
    this.error,
  });

  final String id;
  final String fileName;
  final Uint8List data;
  final int fileSize;
  final int pageCount;
  final DocumentStatus status;
  final String? error;

  PdfDocument copyWith({
    String? id,
    String? fileName,
    Uint8List? data,
    int? fileSize,
    int? pageCount,
    DocumentStatus? status,
    String? error,
  }) {
    return PdfDocument(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      data: data ?? this.data,
      fileSize: fileSize ?? this.fileSize,
      pageCount: pageCount ?? this.pageCount,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  String get displayName => fileName;
  String get fileSizeText => '${(fileSize / 1024).toStringAsFixed(1)} KB';
  String get pageCountText => '$pageCount page${pageCount == 1 ? '' : 's'}';
}

enum DocumentStatus { loading, ready, error }

class PdfPageThumbnail {
  const PdfPageThumbnail({
    required this.id,
    required this.documentId,
    required this.pageNumber,
    required this.globalIndex,
    required this.dimensions,
    this.rotation = core.PageRotation.none,
    this.thumbnailData,
    this.isSelected = false,
    this.isDuplicate = false,
    this.isBlank = false,
    this.status = ThumbnailStatus.loading,
  });

  final String id;
  final String documentId;
  final int pageNumber;
  final int globalIndex;
  final PageDimensions dimensions;
  final core.PageRotation rotation;
  final Uint8List? thumbnailData;
  final bool isSelected;
  final bool isDuplicate;
  final bool isBlank;
  final ThumbnailStatus status;

  PdfPageThumbnail copyWith({
    String? id,
    String? documentId,
    int? pageNumber,
    int? globalIndex,
    PageDimensions? dimensions,
    core.PageRotation? rotation,
    Uint8List? thumbnailData,
    bool? isSelected,
    bool? isDuplicate,
    bool? isBlank,
    ThumbnailStatus? status,
  }) {
    return PdfPageThumbnail(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      pageNumber: pageNumber ?? this.pageNumber,
      globalIndex: globalIndex ?? this.globalIndex,
      dimensions: dimensions ?? this.dimensions,
      rotation: rotation ?? this.rotation,
      thumbnailData: thumbnailData ?? this.thumbnailData,
      isSelected: isSelected ?? this.isSelected,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      isBlank: isBlank ?? this.isBlank,
      status: status ?? this.status,
    );
  }

  int get displayGlobalNumber => globalIndex + 1;
  bool get isReady => status == ThumbnailStatus.ready;
}

enum ThumbnailStatus { loading, ready, error }

class PdfMergerOperation {
  const PdfMergerOperation({
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

  PdfMergerOperation copyWith({
    String? id,
    String? message,
    DateTime? startTime,
    DateTime? endTime,
    double? progress,
    bool? isCompleted,
    String? error,
  }) {
    return PdfMergerOperation(
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

class MergeStatistics {
  const MergeStatistics({
    required this.totalDocuments,
    required this.totalPages,
    required this.totalSize,
    required this.estimatedOutputSize,
    this.compressionRatio = 0.0,
    this.estimatedTime = Duration.zero,
    this.orientationCounts = const {},
    this.duplicateCount = 0,
  });

  final int totalDocuments;
  final int totalPages;
  final int totalSize;
  final int estimatedOutputSize;
  final double compressionRatio;
  final Duration estimatedTime;
  final Map<String, int> orientationCounts;
  final int duplicateCount;

  String get totalSizeText => '${(totalSize / 1024 / 1024).toStringAsFixed(2)} MB';
  String get outputSizeText => '${(estimatedOutputSize / 1024 / 1024).toStringAsFixed(2)} MB';
  String get compressionText => '${(compressionRatio * 100).toStringAsFixed(0)}%';
  String get estimatedTimeText => '${estimatedTime.inSeconds}s';
}
