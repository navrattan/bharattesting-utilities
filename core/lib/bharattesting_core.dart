/// BharatTesting Core - Pure Dart business logic for all 5 tools
///
/// This package contains zero Flutter dependencies and implements:
/// - Indian Data Faker (PAN, GSTIN, Aadhaar, CIN, TAN, IFSC, UPI, Udyam, PIN)
/// - Image Size Reducer (compress, resize, format conversion)
/// - PDF Merger (merge, rotate, encrypt)
/// - String-to-JSON Converter (auto-repair, format detection)
/// - Document Scanner (edge detection, perspective correction, filters)
library bharattesting_core;

// Data Faker
export 'src/data_faker/data_faker.dart';

// Image Reducer
export 'src/image_reducer/image_reducer.dart';

// PDF Merger
export 'src/pdf_merger/pdf_merger.dart';

// JSON Converter
export 'src/json_converter/json_converter.dart';

// Document Scanner
export 'src/document_scanner/document_scanner.dart';

// Shared Utils
export 'src/shared/utils/universal_file.dart';