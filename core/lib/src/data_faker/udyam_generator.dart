/// Udyam Registration Number generator for MSME enterprises in India
///
/// Udyam format: UDYAM-AA-00-0000000 (19 characters including hyphens)
/// - UDYAM: Fixed prefix
/// - AA: State code (2 letters)
/// - 00: District code (2 digits)
/// - 0000000: Sequential registration number (7 digits)
///
/// Udyam registration is mandatory for MSMEs (Micro, Small & Medium Enterprises)
/// seeking government benefits and schemes.
library udyam_generator;

import 'dart:math';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// MSME enterprise types for Udyam registration
enum UdyamEnterpriseType {
  /// Micro Enterprise
  micro('Micro Enterprise', 'Investment up to ₹1 crore, Turnover up to ₹5 crores'),

  /// Small Enterprise
  small('Small Enterprise', 'Investment up to ₹10 crores, Turnover up to ₹50 crores'),

  /// Medium Enterprise
  medium('Medium Enterprise', 'Investment up to ₹50 crores, Turnover up to ₹250 crores');

  const UdyamEnterpriseType(this.description, this.criteria);

  /// Human-readable description
  final String description;

  /// Investment and turnover criteria
  final String criteria;
}

/// Business sectors for MSME classification
enum UdyamBusinessSector {
  /// Manufacturing enterprises
  manufacturing('Manufacturing', 'Production of goods'),

  /// Service enterprises
  service('Service', 'Service-based businesses'),

  /// Trading enterprises
  trading('Trading', 'Buying and selling of goods'),

  /// Agriculture and allied
  agriculture('Agriculture', 'Farming and allied activities'),

  /// Handicrafts and handloom
  handicrafts('Handicrafts', 'Traditional crafts and handloom'),

  /// Technology and IT
  technology('Technology', 'IT and technology services'),

  /// Food processing
  foodProcessing('Food Processing', 'Food and beverage processing'),

  /// Textiles
  textiles('Textiles', 'Textile manufacturing and processing'),

  /// Engineering
  engineering('Engineering', 'Engineering goods and services'),

  /// Chemical and pharmaceuticals
  chemical('Chemical', 'Chemical and pharmaceutical products');

  const UdyamBusinessSector(this.code, this.description);

  /// Short code
  final String code;

  /// Human-readable description
  final String description;
}

/// High-quality Udyam registration number generator
class UdyamGenerator {
  const UdyamGenerator._();

  /// State code mappings for Udyam (using 2-letter codes)
  static const Map<String, String> _stateCodeMapping = {
    'Andhra Pradesh': 'AP',
    'Arunachal Pradesh': 'AR',
    'Assam': 'AS',
    'Bihar': 'BR',
    'Chhattisgarh': 'CG',
    'Goa': 'GA',
    'Gujarat': 'GJ',
    'Haryana': 'HR',
    'Himachal Pradesh': 'HP',
    'Jharkhand': 'JH',
    'Karnataka': 'KA',
    'Kerala': 'KL',
    'Madhya Pradesh': 'MP',
    'Maharashtra': 'MH',
    'Manipur': 'MN',
    'Meghalaya': 'ML',
    'Mizoram': 'MZ',
    'Nagaland': 'NL',
    'Odisha': 'OR',
    'Punjab': 'PB',
    'Rajasthan': 'RJ',
    'Sikkim': 'SK',
    'Tamil Nadu': 'TN',
    'Telangana': 'TS',
    'Tripura': 'TR',
    'Uttar Pradesh': 'UP',
    'Uttarakhand': 'UK',
    'West Bengal': 'WB',
    'Delhi': 'DL',
    'Chandigarh': 'CH',
    'Ladakh': 'LA',
    'Jammu and Kashmir': 'JK',
    'Andaman and Nicobar Islands': 'AN',
    'Dadra and Nagar Haveli and Daman and Diu': 'DD',
    'Lakshadweep': 'LD',
    'Puducherry': 'PY',
  };

  /// Generate a valid Udyam registration number
  ///
  /// [stateName] Name of the state where enterprise is registered
  /// [districtCode] District code within the state (01-99)
  /// [enterpriseType] Type of MSME enterprise
  /// [businessSector] Primary business sector
  /// [random] Random number generator
  ///
  /// Returns a 19-character Udyam registration number
  ///
  /// Example:
  /// ```dart
  /// final udyam = UdyamGenerator.generate(
  ///   stateName: 'Karnataka',
  ///   districtCode: 12,
  ///   enterpriseType: UdyamEnterpriseType.micro,
  ///   businessSector: UdyamBusinessSector.technology,
  ///   random: Random(42),
  /// );
  /// print(udyam); // UDYAM-KA-12-1234567
  /// ```
  static String generate({
    required String stateName,
    int? districtCode,
    UdyamEnterpriseType? enterpriseType,
    UdyamBusinessSector? businessSector,
    required Random random,
  }) {
    // Get state code
    final stateCode = _stateCodeMapping[stateName];
    if (stateCode == null) {
      throw ArgumentError('Unsupported state: $stateName');
    }

    // Generate or validate district code
    final district = districtCode ?? (random.nextInt(50) + 1);
    if (district < 1 || district > 99) {
      throw ArgumentError('District code must be between 01 and 99');
    }
    final districtStr = district.toString().padLeft(2, '0');

    // Generate sequential registration number (7 digits)
    final registrationNumber = _generateRegistrationNumber(
      enterpriseType ?? UdyamEnterpriseType.micro,
      businessSector ?? UdyamBusinessSector.service,
      random,
    );

    return 'UDYAM-$stateCode-$districtStr-$registrationNumber';
  }

  /// Generate Udyam number from business details
  ///
  /// [businessName] Name of the business
  /// [ownerName] Name of the business owner
  /// [stateName] State where business operates
  /// [businessType] Type of business activity
  /// [estimatedTurnover] Annual turnover in lakhs (affects enterprise type)
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final udyam = UdyamGenerator.generateFromBusiness(
  ///   businessName: 'Sharma Electronics',
  ///   ownerName: 'Raj Sharma',
  ///   stateName: 'Maharashtra',
  ///   businessType: 'retail',
  ///   estimatedTurnover: 25, // 25 lakhs
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromBusiness({
    required String businessName,
    required String ownerName,
    required String stateName,
    String? businessType,
    double? estimatedTurnover,
    required Random random,
  }) {
    // Determine enterprise type from turnover
    final enterpriseType = _getEnterpriseTypeFromTurnover(estimatedTurnover);

    // Determine business sector from business type
    final businessSector = _getBusinessSectorFromType(businessType, random);

    return generate(
      stateName: stateName,
      enterpriseType: enterpriseType,
      businessSector: businessSector,
      random: random,
    );
  }

  /// Validate Udyam registration number format
  ///
  /// [udyam] The Udyam number to validate
  ///
  /// Returns true if format is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(UdyamGenerator.isValid('UDYAM-KA-12-1234567'), isTrue);
  /// expect(UdyamGenerator.isValid('UDYAM-XX-12-1234567'), isFalse); // Invalid state
  /// expect(UdyamGenerator.isValid('UDYAM-KA-121234567'), isFalse); // Missing hyphens
  /// ```
  static bool isValid(String udyam) {
    // Check basic format: UDYAM-AA-00-0000000
    if (!RegExp(r'^UDYAM-[A-Z]{2}-\d{2}-\d{7}$').hasMatch(udyam)) {
      return false;
    }

    // Validate state code
    final parts = udyam.split('-');
    final stateCode = parts[1];
    if (!_stateCodeMapping.values.contains(stateCode)) {
      return false;
    }

    // Validate district code (01-99)
    final districtCode = int.tryParse(parts[2]);
    if (districtCode == null || districtCode < 1 || districtCode > 99) {
      return false;
    }

    return true;
  }

  /// Parse Udyam registration number components
  ///
  /// [udyam] Valid Udyam registration number
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = UdyamGenerator.parseUdyam('UDYAM-KA-12-1234567');
  /// print(components['stateName']); // Karnataka
  /// print(components['districtCode']); // 12
  /// print(components['registrationNumber']); // 1234567
  /// ```
  static Map<String, dynamic>? parseUdyam(String udyam) {
    if (!isValid(udyam)) return null;

    final parts = udyam.split('-');
    final stateCode = parts[1];
    final districtCode = int.parse(parts[2]);
    final registrationNumber = parts[3];

    // Find state name from code
    String? stateName;
    for (final entry in _stateCodeMapping.entries) {
      if (entry.value == stateCode) {
        stateName = entry.key;
        break;
      }
    }

    // Analyze registration number for patterns
    final regNum = int.parse(registrationNumber);
    final enterpriseType = _analyzeEnterpriseType(regNum);

    return {
      'prefix': 'UDYAM',
      'stateCode': stateCode,
      'stateName': stateName,
      'districtCode': districtCode,
      'registrationNumber': registrationNumber,
      'fullNumber': udyam,
      'probableEnterpriseType': enterpriseType,
      'isValid': true,
    };
  }

  /// Generate multiple Udyam numbers for testing/bulk operations
  ///
  /// [count] Number of Udyam numbers to generate
  /// [states] List of states to use (optional, all states if null)
  /// [enterpriseTypes] List of enterprise types (optional)
  /// [random] Random generator
  ///
  /// Returns list of unique valid Udyam numbers
  static List<String> generateBulk({
    required int count,
    List<String>? states,
    List<UdyamEnterpriseType>? enterpriseTypes,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 50000) throw ArgumentError('Maximum 50,000 Udyam numbers per batch');

    final availableStates = states ?? _stateCodeMapping.keys.toList();
    final availableTypes = enterpriseTypes ?? UdyamEnterpriseType.values;
    final generated = <String>{};

    int attempts = 0;
    final maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      try {
        final state = availableStates[random.nextInt(availableStates.length)];
        final type = availableTypes[random.nextInt(availableTypes.length)];

        final udyam = generate(
          stateName: state,
          enterpriseType: type,
          random: random,
        );

        generated.add(udyam);
      } catch (e) {
        // Continue on error
      }
      attempts++;
    }

    return generated.toList();
  }

  /// Get state name from Udyam number
  ///
  /// [udyam] Valid Udyam registration number
  /// Returns state name or null if invalid
  static String? getStateName(String udyam) {
    if (!isValid(udyam)) return null;

    final stateCode = udyam.split('-')[1];
    for (final entry in _stateCodeMapping.entries) {
      if (entry.value == stateCode) {
        return entry.key;
      }
    }
    return null;
  }

  /// Check if Udyam number is from specific state
  ///
  /// [udyam] Udyam number to check
  /// [stateName] State name to validate against
  static bool isFromState(String udyam, String stateName) {
    return getStateName(udyam) == stateName;
  }

  /// Generate Udyam for specific MSME scheme
  ///
  /// [schemeName] Government scheme name
  /// [stateName] State where enterprise operates
  /// [random] Random generator
  ///
  /// Returns Udyam number suitable for the scheme
  static String generateForScheme({
    required String schemeName,
    required String stateName,
    required Random random,
  }) {
    UdyamEnterpriseType enterpriseType;
    UdyamBusinessSector businessSector;

    // Scheme-specific defaults
    switch (schemeName.toLowerCase()) {
      case 'pmegp':
      case 'mudra':
        enterpriseType = UdyamEnterpriseType.micro;
        businessSector = UdyamBusinessSector.manufacturing;
        break;

      case 'startup india':
        enterpriseType = UdyamEnterpriseType.small;
        businessSector = UdyamBusinessSector.technology;
        break;

      case 'digital india':
        enterpriseType = UdyamEnterpriseType.small;
        businessSector = UdyamBusinessSector.technology;
        break;

      case 'make in india':
        enterpriseType = UdyamEnterpriseType.medium;
        businessSector = UdyamBusinessSector.manufacturing;
        break;

      case 'skill india':
        enterpriseType = UdyamEnterpriseType.micro;
        businessSector = UdyamBusinessSector.service;
        break;

      default:
        enterpriseType = UdyamEnterpriseType.micro;
        businessSector = UdyamBusinessSector.service;
    }

    return generate(
      stateName: stateName,
      enterpriseType: enterpriseType,
      businessSector: businessSector,
      random: random,
    );
  }

  /// Generate registration number with enterprise-specific patterns
  static String _generateRegistrationNumber(
    UdyamEnterpriseType enterpriseType,
    UdyamBusinessSector businessSector,
    Random random,
  ) {
    // Base number generation with some pattern based on type
    int baseNumber;

    switch (enterpriseType) {
      case UdyamEnterpriseType.micro:
        // Micro enterprises: 1000000-3999999
        baseNumber = 1000000 + random.nextInt(3000000);
        break;
      case UdyamEnterpriseType.small:
        // Small enterprises: 4000000-6999999
        baseNumber = 4000000 + random.nextInt(3000000);
        break;
      case UdyamEnterpriseType.medium:
        // Medium enterprises: 7000000-9999999
        baseNumber = 7000000 + random.nextInt(3000000);
        break;
    }

    return baseNumber.toString();
  }

  /// Determine enterprise type from estimated turnover
  static UdyamEnterpriseType _getEnterpriseTypeFromTurnover(double? turnover) {
    if (turnover == null) return UdyamEnterpriseType.micro;

    if (turnover <= 500) {
      // Up to 5 crores
      return UdyamEnterpriseType.micro;
    } else if (turnover <= 5000) {
      // Up to 50 crores
      return UdyamEnterpriseType.small;
    } else {
      // Up to 250 crores
      return UdyamEnterpriseType.medium;
    }
  }

  /// Determine business sector from business type
  static UdyamBusinessSector _getBusinessSectorFromType(
    String? businessType,
    Random random,
  ) {
    if (businessType == null) return UdyamBusinessSector.service;

    final type = businessType.toLowerCase();

    if (type.contains('manufacture') || type.contains('production')) {
      return UdyamBusinessSector.manufacturing;
    } else if (type.contains('software') || type.contains('it') || type.contains('tech')) {
      return UdyamBusinessSector.technology;
    } else if (type.contains('trading') || type.contains('retail') || type.contains('wholesale')) {
      return UdyamBusinessSector.trading;
    } else if (type.contains('food') || type.contains('restaurant') || type.contains('catering')) {
      return UdyamBusinessSector.foodProcessing;
    } else if (type.contains('textile') || type.contains('garment') || type.contains('fabric')) {
      return UdyamBusinessSector.textiles;
    } else if (type.contains('agriculture') || type.contains('farming')) {
      return UdyamBusinessSector.agriculture;
    } else if (type.contains('handicraft') || type.contains('craft') || type.contains('handloom')) {
      return UdyamBusinessSector.handicrafts;
    } else if (type.contains('engineering') || type.contains('mechanical')) {
      return UdyamBusinessSector.engineering;
    } else if (type.contains('chemical') || type.contains('pharma')) {
      return UdyamBusinessSector.chemical;
    }

    return UdyamBusinessSector.service; // Default
  }

  /// Analyze registration number to guess enterprise type
  static UdyamEnterpriseType? _analyzeEnterpriseType(int registrationNumber) {
    if (registrationNumber >= 1000000 && registrationNumber < 4000000) {
      return UdyamEnterpriseType.micro;
    } else if (registrationNumber >= 4000000 && registrationNumber < 7000000) {
      return UdyamEnterpriseType.small;
    } else if (registrationNumber >= 7000000 && registrationNumber <= 9999999) {
      return UdyamEnterpriseType.medium;
    }

    return null;
  }

  /// Get all supported enterprise types
  static List<UdyamEnterpriseType> getSupportedEnterpriseTypes() {
    return UdyamEnterpriseType.values;
  }

  /// Get all supported business sectors
  static List<UdyamBusinessSector> getSupportedBusinessSectors() {
    return UdyamBusinessSector.values;
  }

  /// Get all supported states
  static List<String> getSupportedStates() {
    return _stateCodeMapping.keys.toList();
  }

  /// Generate Udyam with specific pattern
  ///
  /// [stateCode] 2-letter state code
  /// [pattern] Pattern like '12-1234***' where * = random digit
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final udyam = UdyamGenerator.generateWithPattern(
  ///   stateCode: 'KA',
  ///   pattern: '12-1234***',
  ///   random: Random(),
  /// );
  /// // Returns: UDYAM-KA-12-1234567
  /// ```
  static String generateWithPattern({
    required String stateCode,
    required String pattern,
    required Random random,
  }) {
    if (stateCode.length != 2) {
      throw ArgumentError('State code must be 2 letters');
    }

    if (!_stateCodeMapping.values.contains(stateCode)) {
      throw ArgumentError('Invalid state code: $stateCode');
    }

    // Parse pattern (format: DD-NNNNNNN where D=digit, N=number or *)
    final parts = pattern.split('-');
    if (parts.length != 2) {
      throw ArgumentError('Pattern must be in format DD-NNNNNNN');
    }

    final districtPart = parts[0];
    final registrationPart = parts[1];

    if (districtPart.length != 2 || registrationPart.length != 7) {
      throw ArgumentError('Pattern must be DD-NNNNNNN (district-registration)');
    }

    // Generate registration number from pattern
    String registrationNumber = '';
    for (int i = 0; i < registrationPart.length; i++) {
      if (registrationPart[i] == '*') {
        registrationNumber += random.nextInt(10).toString();
      } else {
        registrationNumber += registrationPart[i];
      }
    }

    return 'UDYAM-$stateCode-$districtPart-$registrationNumber';
  }
}

/// Extension on String for Udyam utilities
extension UdyamStringExtension on String {
  /// Check if this string is a valid Udyam number
  bool get isValidUdyam => UdyamGenerator.isValid(this);

  /// Parse Udyam components
  Map<String, dynamic>? get udyamComponents => UdyamGenerator.parseUdyam(this);

  /// Get state name from this Udyam number
  String? get udyamStateName => UdyamGenerator.getStateName(this);

  /// Check if this Udyam is from specific state
  bool isUdyamFromState(String stateName) => UdyamGenerator.isFromState(this, stateName);

  /// Format Udyam for display (already has hyphens)
  String get formattedUdyam => this;

  /// Get state code from Udyam
  String? get udyamStateCode {
    if (isValidUdyam) return split('-')[1];
    return null;
  }

  /// Get district code from Udyam
  int? get udyamDistrictCode {
    if (isValidUdyam) return int.tryParse(split('-')[2]);
    return null;
  }

  /// Get registration number from Udyam
  String? get udyamRegistrationNumber {
    if (isValidUdyam) return split('-')[3];
    return null;
  }
}