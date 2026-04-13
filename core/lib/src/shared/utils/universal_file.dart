import 'dart:typed_data';
import 'package:flutter/foundation.dart';

// Conditional imports for Web/Mobile
// Note: In real Flutter projects, we use 'conditional imports' 
// to prevent compilation errors.
// For this environment, we will use kIsWeb checks and standard logic.

class UniversalFile {
  /// Create a Blob from bytes (Web only)
  static dynamic createBlob(Uint8List bytes, String mimeType) {
    if (!kIsWeb) return null;
    // In actual code, this would use dart:html Blob
    return bytes; 
  }

  /// Create a URL from Blob (Web only)
  static String createBlobUrl(dynamic blob) {
    if (!kIsWeb) return '';
    // In actual code, this would use Url.createObjectUrlFromBlob
    return 'blob:data';
  }

  /// Trigger a file download
  static Future<void> downloadFromUrl(String url, String fileName) async {
    if (kIsWeb) {
      // Use anchor element approach
      print('Web Download: $fileName');
    } else {
      // Use share_plus or local save
      print('Mobile Download: $fileName');
    }
  }

  /// Direct byte download
  static Future<void> downloadBytes(Uint8List bytes, String fileName, {String mimeType = 'application/octet-stream'}) async {
    // This is the primary method to use across the app
    if (kIsWeb) {
      // Actual implementation would use anchor tag
      // For now, logging to confirm logic flow
      print('Downloading $fileName (${bytes.length} bytes) on Web');
    } else {
      print('Downloading $fileName on Mobile');
    }
  }
}
