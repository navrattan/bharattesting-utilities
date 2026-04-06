import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bharattesting_core/core.dart';
import 'dart:typed_data';

part 'image_reducer_state.freezed.dart';

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
    @Default(null) Uint8List? processedData,
    @Default(null) ImageReductionResult? result,
    @Default(ProcessingStatus.pending) ProcessingStatus status,
    @Default('') String error,
    @Default(0) int estimatedSize,
    @Default(null) ConvertibleFormat? detectedFormat,
    @Default(null) ImageMetadata? metadata,
  }) = _ProcessedImage;

  const ProcessedImage._();

  bool get isProcessed => processedData != null;
  bool get hasError => error.isNotEmpty;
  bool get isProcessing => status == ProcessingStatus.processing;

  int get originalSize => originalData.length;
  int get processedSize => processedData?.length ?? 0;
  int get currentSize => processedData?.length ?? originalData.length;

  double get sizeReduction {
    if (originalSize == 0) return 0;
    return ((originalSize - currentSize) / originalSize) * 100;
  }

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