/// BharatTesting Core Library
///
/// Pure Dart package containing all business logic for the 5 developer tools:
/// - Indian Data Faker (9 identifiers + 5 templates)
/// - String-to-JSON Converter
/// - Image Size Reducer
/// - PDF Merger
/// - Document Scanner
///
/// This library is 100% offline and does not depend on Flutter.

library core;

// JSON Converter - Auto-repair and multi-format parsing
export 'src/json_converter/json_converter.dart';

// Document Scanner - Computer vision pipeline for document digitization
export 'src/document_scanner/edge_detector.dart';
export 'src/document_scanner/perspective_corrector.dart';
export 'src/document_scanner/image_enhancer.dart';
export 'src/document_scanner/ocr_processor.dart';
