/// Image Reducer Service - Basic image operations

import 'dart:typed_data';

class ImageReducerService {
  static Future<Uint8List> compressImage(Uint8List imageData, int quality) async {
    // Mock implementation for MVP
    return imageData;
  }

  static Future<List<Uint8List>> compressBatch(List<Uint8List> images, int quality) async {
    return images;
  }
}
