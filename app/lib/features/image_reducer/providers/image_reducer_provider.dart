import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:archive/archive.dart';
import '../models/image_reducer_state.dart';

part 'image_reducer_provider.g.dart';

@riverpod
class ImageReducer extends _$ImageReducer {
  Timer? _debounceTimer;

  @override
  ImageReducerState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    return const ImageReducerState();
  }

  /// Pick images from file system
  Future<void> pickImages({bool allowMultiple = true}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: allowMultiple,
        withData: true,
      );

      if (result != null) {
        await addImages(result.files);
      }
    } catch (e) {
      _addError('Failed to pick images: $e');
    }
  }

  /// Add images from file picker results or dropped files
  Future<void> addImages(List<PlatformFile> files) async {
    final validImages = <ProcessedImage>[];

    for (final file in files) {
      if (file.bytes == null) continue;

      try {
        // Detect format and extract metadata
        final format = _detectImageFormat(file.bytes!);
        final metadata = await _extractMetadata(file.bytes!, format);

        final image = ProcessedImage(
          fileName: file.name,
          originalData: file.bytes!,
          detectedFormat: format,
          metadata: metadata,
          estimatedSize: _estimateProcessedSize(file.bytes!.length),
        );

        validImages.add(image);
      } catch (e) {
        _addError('Failed to process ${file.name}: $e');
      }
    }

    if (validImages.isNotEmpty) {
      state = state.copyWith(
        images: [...state.images, ...validImages],
        selectedImage: state.selectedImage ?? validImages.first,
        showBatchMode: state.images.length + validImages.length > 1,
      );

      // Auto-process if single image
      if (!state.showBatchMode && validImages.length == 1) {
        _debounceProcessing();
      }
    }
  }

  /// Remove image from list
  void removeImage(ProcessedImage image) {
    final updatedImages = state.images.where((img) => img != image).toList();

    state = state.copyWith(
      images: updatedImages,
      selectedImage: state.selectedImage == image
          ? (updatedImages.isNotEmpty ? updatedImages.first : null)
          : state.selectedImage,
      showBatchMode: updatedImages.length > 1,
    );
  }

  /// Clear all images
  void clearImages() {
    state = const ImageReducerState();
  }

  /// Select image for preview
  void selectImage(ProcessedImage image) {
    state = state.copyWith(selectedImage: image);
  }

  /// Update quality setting
  void updateQuality(int quality) {
    state = state.copyWith(quality: quality);
    _debounceProcessing();
  }

  /// Update resize preset
  void updateResizePreset(ResizePreset preset) {
    state = state.copyWith(selectedPreset: preset);
    _debounceProcessing();
  }

  /// Update target format
  void updateTargetFormat(ConvertibleFormat format) {
    state = state.copyWith(targetFormat: format);
    _debounceProcessing();
  }

  /// Update conversion strategy
  void updateStrategy(ConversionStrategy strategy) {
    state = state.copyWith(strategy: strategy);
    _debounceProcessing();
  }

  /// Toggle metadata stripping
  void toggleMetadataStripping() {
    state = state.copyWith(stripMetadata: !state.stripMetadata);
    _debounceProcessing();
  }

  /// Update privacy level
  void updatePrivacyLevel(PrivacyLevel level) {
    state = state.copyWith(privacyLevel: level);
    if (state.stripMetadata) {
      _debounceProcessing();
    }
  }

  /// Toggle resize
  void toggleResize() {
    state = state.copyWith(enableResize: !state.enableResize);
    _debounceProcessing();
  }

  /// Toggle format conversion
  void toggleFormatConversion() {
    state = state.copyWith(enableFormatConversion: !state.enableFormatConversion);
    _debounceProcessing();
  }

  /// Toggle advanced settings
  void toggleAdvancedSettings() {
    state = state.copyWith(showAdvancedSettings: !state.showAdvancedSettings);
  }

  /// Process single image or all images
  Future<void> processImages() async {
    if (!state.canProcess) return;

    if (state.showBatchMode) {
      await _processBatch();
    } else if (state.currentImage != null) {
      await _processSingleImage(state.currentImage!);
    }
  }

  /// Process single image with current settings
  Future<void> _processSingleImage(ProcessedImage image) async {
    state = state.copyWith(isProcessing: true);

    try {
      final config = _buildProcessingConfig();
      final result = await compute(_processImageIsolate, {
        'imageData': image.originalData,
        'config': config,
      });

      final updatedImage = image.copyWith(
        processedData: result['processedData'],
        result: result['result'],
        status: ProcessingStatus.completed,
      );

      _updateImage(image, updatedImage);

    } catch (e) {
      final errorImage = image.copyWith(
        status: ProcessingStatus.error,
        error: e.toString(),
      );
      _updateImage(image, errorImage);
      _addError('Processing failed for ${image.fileName}: $e');
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  /// Process all images in batch
  Future<void> _processBatch() async {
    state = state.copyWith(
      isProcessing: true,
      processingProgress: 0,
      processingErrors: <String>[],
    );

    final config = _buildProcessingConfig();
    int completed = 0;

    for (int i = 0; i < state.images.length; i++) {
      final image = state.images[i];

      // Update progress
      state = state.copyWith(processingProgress: ((completed / state.images.length) * 100).round());

      try {
        final markAsProcessing = image.copyWith(status: ProcessingStatus.processing);
        _updateImageAt(i, markAsProcessing);

        final result = await compute(_processImageIsolate, {
          'imageData': image.originalData,
          'config': config,
        });

        final processedImage = image.copyWith(
          processedData: result['processedData'],
          result: result['result'],
          status: ProcessingStatus.completed,
        );

        _updateImageAt(i, processedImage);
        completed++;

      } catch (e) {
        final errorImage = image.copyWith(
          status: ProcessingStatus.error,
          error: e.toString(),
        );
        _updateImageAt(i, errorImage);
        _addError('Failed to process ${image.fileName}: $e');
      }
    }

    state = state.copyWith(
      isProcessing: false,
      processingProgress: 100,
    );
  }

  /// Download processed image(s)
  Future<void> downloadImages() async {
    if (state.showBatchMode) {
      await _downloadBatch();
    } else if (state.currentImage?.isProcessed == true) {
      await _downloadSingle(state.currentImage!);
    }
  }

  /// Download single processed image
  Future<void> _downloadSingle(ProcessedImage image) async {
    if (image.processedData == null) return;

    try {
      // For web, trigger download
      if (kIsWeb) {
        await _downloadWebFile(
          image.processedData!,
          _getOutputFileName(image),
        );
      }
    } catch (e) {
      _addError('Download failed: $e');
    }
  }

  /// Download all processed images as ZIP
  Future<void> _downloadBatch() async {
    final processedImages = state.images.where((img) => img.isProcessed).toList();
    if (processedImages.isEmpty) return;

    try {
      // Create ZIP archive
      final archive = Archive();

      for (final image in processedImages) {
        if (image.processedData != null) {
          final file = ArchiveFile(
            _getOutputFileName(image),
            image.processedData!.length,
            image.processedData!,
          );
          archive.addFile(file);
        }
      }

      final zipData = ZipEncoder().encode(archive)!;

      if (kIsWeb) {
        await _downloadWebFile(
          Uint8List.fromList(zipData),
          'image_batch_${DateTime.now().millisecondsSinceEpoch}.zip',
        );
      }
    } catch (e) {
      _addError('Batch download failed: $e');
    }
  }

  /// Copy processed data to clipboard (base64)
  Future<void> copyToClipboard(ProcessedImage image) async {
    if (image.processedData == null) return;

    try {
      final base64String = 'data:image/${state.targetFormat.primaryExtension.substring(1)};base64,${base64Encode(image.processedData!)}';
      await Clipboard.setData(ClipboardData(text: base64String));
    } catch (e) {
      _addError('Copy failed: $e');
    }
  }

  // Private helper methods

  void _debounceProcessing() {
    _debounceTimer?.cancel();
    if (state.hasImages && !state.isProcessing) {
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        processImages();
      });
    }
  }

  ImageReductionConfig _buildProcessingConfig() {
    return ImageReductionConfig(
      stripMetadata: state.stripMetadata,
      resize: state.enableResize,
      compress: true,
      convertFormat: state.enableFormatConversion,
      compressionQuality: state.quality,
      resizeConfig: ResizeConfig.fromPreset(state.selectedPreset),
      metadataConfig: _buildMetadataConfig(),
      targetFormat: state.enableFormatConversion ? state.targetFormat : null,
      conversionStrategy: state.strategy,
    );
  }

  MetadataStripConfig _buildMetadataConfig() {
    return MetadataStripConfig(
      privacyLevel: state.privacyLevel,
      preserveOrientation: true,
      preserveColorProfile: state.privacyLevel != PrivacyLevel.complete,
    );
  }

  void _updateImage(ProcessedImage oldImage, ProcessedImage newImage) {
    final index = state.images.indexOf(oldImage);
    if (index >= 0) {
      _updateImageAt(index, newImage);
    }
  }

  void _updateImageAt(int index, ProcessedImage newImage) {
    final updatedImages = [...state.images];
    updatedImages[index] = newImage;

    state = state.copyWith(
      images: updatedImages,
      selectedImage: state.selectedImage == state.images[index] ? newImage : state.selectedImage,
    );
  }

  void _addError(String error) {
    state = state.copyWith(
      processingErrors: [...state.processingErrors, error],
    );
  }

  ConvertibleFormat? _detectImageFormat(Uint8List data) {
    if (data.length < 4) return null;

    // JPEG
    if (data[0] == 0xFF && data[1] == 0xD8) {
      return ConvertibleFormat.jpeg;
    }

    // PNG
    if (data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) {
      return ConvertibleFormat.png;
    }

    // WebP
    if (data.length >= 12 &&
        data[0] == 0x52 && data[1] == 0x49 && data[2] == 0x46 && data[3] == 0x46 &&
        data[8] == 0x57 && data[9] == 0x45 && data[10] == 0x42 && data[11] == 0x50) {
      return ConvertibleFormat.webp;
    }

    return ConvertibleFormat.jpeg; // Fallback
  }

  Future<ImageMetadata> _extractMetadata(Uint8List data, ConvertibleFormat? format) async {
    // Simplified metadata extraction - in production would use proper libraries
    return ImageMetadata(
      width: 800, // Would extract actual dimensions
      height: 600,
      format: format?.displayName ?? 'Unknown',
      hasAlpha: format == ConvertibleFormat.png,
      colorChannels: format == ConvertibleFormat.png ? 4 : 3,
      hasMetadata: true,
      hasGpsData: false,
      metadataTypes: ['EXIF', 'IPTC'],
    );
  }

  int _estimateProcessedSize(int originalSize) {
    final compressionRatio = state.quality / 100.0;
    final resizeRatio = state.enableResize ? 0.8 : 1.0;
    return (originalSize * compressionRatio * resizeRatio).round();
  }

  String _getOutputFileName(ProcessedImage image) {
    final nameWithoutExtension = image.fileName.split('.').first;
    final extension = state.enableFormatConversion
        ? state.targetFormat.primaryExtension
        : image.detectedFormat?.primaryExtension ?? '.jpg';
    return '${nameWithoutExtension}_reduced$extension';
  }

  Future<void> _downloadWebFile(Uint8List data, String fileName) async {
    // Web download implementation would go here
    // For now, just copy to clipboard as fallback
    await Clipboard.setData(ClipboardData(text: 'Download: $fileName (${data.length} bytes)'));
  }
}

// Isolate function for image processing
Map<String, dynamic> _processImageIsolate(Map<String, dynamic> params) {
  final imageData = params['imageData'] as Uint8List;
  final config = params['config'] as ImageReductionConfig;

  // This would be replaced with actual image processing
  // For now, return mock result
  return {
    'processedData': imageData,
    'result': ImageReductionResult(
      processedData: imageData,
      originalSize: imageData.length,
      finalSize: (imageData.length * 0.8).round(),
      reductionRatio: 0.8,
      processingTime: Duration(milliseconds: 200),
      operations: ['Mock compression'],
      efficiencyScore: 85.0,
    ),
  };
}
