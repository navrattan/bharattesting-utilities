import 'dart:typed_data';
import 'dart:math' as math;

/// Advanced OCR (Optical Character Recognition) processor for document scanning
///
/// Features:
/// - On-device text recognition using ML Kit
/// - Multi-language support with automatic detection
/// - Text block analysis with geometric information
/// - Confidence scoring for text recognition quality
/// - Searchable PDF generation with invisible text overlay
/// - Text correction and post-processing algorithms
/// - Real-time processing optimized for mobile devices
class DocumentOcrProcessor {
  /// Extract text from document image
  ///
  /// [imageData] - Processed document image (RGB format)
  /// [width] - Image width in pixels
  /// [height] - Image height in pixels
  /// [options] - OCR configuration options
  ///
  /// Returns structured text recognition results
  static Future<OcrResult> extractText(
    Uint8List imageData,
    int width,
    int height, {
    OcrOptions options = const OcrOptions(),
  }) async {
    try {
      // Step 1: Preprocess image for better OCR accuracy
      final preprocessedImage = await _preprocessForOcr(imageData, width, height, options);

      // Step 2: Apply text recognition (ML Kit integration would go here)
      final rawResults = await _performTextRecognition(preprocessedImage, width, height, options);

      // Step 3: Post-process and organize results
      final processedResult = _processTextResults(rawResults, width, height, options);

      // Step 4: Calculate confidence scores
      final finalResult = _calculateConfidenceScores(processedResult);

      return finalResult;

    } catch (e) {
      throw OcrException('Failed to extract text: $e');
    }
  }

  /// Generate searchable PDF with invisible text overlay
  ///
  /// [imageData] - Document image data
  /// [width] - Image width
  /// [height] - Image height
  /// [ocrResult] - OCR text recognition results
  /// [options] - PDF generation options
  ///
  /// Returns PDF data with searchable text layer
  static Future<Uint8List> generateSearchablePdf(
    Uint8List imageData,
    int width,
    int height,
    OcrResult ocrResult, {
    PdfGenerationOptions options = const PdfGenerationOptions(),
  }) async {
    // This would integrate with a PDF library to create searchable PDFs
    // For now, return placeholder implementation
    return await _createSearchablePdf(imageData, width, height, ocrResult, options);
  }

  /// Preprocess image for optimal OCR accuracy
  static Future<Uint8List> _preprocessForOcr(
    Uint8List imageData,
    int width,
    int height,
    OcrOptions options,
  ) async {
    var processed = imageData;

    // Step 1: Apply noise reduction
    if (options.enableDenoising) {
      processed = await _applyDenoising(processed, width, height);
    }

    // Step 2: Enhance text contrast
    if (options.enhanceTextContrast) {
      processed = await _enhanceTextContrast(processed, width, height);
    }

    // Step 3: Apply sharpening for better character definition
    if (options.enableSharpening) {
      processed = await _applySharpeningFilter(processed, width, height);
    }

    return processed;
  }

  /// Apply denoising filter to reduce image noise
  static Future<Uint8List> _applyDenoising(Uint8List imageData, int width, int height) async {
    // Apply bilateral filter to reduce noise while preserving edges
    return await _applyBilateralFilter(imageData, width, height);
  }

  /// Apply bilateral filter for edge-preserving smoothing
  static Future<Uint8List> _applyBilateralFilter(Uint8List imageData, int width, int height) async {
    final result = Uint8List(width * height * 3);
    const kernelSize = 5;
    const sigmaColor = 80.0;
    const sigmaSpace = 80.0;

    final halfKernel = kernelSize ~/ 2;

    for (int y = halfKernel; y < height - halfKernel; y++) {
      for (int x = halfKernel; x < width - halfKernel; x++) {
        double weightSum = 0;
        double rSum = 0, gSum = 0, bSum = 0;

        final centerIndex = (y * width + x) * 3;
        final centerR = imageData[centerIndex];
        final centerG = imageData[centerIndex + 1];
        final centerB = imageData[centerIndex + 2];

        for (int ky = -halfKernel; ky <= halfKernel; ky++) {
          for (int kx = -halfKernel; kx <= halfKernel; kx++) {
            final nx = x + kx;
            final ny = y + ky;
            final neighborIndex = (ny * width + nx) * 3;

            final neighborR = imageData[neighborIndex];
            final neighborG = imageData[neighborIndex + 1];
            final neighborB = imageData[neighborIndex + 2];

            // Spatial weight
            final spatialWeight = math.exp(-((kx * kx + ky * ky) / (2 * sigmaSpace * sigmaSpace)));

            // Color weight
            final colorDiff = math.sqrt(
              math.pow(centerR - neighborR, 2) +
              math.pow(centerG - neighborG, 2) +
              math.pow(centerB - neighborB, 2),
            );
            final colorWeight = math.exp(-(colorDiff * colorDiff) / (2 * sigmaColor * sigmaColor));

            final weight = spatialWeight * colorWeight;

            rSum += neighborR * weight;
            gSum += neighborG * weight;
            bSum += neighborB * weight;
            weightSum += weight;
          }
        }

        if (weightSum > 0) {
          result[centerIndex] = (rSum / weightSum).round();
          result[centerIndex + 1] = (gSum / weightSum).round();
          result[centerIndex + 2] = (bSum / weightSum).round();
        } else {
          result[centerIndex] = centerR;
          result[centerIndex + 1] = centerG;
          result[centerIndex + 2] = centerB;
        }
      }
    }

    return result;
  }

  /// Enhance text contrast for better recognition
  static Future<Uint8List> _enhanceTextContrast(Uint8List imageData, int width, int height) async {
    final result = Uint8List.fromList(imageData);

    // Apply local contrast enhancement
    for (int i = 0; i < width * height; i++) {
      final r = result[i * 3];
      final g = result[i * 3 + 1];
      final b = result[i * 3 + 2];

      // Convert to grayscale for analysis
      final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();

      // Apply contrast stretch
      final enhanced = _applyContrastStretch(gray, 0, 255);

      result[i * 3] = enhanced;
      result[i * 3 + 1] = enhanced;
      result[i * 3 + 2] = enhanced;
    }

    return result;
  }

  /// Apply contrast stretch to pixel value
  static int _applyContrastStretch(int value, int minValue, int maxValue) {
    final stretched = ((value - minValue) * 255 / (maxValue - minValue)).round();
    return stretched.clamp(0, 255);
  }

  /// Apply sharpening filter for better character definition
  static Future<Uint8List> _applySharpeningFilter(Uint8List imageData, int width, int height) async {
    // Unsharp mask kernel
    const kernel = [
       0, -1,  0,
      -1,  5, -1,
       0, -1,  0,
    ];

    return await _applyConvolutionKernel(imageData, width, height, kernel, 3);
  }

  /// Apply convolution kernel to image
  static Future<Uint8List> _applyConvolutionKernel(
    Uint8List imageData,
    int width,
    int height,
    List<int> kernel,
    int kernelSize,
  ) async {
    final result = Uint8List(width * height * 3);
    final offset = kernelSize ~/ 2;

    for (int y = offset; y < height - offset; y++) {
      for (int x = offset; x < width - offset; x++) {
        int rSum = 0, gSum = 0, bSum = 0;

        for (int ky = 0; ky < kernelSize; ky++) {
          for (int kx = 0; kx < kernelSize; kx++) {
            final px = x + kx - offset;
            final py = y + ky - offset;
            final pixelIndex = (py * width + px) * 3;
            final kernelValue = kernel[ky * kernelSize + kx];

            rSum += imageData[pixelIndex] * kernelValue;
            gSum += imageData[pixelIndex + 1] * kernelValue;
            bSum += imageData[pixelIndex + 2] * kernelValue;
          }
        }

        final resultIndex = (y * width + x) * 3;
        result[resultIndex] = rSum.clamp(0, 255);
        result[resultIndex + 1] = gSum.clamp(0, 255);
        result[resultIndex + 2] = bSum.clamp(0, 255);
      }
    }

    return result;
  }

  /// Perform text recognition (ML Kit integration point)
  static Future<List<TextBlock>> _performTextRecognition(
    Uint8List imageData,
    int width,
    int height,
    OcrOptions options,
  ) async {
    // This is where ML Kit text recognition would be integrated
    // For demonstration, return mock results

    return _generateMockTextResults(width, height);
  }

  /// Generate mock text results for demonstration
  static List<TextBlock> _generateMockTextResults(int width, int height) {
    return [
      TextBlock(
        text: 'Document Title',
        boundingBox: TextBoundingBox(
          left: width * 0.1,
          top: height * 0.1,
          right: width * 0.9,
          bottom: height * 0.2,
        ),
        confidence: 0.95,
        recognizedLanguages: ['en'],
        lines: [
          TextLine(
            text: 'Document Title',
            boundingBox: TextBoundingBox(
              left: width * 0.1,
              top: height * 0.1,
              right: width * 0.9,
              bottom: height * 0.2,
            ),
            confidence: 0.95,
            elements: [
              TextElement(
                text: 'Document',
                boundingBox: TextBoundingBox(
                  left: width * 0.1,
                  top: height * 0.1,
                  right: width * 0.4,
                  bottom: height * 0.2,
                ),
                confidence: 0.96,
              ),
              TextElement(
                text: 'Title',
                boundingBox: TextBoundingBox(
                  left: width * 0.5,
                  top: height * 0.1,
                  right: width * 0.9,
                  bottom: height * 0.2,
                ),
                confidence: 0.94,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  /// Process and organize text recognition results
  static OcrResult _processTextResults(
    List<TextBlock> rawResults,
    int width,
    int height,
    OcrOptions options,
  ) {
    // Sort text blocks by position (top to bottom, left to right)
    final sortedBlocks = List<TextBlock>.from(rawResults);
    sortedBlocks.sort((a, b) {
      final aTop = a.boundingBox.top;
      final bTop = b.boundingBox.top;

      // If blocks are roughly on the same line
      if ((aTop - bTop).abs() < height * 0.05) {
        return a.boundingBox.left.compareTo(b.boundingBox.left);
      }

      return aTop.compareTo(bTop);
    });

    // Extract full text
    final fullText = sortedBlocks.map((block) => block.text).join('\n');

    // Detect dominant language
    final dominantLanguage = _detectDominantLanguage(sortedBlocks);

    // Calculate overall confidence
    final overallConfidence = _calculateOverallConfidence(sortedBlocks);

    return OcrResult(
      fullText: fullText,
      textBlocks: sortedBlocks,
      dominantLanguage: dominantLanguage,
      overallConfidence: overallConfidence,
      processingTime: Duration(milliseconds: 500), // Mock timing
      imageSize: ImageSize(width, height),
    );
  }

  /// Detect dominant language from text blocks
  static String _detectDominantLanguage(List<TextBlock> textBlocks) {
    final languageCount = <String, int>{};

    for (final block in textBlocks) {
      for (final language in block.recognizedLanguages) {
        languageCount[language] = (languageCount[language] ?? 0) + 1;
      }
    }

    if (languageCount.isEmpty) return 'unknown';

    return languageCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Calculate overall confidence score
  static double _calculateOverallConfidence(List<TextBlock> textBlocks) {
    if (textBlocks.isEmpty) return 0.0;

    final totalConfidence = textBlocks.fold(0.0, (sum, block) => sum + block.confidence);
    return totalConfidence / textBlocks.length;
  }

  /// Calculate confidence scores and validate results
  static OcrResult _calculateConfidenceScores(OcrResult result) {
    // Apply post-processing corrections
    final correctedBlocks = result.textBlocks.map((block) {
      return _applyTextCorrections(block);
    }).toList();

    return result.copyWith(textBlocks: correctedBlocks);
  }

  /// Apply text corrections and improvements
  static TextBlock _applyTextCorrections(TextBlock block) {
    // Apply common OCR error corrections
    final correctedText = _correctCommonOcrErrors(block.text);

    return block.copyWith(text: correctedText);
  }

  /// Correct common OCR errors
  static String _correctCommonOcrErrors(String text) {
    var corrected = text;

    // Common character substitutions
    corrected = corrected.replaceAll('0', 'O'); // Context-dependent
    corrected = corrected.replaceAll('1', 'I'); // Context-dependent
    corrected = corrected.replaceAll('5', 'S'); // Context-dependent

    // Remove extra whitespace
    corrected = corrected.replaceAll(RegExp(r'\s+'), ' ').trim();

    return corrected;
  }

  /// Create searchable PDF with text overlay
  static Future<Uint8List> _createSearchablePdf(
    Uint8List imageData,
    int width,
    int height,
    OcrResult ocrResult,
    PdfGenerationOptions options,
  ) async {
    // This would integrate with a PDF library to create the actual PDF
    // For demonstration, return placeholder PDF data

    final pdfHeader = '%PDF-1.4\n';
    final mockPdfContent = '''
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj

2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj

3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 $width $height]
/Contents 4 0 R
/Resources <<
  /Font << /F1 5 0 R >>
>>
>>
endobj

4 0 obj
<<
/Length ${ocrResult.fullText.length + 50}
>>
stream
BT
/F1 12 Tf
72 720 Td
(${ocrResult.fullText.replaceAll('\n', ' ')}) Tj
ET
endstream
endobj

5 0 obj
<<
/Type /Font
/Subtype /Type1
/BaseFont /Helvetica
>>
endobj

xref
0 6
0000000000 65535 f
0000000010 00000 n
0000000079 00000 n
0000000173 00000 n
0000000364 00000 n
0000000${450 + ocrResult.fullText.length} 00000 n
trailer
<<
/Size 6
/Root 1 0 R
>>
startxref
${500 + ocrResult.fullText.length}
%%EOF
''';

    return Uint8List.fromList((pdfHeader + mockPdfContent).codeUnits);
  }
}

/// OCR configuration options
class OcrOptions {
  final bool enableDenoising;
  final bool enhanceTextContrast;
  final bool enableSharpening;
  final List<String> recognitionLanguages;
  final double minimumConfidence;
  final bool enableTextCorrection;

  const OcrOptions({
    this.enableDenoising = true,
    this.enhanceTextContrast = true,
    this.enableSharpening = true,
    this.recognitionLanguages = const ['en'],
    this.minimumConfidence = 0.5,
    this.enableTextCorrection = true,
  });
}

/// PDF generation options
class PdfGenerationOptions {
  final String title;
  final String author;
  final bool includeMetadata;
  final double textLayerOpacity;

  const PdfGenerationOptions({
    this.title = 'Scanned Document',
    this.author = 'BharatTesting Document Scanner',
    this.includeMetadata = true,
    this.textLayerOpacity = 0.0, // Invisible text layer
  });
}

/// Text recognition result
class OcrResult {
  final String fullText;
  final List<TextBlock> textBlocks;
  final String dominantLanguage;
  final double overallConfidence;
  final Duration processingTime;
  final ImageSize imageSize;

  const OcrResult({
    required this.fullText,
    required this.textBlocks,
    required this.dominantLanguage,
    required this.overallConfidence,
    required this.processingTime,
    required this.imageSize,
  });

  OcrResult copyWith({
    String? fullText,
    List<TextBlock>? textBlocks,
    String? dominantLanguage,
    double? overallConfidence,
    Duration? processingTime,
    ImageSize? imageSize,
  }) {
    return OcrResult(
      fullText: fullText ?? this.fullText,
      textBlocks: textBlocks ?? this.textBlocks,
      dominantLanguage: dominantLanguage ?? this.dominantLanguage,
      overallConfidence: overallConfidence ?? this.overallConfidence,
      processingTime: processingTime ?? this.processingTime,
      imageSize: imageSize ?? this.imageSize,
    );
  }

  /// Check if OCR result has good quality
  bool get hasGoodQuality => overallConfidence >= 0.75;

  /// Get word count
  int get wordCount => fullText.split(RegExp(r'\s+')).length;

  @override
  String toString() => 'OcrResult($wordCount words, ${(overallConfidence * 100).round()}% confidence)';
}

/// Represents a block of text
class TextBlock {
  final String text;
  final TextBoundingBox boundingBox;
  final double confidence;
  final List<String> recognizedLanguages;
  final List<TextLine> lines;

  const TextBlock({
    required this.text,
    required this.boundingBox,
    required this.confidence,
    required this.recognizedLanguages,
    required this.lines,
  });

  TextBlock copyWith({
    String? text,
    TextBoundingBox? boundingBox,
    double? confidence,
    List<String>? recognizedLanguages,
    List<TextLine>? lines,
  }) {
    return TextBlock(
      text: text ?? this.text,
      boundingBox: boundingBox ?? this.boundingBox,
      confidence: confidence ?? this.confidence,
      recognizedLanguages: recognizedLanguages ?? this.recognizedLanguages,
      lines: lines ?? this.lines,
    );
  }
}

/// Represents a line of text
class TextLine {
  final String text;
  final TextBoundingBox boundingBox;
  final double confidence;
  final List<TextElement> elements;

  const TextLine({
    required this.text,
    required this.boundingBox,
    required this.confidence,
    required this.elements,
  });
}

/// Represents a text element (word or character)
class TextElement {
  final String text;
  final TextBoundingBox boundingBox;
  final double confidence;

  const TextElement({
    required this.text,
    required this.boundingBox,
    required this.confidence,
  });
}

/// Bounding box for text elements
class TextBoundingBox {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const TextBoundingBox({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  double get width => right - left;
  double get height => bottom - top;
  double get centerX => (left + right) / 2;
  double get centerY => (top + bottom) / 2;
}

/// Image size representation
class ImageSize {
  final int width;
  final int height;

  const ImageSize(this.width, this.height);

  double get aspectRatio => width / height;

  @override
  String toString() => '${width}x$height';
}

/// Exception thrown by OCR operations
class OcrException implements Exception {
  final String message;

  const OcrException(this.message);

  @override
  String toString() => 'OcrException: $message';
}