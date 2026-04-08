/// Advanced image reduction library - compression, resizing, format conversion
///
/// High-performance image processing with privacy-first metadata handling
library image_reducer;

// Main service (this exports the enums ImageFormat and ResizePreset)
export 'image_reducer_service.dart';

// Core image processing engines
// We hide the enums that are also in image_reducer_service to avoid collisions
export 'compressor.dart' hide ImageFormat;
export 'resizer.dart' hide ResizePreset;
export 'format_converter.dart';
export 'metadata_stripper.dart';
