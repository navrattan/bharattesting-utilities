/// TAN (Tax Deduction Account Number) generator for Indian tax deductors
///
/// TAN format: AAAA99999A
/// - First 4 characters: Alphabets (A-Z)
/// - Next 5 characters: Numbers (0-9)
/// - Last character: Alphabet (A-Z)
///
/// TAN is issued to entities required to deduct tax at source (TDS).
/// This includes companies, government departments, banks, and individuals
/// with significant business operations.
library tan_generator;

import 'dart:math';

/// Entity types that typically require TAN
enum TANEntityType {
  /// Company (Pvt Ltd, Ltd, etc.)
  company('Company', 'Corporate entity requiring TDS deduction'),

  /// Government department or PSU
  government('Government', 'Government department or PSU'),

  /// Bank or financial institution
  bank('Bank', 'Banking or financial institution'),

  /// Non-banking financial company
  nbfc('NBFC', 'Non-Banking Financial Company'),

  /// Individual with business requiring TDS
  individual('Individual', 'Individual with TDS obligations'),

  /// Partnership firm
  firm('Firm', 'Partnership firm or LLP'),

  /// Trust or foundation
  trust('Trust', 'Trust or charitable foundation'),

  /// Association of persons
  aop('AOP', 'Association of Persons'),

  /// Cooperative society
  cooperative('Cooperative', 'Cooperative society'),

  /// Other entity requiring TAN
  other('Other', 'Other entity with TDS obligations');

  const TANEntityType(this.code, this.description);

  /// Short code for entity type
  final String code;

  /// Human-readable description
  final String description;
}

/// High-quality TAN generator with comprehensive validation
class TANGenerator {
  const TANGenerator._();

  /// Valid alphabet characters for TAN (all A-Z)
  static const String _validAlphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// City/region codes for first characters (simplified mapping)
  static const Map<String, List<String>> _regionCodes = {
    'Mumbai': ['MUMB', 'BOMM', 'MAHA'],
    'Delhi': ['DELH', 'NEWT', 'NDEL'],
    'Bangalore': ['BANG', 'BLOR', 'KARN'],
    'Hyderabad': ['HYDE', 'HYED', 'TELN'],
    'Chennai': ['CHEN', 'MADR', 'TNCH'],
    'Kolkata': ['KOLK', 'CALC', 'WBEN'],
    'Pune': ['PUNE', 'PUNA', 'MAHA'],
    'Ahmedabad': ['AHMD', 'GUJA', 'AHEM'],
    'Surat': ['SURA', 'GUJA', 'SURT'],
    'Jaipur': ['JAIP', 'RAJA', 'JPUR'],
    'Lucknow': ['LUCK', 'UTTP', 'LKNO'],
    'Kanpur': ['KANP', 'UTTP', 'KNPR'],
    'Nagpur': ['NAGP', 'MAHA', 'NGPR'],
    'Indore': ['INDO', 'MADH', 'INDR'],
    'Bhopal': ['BHOP', 'MADH', 'BHPL'],
    'Visakhapatnam': ['VISA', 'ANDH', 'VIZG'],
    'Vadodara': ['VADO', 'GUJA', 'BARO'],
    'Coimbatore': ['COIM', 'TNCH', 'COIR'],
    'Agra': ['AGRA', 'UTTP', 'AGRA'],
    'Kochi': ['KOCH', 'KERA', 'COCH'],
  };

  /// Generate a valid TAN
  ///
  /// [entityType] Type of entity requiring TAN
  /// [city] City/region for location-based prefix (optional)
  /// [random] Random number generator for reproducibility
  ///
  /// Returns a 10-character TAN in format AAAA99999A
  ///
  /// Example:
  /// ```dart
  /// final tan = TANGenerator.generate(
  ///   entityType: TANEntityType.company,
  ///   city: 'Mumbai',
  ///   random: Random(42),
  /// );
  /// print(tan); // MUMB12345A
  /// ```
  static String generate({
    required TANEntityType entityType,
    String? city,
    required Random random,
  }) {
    // First 4 characters: City/region code or random
    String firstFour;
    if (city != null && _regionCodes.containsKey(city)) {
      final codes = _regionCodes[city]!;
      firstFour = codes[random.nextInt(codes.length)];
    } else {
      firstFour = _generateRandomAlphabets(4, random);
    }

    // Next 5 characters: Numbers
    final fiveDigits = _generateRandomDigits(5, random);

    // Last character: Letter (often related to entity type)
    final lastChar = _getEntityTypeChar(entityType, random);

    return '$firstFour$fiveDigits$lastChar';
  }

  /// Generate TAN from organization details
  ///
  /// [organizationName] Name of the organization
  /// [entityType] Type of entity
  /// [city] City where organization is located
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final tan = TANGenerator.generateFromOrganization(
  ///   organizationName: 'Acme Corporation Ltd',
  ///   entityType: TANEntityType.company,
  ///   city: 'Bangalore',
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromOrganization({
    required String organizationName,
    required TANEntityType entityType,
    String? city,
    required Random random,
  }) {
    // Extract 4 characters from organization name if no city specified
    String? derivedCity = city;
    if (derivedCity == null && organizationName.isNotEmpty) {
      // Try to derive city-like pattern from name
      final cleanName = organizationName
          .toUpperCase()
          .replaceAll(RegExp(r'[^A-Z]'), '')
          .substring(0, organizationName.length > 4 ? 4 : organizationName.length);

      if (cleanName.length == 4) {
        derivedCity = 'Custom'; // Will use cleanName directly
        _regionCodes['Custom'] = [cleanName];
      }
    }

    return generate(
      entityType: entityType,
      city: derivedCity,
      random: random,
    );
  }

  /// Validate TAN format
  ///
  /// [tan] The TAN to validate
  ///
  /// Returns true if TAN format is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(TANGenerator.isValid('MUMB12345A'), isTrue);
  /// expect(TANGenerator.isValid('MUMB1234A'), isFalse); // Too short
  /// expect(TANGenerator.isValid('mumb12345a'), isFalse); // Lowercase
  /// ```
  static bool isValid(String tan) {
    if (tan.length != 10) return false;

    // Check format: AAAA99999A
    if (!RegExp(r'^[A-Z]{4}[0-9]{5}[A-Z]$').hasMatch(tan)) return false;

    return true;
  }

  /// Parse TAN components
  ///
  /// [tan] Valid TAN string
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = TANGenerator.parseTAN('MUMB12345A');
  /// print(components['regionCode']); // MUMB
  /// print(components['sequence']); // 12345
  /// print(components['entityChar']); // A
  /// ```
  static Map<String, dynamic>? parseTAN(String tan) {
    if (!isValid(tan)) return null;

    final regionCode = tan.substring(0, 4);
    final sequence = tan.substring(4, 9);
    final entityChar = tan[9];

    // Try to identify city from region code
    String? identifiedCity;
    for (final entry in _regionCodes.entries) {
      if (entry.value.contains(regionCode)) {
        identifiedCity = entry.key;
        break;
      }
    }

    // Try to identify entity type from last character
    final possibleEntityType = _getEntityTypeFromChar(entityChar);

    return {
      'regionCode': regionCode,
      'sequence': sequence,
      'entityChar': entityChar,
      'identifiedCity': identifiedCity,
      'possibleEntityType': possibleEntityType,
      'isValid': true,
      'format': 'AAAA99999A',
    };
  }

  /// Generate multiple TANs for testing/bulk operations
  ///
  /// [count] Number of TANs to generate
  /// [entityType] Type of entity (optional, random if null)
  /// [cities] List of cities to use (optional, random if null)
  /// [random] Random generator
  ///
  /// Returns list of unique valid TANs
  static List<String> generateBulk({
    required int count,
    TANEntityType? entityType,
    List<String>? cities,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 50000) throw ArgumentError('Maximum 50,000 TANs per batch');

    final availableCities = cities ?? _regionCodes.keys.toList();
    final generated = <String>{};
    int attempts = 0;
    const maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      final type = entityType ?? _getRandomEntityType(random);
      final city = availableCities.isNotEmpty
          ? availableCities[random.nextInt(availableCities.length)]
          : null;

      final tan = generate(
        entityType: type,
        city: city,
        random: random,
      );

      generated.add(tan);
      attempts++;
    }

    return generated.toList();
  }

  /// Check if TAN is likely from a specific region
  ///
  /// [tan] TAN to check
  /// [city] City to check against
  static bool isFromRegion(String tan, String city) {
    if (!isValid(tan)) return false;
    if (!_regionCodes.containsKey(city)) return false;

    final regionCode = tan.substring(0, 4);
    return _regionCodes[city]!.contains(regionCode);
  }

  /// Get probable city from TAN
  ///
  /// [tan] Valid TAN
  /// Returns city name or null if not identifiable
  static String? getProbableCity(String tan) {
    if (!isValid(tan)) return null;

    final regionCode = tan.substring(0, 4);
    for (final entry in _regionCodes.entries) {
      if (entry.value.contains(regionCode)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Generate TAN for specific business type
  ///
  /// [businessType] Type of business (Banking, IT, Manufacturing, etc.)
  /// [city] City where business operates
  /// [random] Random generator
  static String generateForBusiness({
    required String businessType,
    String? city,
    required Random random,
  }) {
    TANEntityType entityType;

    switch (businessType.toLowerCase()) {
      case 'bank':
      case 'banking':
        entityType = TANEntityType.bank;
        break;
      case 'nbfc':
      case 'finance':
        entityType = TANEntityType.nbfc;
        break;
      case 'government':
      case 'psu':
        entityType = TANEntityType.government;
        break;
      case 'company':
      case 'corporate':
      case 'pvt':
      case 'limited':
        entityType = TANEntityType.company;
        break;
      case 'firm':
      case 'partnership':
      case 'llp':
        entityType = TANEntityType.firm;
        break;
      case 'trust':
      case 'ngo':
      case 'charity':
        entityType = TANEntityType.trust;
        break;
      case 'cooperative':
      case 'society':
        entityType = TANEntityType.cooperative;
        break;
      default:
        entityType = TANEntityType.other;
    }

    return generate(
      entityType: entityType,
      city: city,
      random: random,
    );
  }

  /// Generate random alphabet characters for TAN
  static String _generateRandomAlphabets(int count, Random random) {
    return List.generate(count, (_) => _getRandomAlphabet(random)).join();
  }

  /// Generate random digits for TAN
  static String _generateRandomDigits(int count, Random random) {
    return List.generate(count, (_) => random.nextInt(10).toString()).join();
  }

  /// Get single random alphabet
  static String _getRandomAlphabet(Random random) {
    return _validAlphabets[random.nextInt(_validAlphabets.length)];
  }

  /// Get entity type character (last character in TAN)
  static String _getEntityTypeChar(TANEntityType entityType, Random random) {
    // Common patterns for entity types (simplified)
    switch (entityType) {
      case TANEntityType.company:
        return ['A', 'B', 'C'][random.nextInt(3)];
      case TANEntityType.government:
        return ['G', 'H'][random.nextInt(2)];
      case TANEntityType.bank:
        return ['B', 'K'][random.nextInt(2)];
      case TANEntityType.nbfc:
        return ['F', 'N'][random.nextInt(2)];
      case TANEntityType.individual:
        return ['P', 'I'][random.nextInt(2)];
      case TANEntityType.firm:
        return ['F', 'P'][random.nextInt(2)];
      case TANEntityType.trust:
        return ['T', 'R'][random.nextInt(2)];
      case TANEntityType.aop:
        return ['A', 'O'][random.nextInt(2)];
      case TANEntityType.cooperative:
        return ['C', 'S'][random.nextInt(2)];
      case TANEntityType.other:
        return _getRandomAlphabet(random);
    }
  }

  /// Get entity type from character (best guess)
  static TANEntityType? _getEntityTypeFromChar(String char) {
    switch (char) {
      case 'A':
      case 'B':
      case 'C':
        return TANEntityType.company;
      case 'G':
      case 'H':
        return TANEntityType.government;
      case 'K':
        return TANEntityType.bank;
      case 'F':
        return TANEntityType.firm; // Could also be NBFC
      case 'P':
      case 'I':
        return TANEntityType.individual;
      case 'T':
      case 'R':
        return TANEntityType.trust;
      case 'S':
        return TANEntityType.cooperative;
      case 'N':
        return TANEntityType.nbfc;
      case 'O':
        return TANEntityType.aop;
      default:
        return null;
    }
  }

  /// Get random entity type with weighted distribution
  static TANEntityType _getRandomEntityType(Random random) {
    // Weighted towards more common entity types
    final weightedTypes = [
      ...List.filled(5, TANEntityType.company), // 50%
      ...List.filled(2, TANEntityType.firm), // 20%
      TANEntityType.bank,
      TANEntityType.government,
      TANEntityType.individual,
    ];

    return weightedTypes[random.nextInt(weightedTypes.length)];
  }

  /// Get all supported entity types
  static List<TANEntityType> getSupportedEntityTypes() {
    return TANEntityType.values;
  }

  /// Get all supported cities/regions
  static List<String> getSupportedCities() {
    return _regionCodes.keys.toList();
  }

  /// Generate TAN with custom pattern
  ///
  /// [pattern] Pattern like 'MUMB****A' where * = random digit
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final tan = TANGenerator.generateWithPattern('BANG****C', Random());
  /// // Returns something like: BANG12345C
  /// ```
  static String generateWithPattern(String pattern, Random random) {
    if (pattern.length != 10) {
      throw ArgumentError('Pattern must be exactly 10 characters');
    }

    String result = '';
    for (int i = 0; i < 10; i++) {
      if (pattern[i] == '*') {
        if (i < 4 || i == 9) {
          // Positions 0-3 and 9 should be alphabets
          result += _getRandomAlphabet(random);
        } else {
          // Positions 4-8 should be digits
          result += random.nextInt(10).toString();
        }
      } else {
        result += pattern[i];
      }
    }

    if (!isValid(result)) {
      throw ArgumentError('Generated TAN does not match valid format: $result');
    }

    return result;
  }
}

/// Extension on String for TAN utilities
extension TANStringExtension on String {
  /// Check if this string is a valid TAN
  bool get isValidTAN => TANGenerator.isValid(this);

  /// Parse TAN components
  Map<String, dynamic>? get tanComponents => TANGenerator.parseTAN(this);

  /// Get probable city from this TAN
  String? get probableCity => TANGenerator.getProbableCity(this);

  /// Format TAN with spaces for display
  String get formattedTAN {
    if (length != 10) return this;
    return '${substring(0, 4)} ${substring(4, 9)} ${substring(9)}';
  }

  /// Check if TAN is from specific region
  bool isTANFromRegion(String city) => TANGenerator.isFromRegion(this, city);
}