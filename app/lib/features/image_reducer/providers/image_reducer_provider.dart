import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:archive/archive.dart';
import 'package:share_plus/share_plus.dart';
import '../models/image_reducer_state.dart';

part 'image_reducer_provider.g.dart';

@riverpod
class ImageReducer extends _$ImageReducer {
  @override
  ImageReducerState build() {
    return const ImageReducerState();
  }

  /// Add images from file picker results or dropped files
  Future<void> addImages(List<PlatformFile> files) async {
    final validImages = <ProcessedImage>[];

    for (final file in files) {
      if (file.bytes == null) continue;

      try {
        final image = ProcessedImage(
          fileName: file.name,
          originalData: file.bytes!,
          status: ProcessingStatus.pending,
        );
        validImages.add(image);
      } catch (e) {
        _addError('Failed to add ${file.name}: $e');
      }
    }

    final updatedImages = [...state.images, ...validImages];
    state = state.copyWith(
      images: updatedImages,
      selectedImage: state.selectedImage ??
          (updatedImages.isNotEmpty ? updatedImages.first : null),
      showBatchMode: updatedImages.length > 1,
    );
  }

  /// Pick images using file picker
  Future<void> pickImages({bool allowMultiple = true}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: allowMultiple,
      withData: true,
    );

    if (result != null) {
      await addImages(result.files);
    }
  }

  /// Clear all images
  void clearImages() {
    state = const ImageReducerState();
  }

  /// Remove a specific image
  void removeImage(ProcessedImage image) {
    final updatedImages = state.images.where((i) => i.fileName != image.fileName).toList();
    state = state.copyWith(
      images: updatedImages,
      selectedImage: state.selectedImage?.fileName == image.fileName
          ? (updatedImages.isNotEmpty ? updatedImages.first : null)
          : state.selectedImage,
      showBatchMode: updatedImages.length > 1,
    );
  }

  /// Select image for single-mode preview
  void selectImage(ProcessedImage image) {
    state = state.copyWith(
      selectedImage: image,
      showBatchMode: false,
    );
  }

  /// Toggle batch mode
  void toggleBatchMode(bool enabled) {
    state = state.copyWith(showBatchMode: enabled);
  }

  /// Update quality setting (1-100)
  void updateQuality(int quality) {
    state = state.copyWith(quality: quality);
  }

  /// Update resize preset
  void updateResizePreset(ResizePreset preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  /// Toggle resize
  void toggleResize() {
    state = state.copyWith(enableResize: !state.enableResize);
  }

  /// Update output format
  void updateTargetFormat(ConvertibleFormat format) {
    state = state.copyWith(targetFormat: format);
  }

  /// Toggle format conversion
  void toggleFormatConversion() {
    state = state.copyWith(enableFormatConversion: !state.enableFormatConversion);
  }

  /// Update conversion strategy
  void updateStrategy(ConversionStrategy strategy) {
    state = state.copyWith(strategy: strategy);
  }

  /// Toggle metadata stripping
  void toggleMetadataStripping() {
    state = state.copyWith(stripMetadata: !state.stripMetadata);
  }

  /// Update privacy level
  void updatePrivacyLevel(PrivacyLevel level) {
    state = state.copyWith(privacyLevel: level);
  }

  /// Perform image reduction/optimization
  Future<void> processImages() async {
    if (!state.canProcess) return;

    if (state.showBatchMode) {
      await _processBatch();
    } else if (state.currentImage != null) {
      await _processSingleImage(state.currentImage!);
    }
  }

  Future<void> _processSingleImage(ProcessedImage image) async {
    state = state.copyWith(isProcessing: true);

    try {
      final config = _buildProcessingConfig();
      final result = await compute(_processImageIsolate, {
        'imageData': image.originalData,
        'config': config,
      });

      final updatedImage = image.copyWith(
        processedData: result['processedData'] as Uint8List?,
        result: result['result'] as ImageReductionResult?,
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

  Future<void> _processBatch() async {
    state = state.copyWith(isProcessing: true);
    final config = _buildProcessingConfig();
    int completed = 0;

    for (int i = 0; i < state.images.length; i++) {
      final image = state.images[i];
      if (image.status == ProcessingStatus.completed) continue;

      try {
        final markAsProcessing = image.copyWith(status: ProcessingStatus.processing);
        _updateImageAt(i, markAsProcessing);

        final result = await compute(_processImageIsolate, {
          'imageData': image.originalData,
          'config': config,
        });

        final processedImage = image.copyWith(
          processedData: result['processedData'] as Uint8List?,
          result: result['result'] as ImageReductionResult?,
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
      }
    }

    state = state.copyWith(isProcessing: false);
  }

  /// Download single processed image
  Future<void> downloadImage(ProcessedImage image) async {
    if (image.processedData == null) return;
    // Trigger download (implementation depends on platform)
    debugPrint('Download started: ${image.fileName}');
  }

  /// Download all processed images
  Future<void> downloadImages() async {
    if (state.showBatchMode) {
      // Logic for batch download (ZIP)
    } else if (state.currentImage != null) {
      await downloadImage(state.currentImage!);
    }
  }

  /// Copy image to clipboard
  Future<void> copyToClipboard(ProcessedImage image) async {
    if (image.processedData == null) return;
    // Clipboard logic
    debugPrint('Copied to clipboard: ${image.fileName}');
  }

  // Helper methods

  ImageReductionConfig _buildProcessingConfig() {
    return ImageReductionConfig(
      stripMetadata: state.stripMetadata,
      resize: state.enableResize,
      compress: true,
      convertFormat: state.enableFormatConversion,
      compressionQuality: state.quality,
      resizeConfig: ResizeConfig.fromPreset(state.selectedPreset),
      metadataConfig: MetadataStripConfig(privacyLevel: state.privacyLevel),
      targetFormat: state.targetFormat,
      conversionStrategy: state.strategy,
    );
  }

  void _updateImage(ProcessedImage oldImage, ProcessedImage newImage) {
    final updatedImages = state.images.map((i) => i.fileName == oldImage.fileName ? newImage : i).toList();
    state = state.copyWith(
      images: updatedImages,
      selectedImage: state.selectedImage?.fileName == oldImage.fileName ? newImage : state.selectedImage,
    );
  }

  void _updateImageAt(int index, ProcessedImage newImage) {
    final updatedImages = List<ProcessedImage>.from(state.images);
    updatedImages[index] = newImage;
    state = state.copyWith(
      images: updatedImages,
      selectedImage: state.selectedImage?.fileName == newImage.fileName ? newImage : state.selectedImage,
    );
  }

  void _addError(String message) {
    state = state.copyWith(processingErrors: [...state.processingErrors, message]);
  }
}

// Isolate function for image processing
Map<String, dynamic> _processImageIsolate(Map<String, dynamic> params) {
  final imageData = params['imageData'] as Uint8List;
  // final config = params['config'] as ImageReductionConfig;

  // Placeholder implementation
  return {
    'processedData': imageData,
    'result': ImageReductionResult(
      processedData: imageData,
      originalSize: imageData.length,
      finalSize: (imageData.length * 0.8).round(),
      reductionRatio: 0.8,
      processingTime: const Duration(milliseconds: 200),
      operations: ['Mock compression'],
      efficiencyScore: 85.0,
    ),
  };
}
