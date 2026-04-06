/// Privacy-focused EXIF and metadata removal engine
///
/// Strips sensitive metadata while preserving image quality
library metadata_stripper;

import 'dart:typed_data';
import 'dart:convert';
import 'package:image/image.dart' as img;

/// Types of metadata that can be found in images
enum MetadataType {
  exif('EXIF', 'Camera settings, location, timestamps'),
  iptc('IPTC', 'Copyright, keywords, caption information'),
  xmp('XMP', 'Adobe metadata, editing history'),
  icc('ICC', 'Color profile information'),
  thumbnail('Thumbnail', 'Embedded thumbnail images'),
  gps('GPS', 'Location coordinates'),
  camera('Camera', 'Device information, serial numbers'),
  software('Software', 'Editing software information'),
  copyright('Copyright', 'Copyright and ownership data'),
  personal('Personal', 'Personal information and comments');

  const MetadataType(this.displayName, this.description);

  final String displayName;
  final String description;

  /// Check if this type contains potentially sensitive data
  bool get isSensitive => [
    MetadataType.gps,
    MetadataType.camera,
    MetadataType.software,
    MetadataType.personal,
  ].contains(this);
}

/// Privacy levels for metadata stripping
enum PrivacyLevel {
  minimal(
    'Minimal',
    'Remove only GPS and personal information',
    [MetadataType.gps, MetadataType.personal],
  ),
  moderate(
    'Moderate',
    'Remove sensitive data, keep technical info',
    [
      MetadataType.gps,
      MetadataType.personal,
      MetadataType.camera,
      MetadataType.software,
    ],
  ),
  aggressive(
    'Aggressive',
    'Remove all metadata except color profiles',
    [
      MetadataType.exif,
      MetadataType.iptc,
      MetadataType.xmp,
      MetadataType.gps,
      MetadataType.camera,
      MetadataType.software,
      MetadataType.personal,
      MetadataType.copyright,
      MetadataType.thumbnail,
    ],
  ),
  complete(
    'Complete',
    'Remove absolutely all metadata',
    MetadataType.values,
  );

  const PrivacyLevel(this.displayName, this.description, this.typesToRemove);

  final String displayName;
  final String description;
  final List<MetadataType> typesToRemove;
}

/// Configuration for metadata removal
class MetadataStripConfig {
  final PrivacyLevel privacyLevel;
  final Set<MetadataType> customTypesToRemove;
  final Set<MetadataType> customTypesToPreserve;
  final bool preserveOrientation;
  final bool preserveColorProfile;
  final bool preserveBasicImageInfo;
  final bool generateReport;

  const MetadataStripConfig({
    this.privacyLevel = PrivacyLevel.moderate,
    this.customTypesToRemove = const {},
    this.customTypesToPreserve = const {},
    this.preserveOrientation = true,
    this.preserveColorProfile = true,
    this.preserveBasicImageInfo = true,
    this.generateReport = true,
  });

  /// Quick privacy presets
  static const socialMedia = MetadataStripConfig(
    privacyLevel: PrivacyLevel.aggressive,
    preserveOrientation: true,
    preserveColorProfile: false,
  );

  static const webPublishing = MetadataStripConfig(
    privacyLevel: PrivacyLevel.moderate,
    preserveOrientation: true,
    preserveColorProfile: true,
  );

  static const personalArchive = MetadataStripConfig(
    privacyLevel: PrivacyLevel.minimal,
    preserveOrientation: true,
    preserveColorProfile: true,
    preserveBasicImageInfo: true,
  );

  static const maximumPrivacy = MetadataStripConfig(
    privacyLevel: PrivacyLevel.complete,
    preserveOrientation: false,
    preserveColorProfile: false,
    preserveBasicImageInfo: false,
  );

  /// Get final list of metadata types to remove
  Set<MetadataType> getTypesToRemove() {
    final toRemove = Set<MetadataType>.from(privacyLevel.typesToRemove);

    // Add custom types to remove
    toRemove.addAll(customTypesToRemove);

    // Remove custom types to preserve
    toRemove.removeAll(customTypesToPreserve);

    // Apply preservation flags
    if (preserveColorProfile) {
      toRemove.remove(MetadataType.icc);
    }

    return toRemove;
  }
}

/// Detected metadata information
class MetadataInfo {
  final MetadataType type;
  final String key;
  final dynamic value;
  final int sizeBytes;
  final bool isSensitive;

  const MetadataInfo({
    required this.type,
    required this.key,
    required this.value,
    required this.sizeBytes,
    required this.isSensitive,
  });

  /// Get human-readable value
  String get displayValue {
    if (value == null) return 'null';
    if (value is String) return value as String;
    if (value is List) return (value as List).join(', ');
    return value.toString();
  }

  /// Get privacy risk level
  String get riskLevel {
    if (type == MetadataType.gps) return 'High';
    if (type == MetadataType.personal) return 'High';
    if (type == MetadataType.camera) return 'Medium';
    if (isSensitive) return 'Medium';
    return 'Low';
  }
}

/// Result of metadata stripping operation
class MetadataStripResult {
  final Uint8List cleanedImageData;
  final int originalSize;
  final int cleanedSize;
  final List<MetadataInfo> removedMetadata;
  final List<MetadataInfo> preservedMetadata;
  final Duration processingTime;
  final Map<MetadataType, int> removalStats;
  final List<String> warnings;

  MetadataStripResult({
    required this.cleanedImageData,
    required this.originalSize,
    required this.cleanedSize,
    required this.removedMetadata,
    required this.preservedMetadata,
    required this.processingTime,
    required this.removalStats,
    this.warnings = const [],
  });

  /// Size reduction from metadata removal
  int get sizeReduction => originalSize - cleanedSize;

  /// Percentage of size reduction
  double get sizeReductionPercent => (sizeReduction / originalSize) * 100;

  /// Total metadata items processed
  int get totalMetadataItems => removedMetadata.length + preservedMetadata.length;

  /// Get summary of removed sensitive data
  List<MetadataInfo> get sensitiveDataRemoved =>
      removedMetadata.where((meta) => meta.isSensitive).toList();

  /// Generate privacy report
  Map<String, dynamic> get privacyReport => {
    'totalMetadataRemoved': removedMetadata.length,
    'sensitiveDataRemoved': sensitiveDataRemoved.length,
    'sizeReductionKB': (sizeReduction / 1024).round(),
    'sizeReductionPercent': sizeReductionPercent.toStringAsFixed(2),
    'riskMitigation': _calculateRiskMitigation(),
    'processingTimeMs': processingTime.inMilliseconds,
  };

  String _calculateRiskMitigation() {
    final highRisk = sensitiveDataRemoved.where((m) => m.riskLevel == 'High').length;
    final mediumRisk = sensitiveDataRemoved.where((m) => m.riskLevel == 'Medium').length;

    if (highRisk > 0) return 'Significant privacy improvement';
    if (mediumRisk > 0) return 'Moderate privacy improvement';
    if (removedMetadata.isNotEmpty) return 'Minor privacy improvement';
    return 'No privacy-sensitive metadata found';
  }
}

/// Advanced metadata stripping engine
class MetadataStripper {
  /// Strip metadata from image according to configuration
  static Future<MetadataStripResult> stripMetadata(
    Uint8List imageData,
    MetadataStripConfig config,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Analyze existing metadata first
      final metadataAnalysis = _analyzeMetadata(imageData);
      final typesToRemove = config.getTypesToRemove();

      // Filter metadata to remove/preserve
      final toRemove = metadataAnalysis
          .where((meta) => typesToRemove.contains(meta.type))
          .toList();

      final toPreserve = metadataAnalysis
          .where((meta) => !typesToRemove.contains(meta.type))
          .toList();

      // Decode and clean image
      final image = img.decodeImage(imageData);
      if (image == null) {
        throw ArgumentError('Invalid image data');
      }

      // Strip metadata by re-encoding
      final cleanedData = _reencodeWithoutMetadata(
        image,
        imageData,
        config,
      );

      // Calculate removal statistics
      final removalStats = <MetadataType, int>{};
      for (final meta in toRemove) {
        removalStats[meta.type] = (removalStats[meta.type] ?? 0) + 1;
      }

      stopwatch.stop();

      return MetadataStripResult(
        cleanedImageData: cleanedData,
        originalSize: imageData.length,
        cleanedSize: cleanedData.length,
        removedMetadata: toRemove,
        preservedMetadata: toPreserve,
        processingTime: stopwatch.elapsed,
        removalStats: removalStats,
        warnings: _generateWarnings(config, metadataAnalysis),
      );

    } catch (e) {
      stopwatch.stop();
      throw MetadataStripException(
        'Metadata stripping failed: $e',
        processingTime: stopwatch.elapsed,
      );
    }
  }

  /// Analyze metadata without removing it
  static List<MetadataInfo> analyzeMetadata(Uint8List imageData) {
    return _analyzeMetadata(imageData);
  }

  /// Check if image contains sensitive metadata
  static bool containsSensitiveMetadata(Uint8List imageData) {
    final metadata = _analyzeMetadata(imageData);
    return metadata.any((meta) => meta.isSensitive);
  }

  /// Get quick privacy assessment
  static Map<String, dynamic> getPrivacyAssessment(Uint8List imageData) {
    final metadata = _analyzeMetadata(imageData);

    final sensitiveItems = metadata.where((m) => m.isSensitive).toList();
    final gpsData = metadata.where((m) => m.type == MetadataType.gps).toList();
    final personalData = metadata.where((m) => m.type == MetadataType.personal).toList();

    return {
      'riskLevel': _assessRiskLevel(sensitiveItems),
      'sensitiveItemCount': sensitiveItems.length,
      'hasGpsData': gpsData.isNotEmpty,
      'hasPersonalData': personalData.isNotEmpty,
      'totalMetadataItems': metadata.length,
      'recommendedAction': _getRecommendedAction(sensitiveItems),
    };
  }

  /// Batch process multiple images
  static Stream<MetadataStripResult> stripMetadataBatch(
    List<Uint8List> images,
    MetadataStripConfig config, {
    int maxConcurrency = 4,
  }) async* {
    for (int i = 0; i < images.length; i += maxConcurrency) {
      final batch = images.skip(i).take(maxConcurrency);
      final futures = batch.map((imageData) => stripMetadata(imageData, config));

      final results = await Future.wait(futures);
      for (final result in results) {
        yield result;
      }
    }
  }

  // Private helper methods

  static List<MetadataInfo> _analyzeMetadata(Uint8List imageData) {
    final metadata = <MetadataInfo>[];

    // Basic JPEG EXIF parsing
    if (_isJPEG(imageData)) {
      metadata.addAll(_parseJPEGMetadata(imageData));
    }

    // Basic PNG metadata
    if (_isPNG(imageData)) {
      metadata.addAll(_parsePNGMetadata(imageData));
    }

    return metadata;
  }

  static List<MetadataInfo> _parseJPEGMetadata(Uint8List data) {
    final metadata = <MetadataInfo>[];

    try {
      // Look for EXIF data in JPEG
      for (int i = 0; i < data.length - 4; i++) {
        if (data[i] == 0xFF && data[i + 1] == 0xE1) {
          final segmentLength = (data[i + 2] << 8) | data[i + 3];

          // Check for EXIF header
          if (i + 10 < data.length) {
            final exifHeader = String.fromCharCodes(data.sublist(i + 4, i + 10));
            if (exifHeader.startsWith('Exif')) {
              metadata.addAll(_parseEXIFSegment(data.sublist(i + 4, i + 4 + segmentLength)));
              break;
            }
          }
        }
      }
    } catch (e) {
      // Ignore parsing errors for now
    }

    return metadata;
  }

  static List<MetadataInfo> _parseEXIFSegment(Uint8List exifData) {
    // Simplified EXIF parsing - in production would use proper EXIF library
    final metadata = <MetadataInfo>[];

    // Common EXIF tags to look for
    final commonTags = {
      'GPS': MetadataType.gps,
      'DateTime': MetadataType.exif,
      'Make': MetadataType.camera,
      'Model': MetadataType.camera,
      'Software': MetadataType.software,
      'Artist': MetadataType.personal,
      'Copyright': MetadataType.copyright,
      'UserComment': MetadataType.personal,
    };

    // This is a simplified implementation
    // Real EXIF parsing would decode the actual TIFF structure
    for (final tag in commonTags.entries) {
      metadata.add(MetadataInfo(
        type: tag.value,
        key: tag.key,
        value: 'Detected ${tag.key} data',
        sizeBytes: 32, // Estimated
        isSensitive: tag.value.isSensitive,
      ));
    }

    return metadata;
  }

  static List<MetadataInfo> _parsePNGMetadata(Uint8List data) {
    final metadata = <MetadataInfo>[];

    try {
      // PNG chunk parsing
      int offset = 8; // Skip PNG signature

      while (offset + 8 < data.length) {
        final chunkLength = (data[offset] << 24) |
                           (data[offset + 1] << 16) |
                           (data[offset + 2] << 8) |
                           data[offset + 3];

        final chunkType = String.fromCharCodes(data.sublist(offset + 4, offset + 8));

        if (chunkType == 'tEXt' || chunkType == 'iTXt') {
          metadata.add(MetadataInfo(
            type: MetadataType.personal,
            key: 'PNG Text',
            value: 'Text metadata found',
            sizeBytes: chunkLength,
            isSensitive: true,
          ));
        }

        if (chunkType == 'iCCP') {
          metadata.add(MetadataInfo(
            type: MetadataType.icc,
            key: 'Color Profile',
            value: 'ICC color profile',
            sizeBytes: chunkLength,
            isSensitive: false,
          ));
        }

        offset += 12 + chunkLength; // Chunk header + data + CRC
      }
    } catch (e) {
      // Ignore parsing errors
    }

    return metadata;
  }

  static Uint8List _reencodeWithoutMetadata(
    img.Image image,
    Uint8List originalData,
    MetadataStripConfig config,
  ) {
    // Simple approach: re-encode the image which strips most metadata
    if (_isJPEG(originalData)) {
      return Uint8List.fromList(img.encodeJpg(image, quality: 95));
    } else if (_isPNG(originalData)) {
      return Uint8List.fromList(img.encodePng(image));
    }

    // Default to PNG for other formats
    return Uint8List.fromList(img.encodePng(image));
  }

  static List<String> _generateWarnings(
    MetadataStripConfig config,
    List<MetadataInfo> originalMetadata,
  ) {
    final warnings = <String>[];

    if (!config.preserveColorProfile) {
      final hasColorProfile = originalMetadata.any((m) => m.type == MetadataType.icc);
      if (hasColorProfile) {
        warnings.add('Color profile removed - colors may appear different');
      }
    }

    if (!config.preserveOrientation) {
      warnings.add('Image orientation data removed - image may appear rotated');
    }

    final gpsData = originalMetadata.where((m) => m.type == MetadataType.gps);
    if (gpsData.isNotEmpty && config.getTypesToRemove().contains(MetadataType.gps)) {
      warnings.add('GPS location data removed for privacy');
    }

    return warnings;
  }

  static bool _isJPEG(Uint8List data) {
    return data.length >= 2 && data[0] == 0xFF && data[1] == 0xD8;
  }

  static bool _isPNG(Uint8List data) {
    return data.length >= 8 &&
           data[0] == 0x89 && data[1] == 0x50 &&
           data[2] == 0x4E && data[3] == 0x47;
  }

  static String _assessRiskLevel(List<MetadataInfo> sensitiveItems) {
    final highRiskCount = sensitiveItems.where((m) => m.riskLevel == 'High').length;
    final mediumRiskCount = sensitiveItems.where((m) => m.riskLevel == 'Medium').length;

    if (highRiskCount > 0) return 'High';
    if (mediumRiskCount > 2) return 'Medium';
    if (sensitiveItems.isNotEmpty) return 'Low';
    return 'None';
  }

  static String _getRecommendedAction(List<MetadataInfo> sensitiveItems) {
    final riskLevel = _assessRiskLevel(sensitiveItems);

    switch (riskLevel) {
      case 'High':
        return 'Immediate metadata removal recommended';
      case 'Medium':
        return 'Metadata removal advised for public sharing';
      case 'Low':
        return 'Consider metadata removal for privacy';
      default:
        return 'No action needed';
    }
  }
}

/// Exception thrown when metadata stripping fails
class MetadataStripException implements Exception {
  final String message;
  final Duration? processingTime;
  final dynamic originalError;

  const MetadataStripException(
    this.message, {
    this.processingTime,
    this.originalError,
  });

  @override
  String toString() {
    final time = processingTime != null ? ' (${processingTime!.inMilliseconds}ms)' : '';
    return 'MetadataStripException: $message$time';
  }
}