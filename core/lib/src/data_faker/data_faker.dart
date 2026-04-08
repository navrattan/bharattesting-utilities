/// Indian Data Faker - Generate valid Indian identifiers
///
/// Supports: PAN, GSTIN, Aadhaar, CIN, TAN, IFSC, UPI, Udyam, PIN Code
library data_faker;

// Core generators
export 'pan_generator.dart';
export 'gstin_generator.dart';
export 'aadhaar_generator.dart';
export 'cin_generator.dart';
export 'tan_generator.dart';
export 'ifsc_generator.dart';
export 'upi_generator.dart';
export 'udyam_generator.dart';
export 'pin_code_generator.dart';

// Templates
export 'templates/individual_template.dart';
export 'templates/company_template.dart';
export 'templates/proprietorship_template.dart';
export 'templates/partnership_template.dart';
export 'templates/trust_template.dart';

// Data and checksums
export 'data/state_codes.dart';
export 'data/bank_codes.dart';
export 'data/industry_codes.dart';
export 'checksums/verhoeff.dart';
export 'checksums/luhn_mod36.dart';

// Main facade
export 'data_faker_service.dart';
