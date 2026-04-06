/// GSTIN (Goods and Services Tax Identification Number) generator
///
/// GSTIN format: 15 characters - SSAAAAA9999AEZ0
/// - SS (Pos 1-2): State code (01-36, some reserved)
/// - AAAAA9999A (Pos 3-12): Valid PAN of the business entity
/// - E (Pos 13): Entity code (A-Z, 0-9)
/// - Z (Pos 14): Always 'Z' (reserved for future use)
/// - 0 (Pos 15): Check digit calculated using Luhn Mod-36 algorithm
library gstin_generator;

import 'dart:math';
import '../checksums/luhn_mod36.dart';
import '../data/state_codes.dart';
import 'pan_generator.dart';

/// Entity codes for GSTIN (13th character)
enum GSTINEntityCode {
  /// Regular business entity (most common)
  regular('A', 'Regular Business Entity'),

  /// Branch/Division
  branch('B', 'Branch/Division'),

  /// Casual taxable person
  casual('C', 'Casual Taxable Person'),

  /// Deemed export
  deemedExport('D', 'Deemed Export'),

  /// E-commerce operator
  ecommerce('E', 'E-commerce Operator'),

  /// First registration within state
  first('F', 'First Registration'),

  /// Government department
  government('G', 'Government Department'),

  /// Higher secondary/college
  education('H', 'Educational Institution'),

  /// Input service distributor
  inputService('I', 'Input Service Distributor'),

  /// Joint venture
  jointVenture('J', 'Joint Venture'),

  /// SEZ unit
  sezUnit('K', 'SEZ Unit'),

  /// Legal entity
  legal('L', 'Legal Entity'),

  /// Migration
  migration('M', 'Migration'),

  /// Non-resident taxable person
  nonResident('N', 'Non-resident Taxable Person'),

  /// Other
  other('O', 'Other'),

  /// Public sector undertaking
  psu('P', 'Public Sector Undertaking'),

  /// Composition levy
  composition('R', 'Composition Levy'),

  /// Service provider
  service('S', 'Service Provider'),

  /// Voluntary registration
  voluntary('T', 'Voluntary Registration'),

  /// UN body/embassy
  diplomatic('U', 'UN Body/Embassy'),

  /// SEZ developer
  sezDeveloper('V', 'SEZ Developer'),

  /// Works contract
  worksContract('W', 'Works Contract'),

  /// Tax deductor
  taxDeductor('X', 'Tax Deductor'),

  /// Warehouse
  warehouse('Y', 'Warehouse'),

  /// Online service provider
  onlineService('Z', 'Online Service Provider'),

  /// Numeric entity codes (0-9) for special cases
  numeric0('0', 'Special Entity 0'),
  numeric1('1', 'Special Entity 1'),
  numeric2('2', 'Special Entity 2'),
  numeric3('3', 'Special Entity 3'),
  numeric4('4', 'Special Entity 4'),
  numeric5('5', 'Special Entity 5'),
  numeric6('6', 'Special Entity 6'),
  numeric7('7', 'Special Entity 7'),
  numeric8('8', 'Special Entity 8'),
  numeric9('9', 'Special Entity 9');

  const GSTINEntityCode(this.code, this.description);

  /// Single character code for GSTIN 13th position
  final String code;

  /// Human-readable description
  final String description;

  /// Get popular entity codes for common business types
  static List<GSTINEntityCode> get popularCodes => [
        regular,
        branch,
        ecommerce,
        service,
        voluntary,
        other,
      ];
}

/// High-quality GSTIN generator with comprehensive validation
class GSTINGenerator {
  const GSTINGenerator._();

  /// Generate a valid GSTIN
  ///
  /// [stateCode] Indian state code (1-36, will be zero-padded)
  /// [pan] Valid PAN of the business entity (optional, will generate if null)
  /// [entityCode] GSTIN entity code (optional, defaults to regular business)
  /// [random] Random number generator for reproducibility
  ///
  /// Returns a 15-character GSTIN with valid checksum
  ///
  /// Example:
  /// ```dart
  /// final gstin = GSTINGenerator.generate(
  ///   stateCode: 27, // Karnataka
  ///   random: Random(42),
  /// );
  /// print(gstin); // 27ABCDE1234F1ZA (with valid checksum)
  /// ```
  static String generate({
    required int stateCode,
    String? pan,
    GSTINEntityCode? entityCode,
    required Random random,
  }) {
    // Validate state code
    if (!StateCodes.isValidGSTINStateCode(stateCode)) {
      throw ArgumentError(
        'Invalid state code: $stateCode. Must be 1-36 (excluding 37)',
      );
    }

    // Format state code with leading zero if needed
    final stateCodeStr = stateCode.toString().padLeft(2, '0');

    // Generate or validate PAN
    final businessPAN = pan ?? _generateBusinessPAN(random);
    if (!PANGenerator.isValidFormat(businessPAN)) {
      throw ArgumentError('Invalid PAN format: $businessPAN');
    }

    // Select entity code
    final entity = entityCode ?? _getRandomEntityCode(random);

    // Build GSTIN without checksum
    final gstinWithoutChecksum = '$stateCodeStr$businessPAN${entity.code}Z';

    // Calculate and append checksum
    final checksum = LuhnMod36Checksum.calculateCheckDigit(gstinWithoutChecksum);
    return '$gstinWithoutChecksum$checksum';
  }

  /// Generate GSTIN from existing company details
  ///
  /// [companyName] Company name for PAN generation
  /// [stateCode] State where company is registered
  /// [entityType] Type of business entity
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final gstin = GSTINGenerator.generateFromCompany(
  ///   companyName: 'Acme Corporation',
  ///   stateCode: 9, // Uttar Pradesh
  ///   entityType: GSTINEntityCode.regular,
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromCompany({
    required String companyName,
    required int stateCode,
    GSTINEntityCode? entityType,
    required Random random,
  }) {
    // Generate PAN from company name
    final pan = PANGenerator.generateFromName(
      firstName: companyName.split(' ').first,
      lastName: companyName.split(' ').length > 1
          ? companyName.split(' ').last
          : companyName,
      entityType: PANEntityType.company,
      random: random,
    );

    return generate(
      stateCode: stateCode,
      pan: pan,
      entityCode: entityType ?? GSTINEntityCode.regular,
      random: random,
    );
  }

  /// Validate GSTIN format and checksum
  ///
  /// [gstin] The GSTIN to validate
  ///
  /// Returns true if GSTIN is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(GSTINGenerator.isValid('27ABCDE1234F1ZA'), isTrue);
  /// expect(GSTINGenerator.isValid('27ABCDE1234F1ZB'), isFalse); // Wrong checksum
  /// ```
  static bool isValid(String gstin) {
    if (gstin.length != 15) return false;

    // Validate basic format: SSAAAAA9999AEZ0
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][0-9A-Z]Z[0-9A-Z]$').hasMatch(gstin)) {
      return false;
    }

    // Validate state code
    final stateCode = int.tryParse(gstin.substring(0, 2));
    if (stateCode == null || !StateCodes.isValidGSTINStateCode(stateCode)) {
      return false;
    }

    // Validate embedded PAN
    final pan = gstin.substring(2, 12);
    if (!PANGenerator.isValidFormat(pan)) return false;

    // Validate entity code
    final entityCode = gstin[12];
    final validEntityCodes = GSTINEntityCode.values.map((e) => e.code);
    if (!validEntityCodes.contains(entityCode)) return false;

    // Validate 14th character (must be 'Z')
    if (gstin[13] != 'Z') return false;

    // Validate checksum using Luhn Mod-36
    return LuhnMod36Checksum.validateGSTIN(gstin);
  }

  /// Extract components from GSTIN
  ///
  /// [gstin] Valid GSTIN string
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = GSTINGenerator.parseGSTIN('27ABCDE1234F1ZA');
  /// print(components['stateCode']); // 27
  /// print(components['pan']); // ABCDE1234F
  /// ```
  static Map<String, dynamic>? parseGSTIN(String gstin) {
    if (!isValid(gstin)) return null;

    final stateCode = int.parse(gstin.substring(0, 2));
    final pan = gstin.substring(2, 12);
    final entityCode = gstin[12];
    final checkDigit = gstin[14];

    final entityType = GSTINEntityCode.values
        .where((type) => type.code == entityCode)
        .firstOrNull;

    return {
      'stateCode': stateCode,
      'stateName': StateCodes.getStateName(stateCode),
      'pan': pan,
      'panEntityType': PANGenerator.getEntityType(pan),
      'entityCode': entityCode,
      'entityType': entityType,
      'checkDigit': checkDigit,
      'isValid': true,
    };
  }

  /// Generate multiple GSTINs for testing/bulk operations
  ///
  /// [count] Number of GSTINs to generate
  /// [stateCode] State code (optional, random if null)
  /// [entityCode] Entity code (optional, random if null)
  /// [random] Random generator
  ///
  /// Returns list of unique valid GSTINs
  static List<String> generateBulk({
    required int count,
    int? stateCode,
    GSTINEntityCode? entityCode,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 50000) throw ArgumentError('Maximum 50,000 GSTINs per batch');

    final generated = <String>{};
    int attempts = 0;
    const maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      try {
        final state = stateCode ?? _getRandomValidStateCode(random);
        final entity = entityCode ?? _getRandomEntityCode(random);

        final gstin = generate(
          stateCode: state,
          entityCode: entity,
          random: random,
        );

        generated.add(gstin);
      } catch (e) {
        // Skip invalid combinations and continue
      }
      attempts++;
    }

    return generated.toList();
  }

  /// Generate GSTIN with migration from old tax registration
  ///
  /// [oldRegistrationNumber] Previous tax registration number
  /// [newStateCode] New state code for GSTIN
  /// [random] Random generator
  static String generateMigrationGSTIN({
    required String oldRegistrationNumber,
    required int newStateCode,
    required Random random,
  }) {
    // Generate based on migration pattern, preserving some old number characteristics
    final baseNumber = oldRegistrationNumber.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final seedFromOld = baseNumber.hashCode;
    final seededRandom = Random(seedFromOld);

    return generate(
      stateCode: newStateCode,
      entityCode: GSTINEntityCode.migration,
      random: seededRandom,
    );
  }

  /// Check if GSTIN belongs to specific state
  ///
  /// [gstin] GSTIN to check
  /// [stateCode] State code to validate against
  static bool isFromState(String gstin, int stateCode) {
    if (!isValid(gstin)) return false;
    final gstinStateCode = int.tryParse(gstin.substring(0, 2));
    return gstinStateCode == stateCode;
  }

  /// Get state information from GSTIN
  ///
  /// [gstin] Valid GSTIN
  /// Returns state name or null if invalid
  static String? getStateName(String gstin) {
    if (!isValid(gstin)) return null;
    final stateCode = int.parse(gstin.substring(0, 2));
    return StateCodes.getStateName(stateCode);
  }

  /// Generate business PAN suitable for GSTIN
  static String _generateBusinessPAN(Random random) {
    // Business entities typically use company, firm, or trust PAN types
    final businessTypes = [
      PANEntityType.company,
      PANEntityType.firm,
      PANEntityType.trust,
      PANEntityType.aop,
    ];

    final entityType = businessTypes[random.nextInt(businessTypes.length)];
    return PANGenerator.generate(entityType: entityType, random: random);
  }

  /// Get random entity code with weighted distribution
  static GSTINEntityCode _getRandomEntityCode(Random random) {
    // Weighted towards more common entity codes
    final commonCodes = [
      ...List.filled(5, GSTINEntityCode.regular), // 50% regular
      ...List.filled(2, GSTINEntityCode.branch), // 20% branch
      GSTINEntityCode.ecommerce,
      GSTINEntityCode.service,
      GSTINEntityCode.voluntary,
    ];

    return commonCodes[random.nextInt(commonCodes.length)];
  }

  /// Get random valid state code
  static int _getRandomValidStateCode(Random random) {
    final validCodes = StateCodes.getValidStateCodes();
    return validCodes[random.nextInt(validCodes.length)];
  }

  /// Get all supported entity codes
  static List<GSTINEntityCode> getSupportedEntityCodes() {
    return GSTINEntityCode.values;
  }

  /// Generate GSTIN for specific business sector
  ///
  /// [sector] Business sector (IT, Manufacturing, Trading, etc.)
  /// [stateCode] State code
  /// [random] Random generator
  static String generateForSector({
    required String sector,
    required int stateCode,
    required Random random,
  }) {
    GSTINEntityCode entityCode;

    switch (sector.toLowerCase()) {
      case 'it':
      case 'software':
      case 'technology':
        entityCode = GSTINEntityCode.service;
        break;
      case 'ecommerce':
      case 'online':
        entityCode = GSTINEntityCode.ecommerce;
        break;
      case 'manufacturing':
      case 'production':
        entityCode = GSTINEntityCode.regular;
        break;
      case 'trading':
      case 'retail':
        entityCode = GSTINEntityCode.regular;
        break;
      case 'export':
        entityCode = GSTINEntityCode.deemedExport;
        break;
      default:
        entityCode = GSTINEntityCode.regular;
    }

    return generate(
      stateCode: stateCode,
      entityCode: entityCode,
      random: random,
    );
  }
}

/// Extension on String for GSTIN utilities
extension GSTINStringExtension on String {
  /// Check if this string is a valid GSTIN
  bool get isValidGSTIN => GSTINGenerator.isValid(this);

  /// Parse GSTIN components
  Map<String, dynamic>? get gstinComponents => GSTINGenerator.parseGSTIN(this);

  /// Get state name from GSTIN
  String? get gstinStateName => GSTINGenerator.getStateName(this);

  /// Format GSTIN with spaces for display
  String get formattedGSTIN {
    if (length != 15) return this;
    return '${substring(0, 2)} ${substring(2, 7)} ${substring(7, 11)} ${substring(11, 13)} ${substring(13, 14)} ${substring(14)}';
  }

  /// Check if GSTIN is from specific state
  bool isGSTINFromState(int stateCode) => GSTINGenerator.isFromState(this, stateCode);
}

/// Extension to help with null-safety
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}