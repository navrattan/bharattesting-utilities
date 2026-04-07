import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_reducer_state.freezed.dart';

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

@freezed
class ImageReducerState with _$ImageReducerState {
  const factory ImageReducerState({
    @Default(<ProcessedImage>[]) List<ProcessedImage> images,
    @Default(false) bool isProcessing,
    @Default(80) int quality,
    @Default(ResizePreset.medium) ResizePreset selectedPreset,
    @Default(ConvertibleFormat.jpeg) ConvertibleFormat targetFormat,
    @Default(ConversionStrategy.balanceQualitySize) ConversionStrategy strategy,
    @Default(PrivacyLevel.moderate) PrivacyLevel privacyLevel,
    @Default(false) bool stripMetadata,
    @Default(false) bool enableResize,
    @Default(false) bool enableFormatConversion,
    @Default(0) int processingProgress,
    @Default(<String>[]) List<String> processingErrors,
    ProcessedImage? selectedImage,
    @Default(false) bool showAdvancedSettings,
    @Default(false) bool showBatchMode,
  }) = _ImageReducerState;

  const ImageReducerState._();

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

@freezed
class ProcessedImage with _$ProcessedImage {
  const factory ProcessedImage({
    required String fileName,
    required Uint8List originalData,
    Uint8List? processedData,
    ImageReductionResult? result,
    @Default(ProcessingStatus.pending) ProcessingStatus status,
    @Default('') String error,
    @Default(0) int estimatedSize,
    ConvertibleFormat? detectedFormat,
    ImageMetadata? metadata,
  }) = _ProcessedImage;

  const ProcessedImage._();

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

@freezed
class ImageMetadata with _$ImageMetadata {
  const factory ImageMetadata({
    required int width,
    required int height,
    required String format,
    @Default(false) bool hasAlpha,
    @Default(0) int colorChannels,
    @Default(false) bool hasMetadata,
    @Default(false) bool hasGpsData,
    @Default(<String>[]) List<String> metadataTypes,
  }) = _ImageMetadata;

  const ImageMetadata._();

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
