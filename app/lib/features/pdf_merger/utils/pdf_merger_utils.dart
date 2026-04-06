import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Utility functions for PDF merger operations
class PdfMergerUtils {
  /// Generate output filename for merged PDF
  static String generateOutputFileName(List<String> documentNames) {
    if (documentNames.isEmpty) {
      return _getTimestampedName('merged_document');
    }

    if (documentNames.length == 1) {
      return _getTimestampedName('${documentNames.first}_merged');
    }

    if (documentNames.length <= 3) {
      final baseName = documentNames.join('_');
      if (baseName.length <= 50) {
        return _getTimestampedName(baseName);
      }
    }

    return _getTimestampedName('merged_${documentNames.length}_documents');
  }

  /// Download PDF file (platform-specific implementation)
  static Future<void> downloadPdf({
    required Uint8List data,
    required String fileName,
  }) async {
    if (kIsWeb) {
      await _downloadWebFile(data, fileName);
    } else {
      await _downloadMobileFile(data, fileName);
    }
  }

  /// Validate PDF merge constraints
  static ValidationResult validateMergeConstraints({
    required int documentCount,
    required int pageCount,
    required int totalSize,
  }) {
    const maxDocuments = 20;
    const maxPages = 2000;
    const maxSize = 100 * 1024 * 1024; // 100MB

    if (documentCount == 0) {
      return ValidationResult.error('No documents to merge');
    }

    if (documentCount > maxDocuments) {
      return ValidationResult.error('Too many documents (max $maxDocuments)');
    }

    if (pageCount > maxPages) {
      return ValidationResult.error('Too many pages (max $maxPages)');
    }

    if (totalSize > maxSize) {
      final sizeMB = (maxSize / (1024 * 1024)).round();
      return ValidationResult.error('Total size too large (max ${sizeMB}MB)');
    }

    return ValidationResult.success();
  }

  /// Estimate merge operation duration
  static Duration estimateMergeTime(int pageCount, int totalSize) {
    // Base time per page (in milliseconds)
    const baseTimePerPage = 100;

    // Additional time based on file size (in milliseconds per MB)
    const timePerMB = 50;

    final pageTime = pageCount * baseTimePerPage;
    final sizeTime = (totalSize / (1024 * 1024)) * timePerMB;

    final totalMs = (pageTime + sizeTime).round();
    return Duration(milliseconds: totalMs);
  }

  /// Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Generate a timestamped filename
  static String _getTimestampedName(String baseName) {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';

    // Clean up the base name
    final cleanBaseName = baseName
        .replaceAll(RegExp(r'[^\w\-_.]'), '_')
        .replaceAll(RegExp(r'_{2,}'), '_')
        .toLowerCase();

    return '${cleanBaseName}_$timestamp.pdf';
  }

  /// Web-specific download implementation
  static Future<void> _downloadWebFile(Uint8List data, String fileName) async {
    // In a real implementation, this would use dart:html to create a blob URL
    // and trigger download via an anchor element
    throw UnsupportedError('Web download not implemented in this demo');
  }

  /// Mobile-specific download implementation
  static Future<void> _downloadMobileFile(Uint8List data, String fileName) async {
    // In a real implementation, this would use path_provider to get the
    // downloads directory and share_plus to share the file
    throw UnsupportedError('Mobile download not implemented in this demo');
  }

  /// Clean up temporary files and resources
  static Future<void> cleanup() async {
    // Implement cleanup of temporary files, cached thumbnails, etc.
  }

  /// Calculate compression ratio
  static double calculateCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0.0;
    return ((originalSize - compressedSize) / originalSize * 100);
  }

  /// Validate filename for PDF output
  static String sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'_{2,}'), '_')
        .trim();
  }
}

/// Result of validation operations
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.success() => const ValidationResult._(true, null);

  factory ValidationResult.error(String message) =>
      ValidationResult._(false, message);
}

/// Constants for PDF merger operations
class PdfMergerConstants {
  static const int maxDocuments = 20;
  static const int maxPages = 2000;
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const int thumbnailWidth = 150;
  static const int thumbnailHeight = 200;
  static const Duration cacheTimeout = Duration(hours: 1);

  // Supported formats
  static const List<String> supportedExtensions = ['pdf'];
  static const String supportedMimeType = 'application/pdf';
}