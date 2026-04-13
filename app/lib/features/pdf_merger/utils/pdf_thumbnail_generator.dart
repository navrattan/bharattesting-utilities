import 'dart:typed_data';
import 'package:pdfx/pdfx.dart' as px;
import '../models/pdf_merger_state.dart';

/// Utility class for generating PDF page thumbnails
class PdfThumbnailGenerator {
  static const int thumbnailWidth = 300; // Better quality for web

  /// Generate thumbnails for all pages in a PDF
  static Future<List<Uint8List>> generate(Uint8List pdfData) async {
    final List<Uint8List> thumbnails = [];
    
    try {
      final document = await px.PdfDocument.openData(pdfData);
      final pageCount = document.pagesCount;
      
      for (int i = 1; i <= pageCount; i++) {
        final page = await document.getPage(i);
        final pageImage = await page.render(
          width: page.width,
          height: page.height,
          format: px.PdfPageImageFormat.jpeg,
          quality: 70,
        );
        
        if (pageImage?.bytes != null) {
          thumbnails.add(pageImage!.bytes);
        }
        await page.close();
      }
      
      await document.close();
    } catch (e) {
      print('Error generating thumbnails: $e');
    }
    
    return thumbnails;
  }

  /// Get page count only
  static Future<int> getPageCount(Uint8List pdfData) async {
    try {
      final document = await px.PdfDocument.openData(pdfData);
      final count = document.pagesCount;
      await document.close();
      return count;
    } catch (e) {
      return 0;
    }
  }
}
