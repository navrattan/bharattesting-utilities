import 'dart:typed_data';
import 'package:bharattesting_core/core.dart';

/// App-specific processing status for UI state management
enum ProcessingStatus {
  pending('Pending'),
  processing('Processing'),
  completed('Completed'),
  error('Error');

  const ProcessingStatus(this.displayName);
  final String displayName;
}

/// App-specific result class for processed images
class ImageReductionResult {
  const ImageReductionResult({
    required this.processedData,
    required this.originalSize,
    required this.finalSize,
    required this.reductionRatio,
    required this.processingTime,
    this.operations = const [],
    this.efficiencyScore = 0.0,
  });

  final Uint8List processedData;
  final int originalSize;
  final int finalSize;
  final double reductionRatio;
  final Duration processingTime;
  final List<String> operations;
  final double efficiencyScore;

  String get qualityGrade {
    if (efficiencyScore >= 90) return 'A+';
    if (efficiencyScore >= 80) return 'A';
    if (efficiencyScore >= 70) return 'B';
    if (efficiencyScore >= 60) return 'C';
    return 'D';
  }
}

class ImageReducerState {
  const ImageReducerState({
    this.images = const <ProcessedImage>[],
    this.isProcessing = false,
    this.quality = 80,
    this.selectedPreset = ResizePreset.hd,
    this.targetFormat = ConvertibleFormat.jpeg,
    this.strategy = ConversionStrategy.balanceQualitySize,
    this.privacyLevel = PrivacyLevel.moderate,
    this.stripMetadata = false,
    this.enableResize = false,
    this.enableFormatConversion = false,
    this.processingProgress = 0,
    this.processingErrors = const <String>[],
    this.selectedImage,
    this.showAdvancedSettings = false,
    this.showBatchMode = false,
  });

  final List<ProcessedImage> images;
  final bool isProcessing;
  final int quality;
  final ResizePreset selectedPreset;
  final ConvertibleFormat targetFormat;
  final ConversionStrategy strategy;
  final PrivacyLevel privacyLevel;
  final bool stripMetadata;
  final bool enableResize;
  final bool enableFormatConversion;
  final int processingProgress;
  final List<String> processingErrors;
  final ProcessedImage? selectedImage;
  final bool showAdvancedSettings;
  final bool showBatchMode;

  ImageReducerState copyWith({
    List<ProcessedImage>? images,
    bool? isProcessing,
    int? quality,
    ResizePreset? selectedPreset,
    ConvertibleFormat? targetFormat,
    ConversionStrategy? strategy,
    PrivacyLevel? privacyLevel,
    bool? stripMetadata,
    bool? enableResize,
    bool? enableFormatConversion,
    int? processingProgress,
    List<String>? processingErrors,
    ProcessedImage? selectedImage,
    bool? showAdvancedSettings,
    bool? showBatchMode,
  }) {
    return ImageReducerState(
      images: images ?? this.images,
      isProcessing: isProcessing ?? this.isProcessing,
      quality: quality ?? this.quality,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      targetFormat: targetFormat ?? this.targetFormat,
      strategy: strategy ?? this.strategy,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      stripMetadata: stripMetadata ?? this.stripMetadata,
      enableResize: enableResize ?? this.enableResize,
      enableFormatConversion: enableFormatConversion ?? this.enableFormatConversion,
      processingProgress: processingProgress ?? this.processingProgress,
      processingErrors: processingErrors ?? this.processingErrors,
      selectedImage: selectedImage ?? this.selectedImage,
      showAdvancedSettings: showAdvancedSettings ?? this.showAdvancedSettings,
      showBatchMode: showBatchMode ?? this.showBatchMode,
    );
  }

  bool get hasImages => images.isNotEmpty;
  bool get hasSingleImage => images.length == 1;
  bool get hasMultipleImages => images.length > 1;
  bool get hasErrors => processingErrors.isNotEmpty;
  bool get canProcess => hasImages && !isProcessing;
  bool get isProcessingBatch => isProcessing && hasMultipleImages;

  ProcessedImage? get firstImage => images.isNotEmpty ? images.first : null;
  ProcessedImage? get currentImage => selectedImage ?? firstImage;

  int get totalOriginalSize => images.fold(
    0,
    (sum, img) => sum + (img.originalData?.length ?? 0),
  );

  int get totalProcessedSize => images.fold(
    0,
    (sum, img) => sum + (img.processedData?.length ?? 0),
  );

  double get totalSizeReduction {
    if (totalOriginalSize == 0) return 0;
    return ((totalOriginalSize - totalProcessedSize) / totalOriginalSize) * 100;
  }

  int get estimatedTotalSize {
    return images.fold(0, (sum, img) => sum + img.estimatedSize);
  }
}

class ProcessedImage {
  const ProcessedImage({
    required this.fileName,
    required this.originalData,
    this.processedData,
    this.result,
    this.status = ProcessingStatus.pending,
    this.error = '',
    this.estimatedSize = 0,
    this.detectedFormat,
    this.metadata,
  });

  final String fileName;
  final Uint8List originalData;
  final Uint8List? processedData;
  final ImageReductionResult? result;
  final ProcessingStatus status;
  final String error;
  final int estimatedSize;
  final ConvertibleFormat? detectedFormat;
  final ImageMetadata? metadata;

  ProcessedImage copyWith({
    String? fileName,
    Uint8List? originalData,
    Uint8List? processedData,
    ImageReductionResult? result,
    ProcessingStatus? status,
    String? error,
    int? estimatedSize,
    ConvertibleFormat? detectedFormat,
    ImageMetadata? metadata,
  }) {
    return ProcessedImage(
      fileName: fileName ?? this.fileName,
      originalData: originalData ?? this.originalData,
      processedData: processedData ?? this.processedData,
      result: result ?? this.result,
      status: status ?? this.status,
      error: error ?? this.error,
      estimatedSize: estimatedSize ?? this.estimatedSize,
      detectedFormat: detectedFormat ?? this.detectedFormat,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isProcessed => processedData != null;
  bool get hasError => error.isNotEmpty;
  bool get isProcessing => status == ProcessingStatus.processing;

  int get originalSize => originalData.length;
  int get processedSize => processedData?.length ?? 0;
  int get currentSize => processedData?.length ?? originalData.length;
  int get originalFileSize => originalData.length;
  int? get processedFileSize => processedData?.length;

  double get sizeReduction {
    if (originalSize == 0) return 0;
    return ((originalSize - currentSize) / originalSize) * 100;
  }
  double get reductionPercentage => sizeReduction;
  String get reductionPercentageText => '${sizeReduction.toStringAsFixed(1)}%';

  String get sizeReductionText {
    if (!isProcessed) return 'Not processed';
    final percent = sizeReduction.toStringAsFixed(1);
    return '${percent}% reduction';
  }

  String get fileSizeText {
    final size = currentSize;
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / 1024 / 1024).toStringAsFixed(2)}MB';
  }

  String get originalFileSizeText {
    final size = originalSize;
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / 1024 / 1024).toStringAsFixed(2)}MB';
  }

  String get formatDisplayName => detectedFormat?.displayName ?? 'Unknown';

  double get qualityScore => result?.efficiencyScore ?? 0.0;
  String get qualityGrade => result?.qualityGrade ?? 'Not processed';
}

class ImageMetadata {
  const ImageMetadata({
    required this.width,
    required this.height,
    required this.format,
    this.hasAlpha = false,
    this.colorChannels = 0,
    this.hasMetadata = false,
    this.hasGpsData = false,
    this.metadataTypes = const <String>[],
  });

  final int width;
  final int height;
  final String format;
  final bool hasAlpha;
  final int colorChannels;
  final bool hasMetadata;
  final bool hasGpsData;
  final List<String> metadataTypes;

  ImageMetadata copyWith({
    int? width,
    int? height,
    String? format,
    bool? hasAlpha,
    int? colorChannels,
    bool? hasMetadata,
    bool? hasGpsData,
    List<String>? metadataTypes,
  }) {
    return ImageMetadata(
      width: width ?? this.width,
      height: height ?? this.height,
      format: format ?? this.format,
      hasAlpha: hasAlpha ?? this.hasAlpha,
      colorChannels: colorChannels ?? this.colorChannels,
      hasMetadata: hasMetadata ?? this.hasMetadata,
      hasGpsData: hasGpsData ?? this.hasGpsData,
      metadataTypes: metadataTypes ?? this.metadataTypes,
    );
  }

  String get dimensions => '${width} × ${height}';
  int get megapixels => ((width * height) / 1000000).round();
  String get megapixelsText => '${megapixels}MP';

  String get aspectRatioText {
    final gcd = _gcd(width, height);
    final w = width ~/ gcd;
    final h = height ~/ gcd;
    return '${w}:${h}';
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }
}
