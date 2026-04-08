/// CIN (Corporate Identity Number) generator for Indian companies
///
/// CIN format: LLNNNNNCCYYYYNNNNNNN (21 characters)
/// - LL (Pos 1-2): Listing status (L1-L9 for listed, U1-U9 for unlisted)
/// - NNNNN (Pos 3-7): Registration number (5 digits)
/// - CC (Pos 8-9): Industry class (NIC code, 2 digits)
/// - YYYY (Pos 10-13): Year of incorporation (4 digits)
/// - NNNNNNN (Pos 14-21): Registration sequence number (6 digits)
library cin_generator;

import 'dart:math';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';
import 'package:bharattesting_core/src/data_faker/data/industry_codes.dart';

/// Company listing status for CIN
enum CINListingStatus {
  /// Listed company (Stock Exchange)
  listed('Listed Company'),

  /// Unlisted company
  unlisted('Unlisted Company');

  const CINListingStatus(this.description);

  /// Human-readable description
  final String description;
}

/// Company type categories for realistic CIN generation
enum CINCompanyType {
  /// Private Limited Company
  privateLimited('Private Limited', 'PVT LTD'),

  /// Public Limited Company
  publicLimited('Public Limited', 'LTD'),

  /// One Person Company
  onePersonCompany('One Person Company', 'OPC'),

  /// Limited Liability Partnership
  llp('Limited Liability Partnership', 'LLP'),

  /// Section 8 Company (Non-profit)
  section8('Section 8 Company', 'SEC8'),

  /// Government Company
  government('Government Company', 'GOVT'),

  /// Foreign Company
  foreign('Foreign Company', 'FC');

  const CINCompanyType(this.description, this.suffix);

  /// Human-readable description
  final String description;

  /// Common suffix used in company names
  final String suffix;
}

/// High-quality CIN generator with comprehensive validation
class CINGenerator {
  const CINGenerator._();

  /// Valid listing status codes for different company types
  static const Map<CINCompanyType, List<String>> _listingStatusCodes = {
    CINCompanyType.privateLimited: ['U1', 'U2', 'U3', 'U4', 'U5'],
    CINCompanyType.publicLimited: ['L1', 'L2', 'L3', 'L4', 'L5', 'U1', 'U2'],
    CINCompanyType.onePersonCompany: ['U1'],
    CINCompanyType.llp: ['U6', 'U7'],
    CINCompanyType.section8: ['U8', 'U9'],
    CINCompanyType.government: ['L9', 'U9'],
    CINCompanyType.foreign: ['F1', 'F2', 'F3'],
  };

  /// Generate a valid CIN
  ///
  /// [companyType] Type of company
  /// [industryCode] NIC industry code (optional, will generate if null)
  /// [yearOfIncorporation] Year company was incorporated (1950-current year)
  /// [stateCode] State code for region-specific patterns (optional)
  /// [random] Random number generator
  ///
  /// Example:
  /// ```dart
  /// final cin = CINGenerator.generate(
  ///   companyType: CINCompanyType.privateLimited,
  ///   yearOfIncorporation: 2020,
  ///   random: Random(42),
  /// );
  /// print(cin); // U12345671202012345678
  /// ```
  static String generate({
    required CINCompanyType companyType,
    String? industryCode,
    required int yearOfIncorporation,
    int? stateCode,
    required Random random,
  }) {
    // Validate year of incorporation
    final currentYear = DateTime.now().year;
    if (yearOfIncorporation < 1950 || yearOfIncorporation > currentYear) {
      throw ArgumentError(
        'Invalid incorporation year: $yearOfIncorporation. Must be 1950-$currentYear',
      );
    }

    // Get listing status code based on company type
    final statusCodes = _listingStatusCodes[companyType]!;
    final listingStatus = statusCodes[random.nextInt(statusCodes.length)];

    // Generate registration number (5 digits)
    final registrationNumber = _generateRegistrationNumber(random, stateCode);

    // Get or generate industry code
    final industry = industryCode ?? _getIndustryCodeForCompanyType(companyType, random);
    if (!IndustryCodes.isValidIndustryCode(industry)) {
      throw ArgumentError('Invalid industry code: $industry');
    }
    final paddedIndustry = industry.padLeft(2, '0');

    // Generate sequence number (6 digits)
    final sequenceNumber = _generateSequenceNumber(random, yearOfIncorporation);

    return '$listingStatus$registrationNumber$paddedIndustry$yearOfIncorporation$sequenceNumber';
  }

  /// Generate CIN from company details
  ///
  /// [companyName] Name of the company
  /// [companyType] Type of company
  /// [businessSector] Business sector (IT, Manufacturing, etc.)
  /// [yearOfIncorporation] Year of incorporation
  /// [stateCode] State where company is registered
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final cin = CINGenerator.generateFromCompany(
  ///   companyName: 'Acme Technologies Pvt Ltd',
  ///   companyType: CINCompanyType.privateLimited,
  ///   businessSector: 'IT',
  ///   yearOfIncorporation: 2018,
  ///   stateCode: 27, // Karnataka
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromCompany({
    required String companyName,
    required CINCompanyType companyType,
    String? businessSector,
    required int yearOfIncorporation,
    int? stateCode,
    required Random random,
  }) {
    // Determine industry code from business sector
    String? industryCode;
    if (businessSector != null) {
      final sectorCodes = IndustryCodes.getIndustryCodesBySection(businessSector);
      industryCode = sectorCodes[random.nextInt(sectorCodes.length)];
    }

    return generate(
      companyType: companyType,
      industryCode: industryCode,
      yearOfIncorporation: yearOfIncorporation,
      stateCode: stateCode,
      random: random,
    );
  }

  /// Validate CIN format and structure
  ///
  /// [cin] The CIN to validate
  ///
  /// Returns true if CIN format is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(CINGenerator.isValid('U12345671202012345678'), isTrue);
  /// expect(CINGenerator.isValid('U123456712020123456'), isFalse); // Too short
  /// ```
  static bool isValid(String cin) {
    if (cin.length != 21) return false;

    // Check basic format: LLNNNNNCCYYYYNNNNNNN
    if (!RegExp(r'^[LUFG][0-9][0-9]{5}[0-9]{2}[0-9]{4}[0-9]{6}$').hasMatch(cin)) {
      return false;
    }

    // Validate listing status
    final listingStatus = cin.substring(0, 2);
    if (!_isValidListingStatus(listingStatus)) return false;

    // Validate industry code
    final industryCode = cin.substring(7, 9);
    if (!IndustryCodes.isValidIndustryCode(industryCode)) return false;

    // Validate year of incorporation
    final year = int.tryParse(cin.substring(9, 13));
    if (year == null || year < 1950 || year > DateTime.now().year) return false;

    return true;
  }

  /// Parse CIN components
  ///
  /// [cin] Valid CIN string
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = CINGenerator.parseCIN('U12345671202012345678');
  /// print(components['companyType']); // 'Unlisted'
  /// print(components['yearOfIncorporation']); // 2020
  /// ```
  static Map<String, dynamic>? parseCIN(String cin) {
    if (!isValid(cin)) return null;

    final listingStatus = cin.substring(0, 2);
    final registrationNumber = cin.substring(2, 7);
    final industryCode = cin.substring(7, 9);
    final yearOfIncorporation = int.parse(cin.substring(9, 13));
    final sequenceNumber = cin.substring(13, 21);

    final companyType = _getCompanyTypeFromListingStatus(listingStatus);
    final listingType = _getListingType(listingStatus);
    final industryDescription = IndustryCodes.getIndustryDescription(industryCode);
    final businessCategory = IndustryCodes.getBusinessCategory(industryCode);

    return {
      'listingStatus': listingStatus,
      'listingType': listingType,
      'registrationNumber': registrationNumber,
      'industryCode': industryCode,
      'industryDescription': industryDescription,
      'businessCategory': businessCategory,
      'yearOfIncorporation': yearOfIncorporation,
      'sequenceNumber': sequenceNumber,
      'companyType': companyType,
      'companyAge': DateTime.now().year - yearOfIncorporation,
      'isValid': true,
    };
  }

  /// Generate multiple CINs for testing/bulk operations
  ///
  /// [count] Number of CINs to generate
  /// [companyType] Type of company (optional, random if null)
  /// [yearRange] Range of incorporation years [start, end]
  /// [random] Random generator
  ///
  /// Returns list of unique valid CINs
  static List<String> generateBulk({
    required int count,
    CINCompanyType? companyType,
    List<int>? yearRange,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 10000) throw ArgumentError('Maximum 10,000 CINs per batch');

    final currentYear = DateTime.now().year;
    final startYear = yearRange?[0] ?? (currentYear - 30);
    final endYear = yearRange?[1] ?? currentYear;

    final generated = <String>{};
    int attempts = 0;
    final maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      try {
        final type = companyType ?? _getRandomCompanyType(random);
        final year = startYear + random.nextInt(endYear - startYear + 1);

        final cin = generate(
          companyType: type,
          yearOfIncorporation: year,
          random: random,
        );

        generated.add(cin);
      } catch (e) {
        // Skip invalid combinations and continue
      }
      attempts++;
    }

    return generated.toList();
  }

  /// Check if CIN belongs to listed company
  ///
  /// [cin] CIN to check
  static bool isListedCompany(String cin) {
    if (!isValid(cin)) return false;
    return cin[0] == 'L';
  }

  /// Check if CIN belongs to foreign company
  ///
  /// [cin] CIN to check
  static bool isForeignCompany(String cin) {
    if (!isValid(cin)) return false;
    return cin[0] == 'F';
  }

  /// Get company age from CIN
  ///
  /// [cin] Valid CIN
  /// Returns age in years or null if invalid
  static int? getCompanyAge(String cin) {
    if (!isValid(cin)) return null;
    final year = int.parse(cin.substring(9, 13));
    return DateTime.now().year - year;
  }

  /// Get industry sector from CIN
  ///
  /// [cin] Valid CIN
  /// Returns industry description or null if invalid
  static String? getIndustrySector(String cin) {
    if (!isValid(cin)) return null;
    final industryCode = cin.substring(7, 9);
    return IndustryCodes.getIndustryDescription(industryCode);
  }

  /// Generate registration number with optional state-based pattern
  static String _generateRegistrationNumber(Random random, int? stateCode) {
    // First digit often relates to state/region, but simplified here
    final firstDigit = stateCode != null
        ? (stateCode % 9) + 1
        : random.nextInt(9) + 1;

    // Remaining 4 digits are sequential/random
    final remaining = random.nextInt(9999).toString().padLeft(4, '0');

    return '$firstDigit$remaining';
  }

  /// Generate sequence number with year-based pattern
  static String _generateSequenceNumber(Random random, int year) {
    // First 2 digits often relate to the year
    final yearDigits = (year % 100).toString().padLeft(2, '0');

    // Remaining 4 digits are registration sequence
    final sequence = random.nextInt(9999).toString().padLeft(4, '0');

    return '$yearDigits$sequence';
  }

  /// Get appropriate industry code for company type
  static String _getIndustryCodeForCompanyType(CINCompanyType companyType, Random random) {
    switch (companyType) {
      case CINCompanyType.privateLimited:
      case CINCompanyType.publicLimited:
        return IndustryCodes.getRandomPopularIndustryCode();
      case CINCompanyType.onePersonCompany:
        // OPCs are often in services or trading
        final serviceCodes = ['62', '46', '47', '68', '70'];
        return serviceCodes[random.nextInt(serviceCodes.length)];
      case CINCompanyType.section8:
        // Non-profit activities
        final nonprofitCodes = ['85', '86', '87', '88', '94'];
        return nonprofitCodes[random.nextInt(nonprofitCodes.length)];
      case CINCompanyType.government:
        // Public administration
        return '84';
      case CINCompanyType.llp:
      case CINCompanyType.foreign:
        return IndustryCodes.getRandomIndustryCode();
    }
  }

  /// Validate listing status code
  static bool _isValidListingStatus(String status) {
    final validStatuses = <String>{};
    for (final codes in _listingStatusCodes.values) {
      validStatuses.addAll(codes);
    }
    return validStatuses.contains(status);
  }

  /// Get listing type from status code
  static String _getListingType(String status) {
    switch (status[0]) {
      case 'L':
        return 'Listed Company';
      case 'U':
        return 'Unlisted Company';
      case 'F':
        return 'Foreign Company';
      case 'G':
        return 'Government Company';
      default:
        return 'Unknown';
    }
  }

  /// Get company type from listing status
  static CINCompanyType? _getCompanyTypeFromListingStatus(String status) {
    for (final entry in _listingStatusCodes.entries) {
      if (entry.value.contains(status)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get random company type
  static CINCompanyType _getRandomCompanyType(Random random) {
    // Weighted distribution favoring common company types
    final weightedTypes = [
      ...List.filled(5, CINCompanyType.privateLimited), // 50%
      ...List.filled(2, CINCompanyType.publicLimited), // 20%
      CINCompanyType.onePersonCompany, // 10%
      CINCompanyType.llp, // 10%
      CINCompanyType.section8, // 10%
    ];

    return weightedTypes[random.nextInt(weightedTypes.length)];
  }

  /// Get all supported company types
  static List<CINCompanyType> getSupportedCompanyTypes() {
    return CINCompanyType.values;
  }

  /// Generate CIN for startup (typically recent incorporation, tech sector)
  ///
  /// [random] Random generator
  /// [stateCode] State where startup is based (optional)
  static String generateStartupCIN(Random random, [int? stateCode]) {
    final currentYear = DateTime.now().year;
    final startupYear = currentYear - random.nextInt(8); // 0-8 years old

    return generate(
      companyType: CINCompanyType.privateLimited,
      industryCode: '62', // Software/IT
      yearOfIncorporation: startupYear,
      stateCode: stateCode,
      random: random,
    );
  }
}

/// Extension on String for CIN utilities
extension CINStringExtension on String {
  /// Check if this string is a valid CIN
  bool get isValidCIN => CINGenerator.isValid(this);

  /// Parse CIN components
  Map<String, dynamic>? get cinComponents => CINGenerator.parseCIN(this);

  /// Check if this CIN belongs to a listed company
  bool get isListedCompany => CINGenerator.isListedCompany(this);

  /// Check if this CIN belongs to a foreign company
  bool get isForeignCompany => CINGenerator.isForeignCompany(this);

  /// Get company age from this CIN
  int? get companyAge => CINGenerator.getCompanyAge(this);

  /// Get industry sector from this CIN
  String? get industrySector => CINGenerator.getIndustrySector(this);

  /// Format CIN with spaces for display
  String get formattedCIN {
    if (length != 21) return this;
    return '${substring(0, 2)}-${substring(2, 7)}-${substring(7, 9)}-${substring(9, 13)}-${substring(13)}';
  }
}