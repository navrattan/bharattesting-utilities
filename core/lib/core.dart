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

// Data Faker - Checksum Algorithms
export 'src/data_faker/checksums/verhoeff.dart';
export 'src/data_faker/checksums/luhn_mod36.dart';

// Data Faker - Lookup Data
export 'src/data_faker/data/state_codes.dart';
export 'src/data_faker/data/bank_codes.dart';
export 'src/data_faker/data/industry_codes.dart';

// Data Faker - Individual Generators
export 'src/data_faker/pan_generator.dart';
export 'src/data_faker/gstin_generator.dart';
export 'src/data_faker/aadhaar_generator.dart';
export 'src/data_faker/cin_generator.dart';
export 'src/data_faker/tan_generator.dart';
export 'src/data_faker/ifsc_generator.dart';
export 'src/data_faker/upi_generator.dart';
export 'src/data_faker/udyam_generator.dart';
export 'src/data_faker/pin_code_generator.dart';
export 'src/data_faker/address_generator.dart';

// Data Faker - Templates
export 'src/data_faker/templates/individual_template.dart';
export 'src/data_faker/templates/company_template.dart';
export 'src/data_faker/templates/proprietorship_template.dart';
export 'src/data_faker/templates/partnership_template.dart';
export 'src/data_faker/templates/trust_template.dart';

// Data Faker - Export (NEW)
export 'src/data_faker/export/csv_exporter.dart';
export 'src/data_faker/export/json_exporter.dart';
export 'src/data_faker/export/xlsx_exporter.dart';

// JSON Converter - Auto-repair and multi-format parsing
export 'src/json_converter/json_converter.dart';

// Image Reducer - Compression, resizing, format conversion, metadata stripping
export 'src/image_reducer/image_reducer.dart';

// TODO: Future exports for other tools
// export 'src/pdf_merger/merger.dart';
// export 'src/document_scanner/edge_detector.dart';