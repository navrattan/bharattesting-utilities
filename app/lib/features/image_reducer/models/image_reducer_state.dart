import 'dart:typed_data';

enum ResizePreset {
  thumbnail,
  small,
  medium,
  large,
  ultraHd,
  square512,
  square1024,
}

extension ResizePresetExtension on ResizePreset {
  String get displayName {
    switch (this) {
      case ResizePreset.thumbnail:
        return 'Thumbnail';
      case ResizePreset.small:
        return 'Small';
      case ResizePreset.medium:
        return 'Medium';
      case ResizePreset.large:
        return 'Large';
      case ResizePreset.ultraHd:
        return 'Ultra HD';
      case ResizePreset.square512:
        return 'Square 512';
      case ResizePreset.square1024:
        return 'Square 1024';
    }
  }

  int get width {
    switch (this) {
      case ResizePreset.thumbnail:
        return 150;
      case ResizePreset.small:
        return 640;
      case ResizePreset.medium:
        return 1024;
      case ResizePreset.large:
        return 1920;
      case ResizePreset.ultraHd:
        return 3840;
      case ResizePreset.square512:
        return 512;
      case ResizePreset.square1024:
        return 1024;
    }
  }

  int get height {
    switch (this) {
      case ResizePreset.thumbnail:
        return 150;
      case ResizePreset.small:
        return 480;
      case ResizePreset.medium:
        return 768;
      case ResizePreset.large:
        return 1080;
      case ResizePreset.ultraHd:
        return 2160;
      case ResizePreset.square512:
        return 512;
      case ResizePreset.square1024:
        return 1024;
    }
  }

  String get dimensions => '$width × $height';
}

enum ConvertibleFormat {
  jpeg('JPEG', 'Photographs and complex images', ['.jpg', '.jpeg']),
  png('PNG', 'Graphics and transparency', ['.png']),
  webp('WebP', 'Modern web optimized format', ['.webp']),
  bmp('BMP', 'Bitmap compatibility format', ['.bmp']),
  gif('GIF', 'Simple animation and graphics', ['.gif']),
  tiff('TIFF', 'High fidelity archival format', ['.tiff', '.tif']);

  const ConvertibleFormat(this.displayName, this.bestFor, this.extensions);
  final String displayName;
  final String bestFor;
  final List<String> extensions;

  String get primaryExtension => extensions.first;
  String get extension => primaryExtension.replaceFirst('.', '');
}

enum ConversionStrategy {
  preserveQuality('Preserve Quality', 'Maintain maximum quality'),
  balanceQualitySize('Balanced', 'Balance quality and file size'),
  minimizeSize('Minimize Size', 'Smallest possible file'),
  preserveAlpha('Preserve Alpha', 'Keep transparency when possible'),
  stripMetadata('Strip Metadata', 'Prioritize privacy'),
  webOptimized('Web Optimized', 'Fast loading for web');

  const ConversionStrategy(this.displayName, this.description);
  final String displayName;
  final String description;
}

enum PrivacyLevel {
  minimal('Minimal', 'Remove GPS and personal metadata'),
  moderate('Moderate', 'Remove sensitive metadata'),
  aggressive('Aggressive', 'Remove all metadata except basic technical info'),
  complete('Complete', 'Remove all metadata');

  const PrivacyLevel(this.displayName, this.description);
  final String displayName;
  final String description;
}

class ResizeConfig {
  const ResizeConfig({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  factory ResizeConfig.fromPreset(ResizePreset preset) {
    return ResizeConfig(width: preset.width, height: preset.height);
  }
}

class MetadataStripConfig {
  const MetadataStripConfig({
    required this.privacyLevel,
    this.preserveOrientation = true,
    this.preserveColorProfile = true,
  });

  final PrivacyLevel privacyLevel;
  final bool preserveOrientation;
  final bool preserveColorProfile;
}

class ImageReductionConfig {
  const ImageReductionConfig({
    required this.stripMetadata,
    required this.resize,
    required this.compress,
    required this.convertFormat,
    required this.compressionQuality,
    required this.resizeConfig,
    required this.metadataConfig,
    this.targetFormat,
    this.conversionStrategy = ConversionStrategy.balanceQualitySize,
  });

  final bool stripMetadata;
  final bool resize;
  final bool compress;
  final bool convertFormat;
  final int compressionQuality;
  final ResizeConfig resizeConfig;
  final MetadataStripConfig metadataConfig;
  final ConvertibleFormat? targetFormat;
  final ConversionStrategy conversionStrategy;
}

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
    this.selectedPreset = ResizePreset.medium,
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

enum ProcessingStatus {
  pending('Pending'),
  processing('Processing'),
  completed('Completed'),
  error('Error');

  const ProcessingStatus(this.displayName);
  final String displayName;
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
