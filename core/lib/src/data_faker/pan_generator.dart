/// PAN (Permanent Account Number) generator for Indian entities
///
/// PAN format: AAAAA9999A
/// - First 5 characters: Alphabets (A-Z)
/// - Next 4 characters: Numbers (0-9)
/// - Last character: Alphabet (check digit, entity type dependent)
///
/// Entity type mapping (10th character):
/// - P: Individual
/// - F: Firm/LLP
/// - C: Company
/// - H: HUF (Hindu Undivided Family)
/// - A: Association of Persons (AOP)
/// - T: Trust
/// - B: Body of Individuals (BOI)
/// - G: Government
/// - J: Artificial Juridical Person
/// - L: Local Authority
library pan_generator;

import 'dart:math';

/// Entity types for PAN generation
enum PANEntityType {
  /// Individual person
  individual('P', 'Individual'),

  /// Firm/Limited Liability Partnership
  firm('F', 'Firm/LLP'),

  /// Company (Pvt Ltd, Ltd, etc.)
  company('C', 'Company'),

  /// Hindu Undivided Family
  huf('H', 'Hindu Undivided Family'),

  /// Association of Persons
  aop('A', 'Association of Persons'),

  /// Trust
  trust('T', 'Trust'),

  /// Body of Individuals
  boi('B', 'Body of Individuals'),

  /// Government entity
  government('G', 'Government'),

  /// Artificial Juridical Person
  ajp('J', 'Artificial Juridical Person'),

  /// Local Authority
  localAuthority('L', 'Local Authority');

  const PANEntityType(this.code, this.description);

  /// Single character code for PAN 10th position
  final String code;

  /// Human-readable description
  final String description;
}

/// High-quality PAN generator with comprehensive validation
class PANGenerator {
  const PANGenerator._();

  /// Valid alphabet characters for PAN (excluding I, O to avoid confusion)
  static const String _validAlphabets = 'ABCDEFGHJKLMNPQRSTUVWXYZ';

  /// Valid numeric characters
  static const String _validNumbers = '0123456789';

  /// Generate a valid PAN for specified entity type
  ///
  /// [entityType] The type of entity (Individual, Company, etc.)
  /// [random] Random number generator for reproducibility
  /// [namePrefix] Optional 3-character prefix based on name (A-Z only)
  ///
  /// Returns a 10-character PAN in format AAAAA9999A
  ///
  /// Example:
  /// ```dart
  /// final pan = PANGenerator.generate(
  ///   entityType: PANEntityType.individual,
  ///   random: Random(42),
  /// );
  /// print(pan); // ABCDE1234P
  /// ```
  static String generate({
    required PANEntityType entityType,
    required Random random,
    String? namePrefix,
  }) {
    // First 3 characters: Name prefix or random
    String firstThree;
    if (namePrefix != null) {
      firstThree = _sanitizeNamePrefix(namePrefix);
    } else {
      firstThree = _generateRandomAlphabets(3, random);
    }

    // 4th character: Always a letter (typically surname initial)
    final fourthChar = _getRandomAlphabet(random);

    // 5th character: Always a letter (often entity indicator, but random for privacy)
    final fifthChar = _getRandomAlphabet(random);

    // 6th-9th characters: 4 digits
    final digits = _generateRandomDigits(4, random);

    // 10th character: Entity type code
    final entityCode = entityType.code;

    return '$firstThree$fourthChar$fifthChar$digits$entityCode';
  }

  /// Generate PAN with name-based prefix
  ///
  /// [firstName] First name for generating prefix
  /// [lastName] Last name for generating 4th character
  /// [entityType] Entity type
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final pan = PANGenerator.generateFromName(
  ///   firstName: 'John',
  ///   lastName: 'Doe',
  ///   entityType: PANEntityType.individual,
  ///   random: Random(),
  /// );
  /// // Generates something like: JOHND1234P
  /// ```
  static String generateFromName({
    required String firstName,
    required String lastName,
    required PANEntityType entityType,
    required Random random,
  }) {
    // Take first 3 chars from first name, 1 char from last name
    final namePrefix = _extractNameChars(firstName, 3) +
                      _extractNameChars(lastName, 1);

    return generate(
      entityType: entityType,
      random: random,
      namePrefix: namePrefix,
    );
  }

  /// Validate PAN format and structure
  ///
  /// [pan] The PAN to validate
  ///
  /// Returns true if PAN format is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(PANValidator.isValidFormat('ABCDE1234P'), isTrue);
  /// expect(PANValidator.isValidFormat('ABCD1234P'), isFalse); // Too short
  /// ```
  static bool isValidFormat(String pan) {
    if (pan.length != 10) return false;

    // Check format: AAAAA9999A
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(pan)) return false;

    // Validate entity type (10th character)
    final entityChar = pan[9];
    final validEntityCodes = PANEntityType.values.map((e) => e.code);
    if (!validEntityCodes.contains(entityChar)) return false;

    // Check for invalid characters in alphabet positions
    for (int i = 0; i < 5; i++) {
      if (!_validAlphabets.contains(pan[i])) return false;
    }

    return true;
  }

  /// Get entity type from PAN
  ///
  /// [pan] Valid PAN string
  /// Returns the entity type or null if invalid
  static PANEntityType? getEntityType(String pan) {
    if (!isValidFormat(pan)) return null;

    final entityCode = pan[9];
    return PANEntityType.values
        .where((type) => type.code == entityCode)
        .firstOrNull;
  }

  /// Extract and validate name characters for PAN
  static String _extractNameChars(String name, int count) {
    if (name.isEmpty) return _generateRandomAlphabets(count, Random());

    final cleaned = name.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (cleaned.isEmpty) return _generateRandomAlphabets(count, Random());

    if (cleaned.length >= count) {
      return cleaned.substring(0, count);
    } else {
      // Pad with random letters if name is too short
      final padding = _generateRandomAlphabets(count - cleaned.length, Random());
      return cleaned + padding;
    }
  }

  /// Sanitize name prefix to valid PAN characters
  static String _sanitizeNamePrefix(String prefix) {
    final cleaned = prefix.toUpperCase()
        .replaceAll(RegExp(r'[^A-Z]'), '')
        .replaceAll('I', 'J') // Replace I with J to avoid confusion
        .replaceAll('O', 'P'); // Replace O with P to avoid confusion

    if (cleaned.length >= 3) {
      return cleaned.substring(0, 3);
    } else {
      // Pad with random valid letters
      final needed = 3 - cleaned.length;
      return cleaned + _generateRandomAlphabets(needed, Random());
    }
  }

  /// Generate random alphabet characters for PAN
  static String _generateRandomAlphabets(int count, Random random) {
    return List.generate(count, (_) => _getRandomAlphabet(random)).join();
  }

  /// Generate random digits for PAN
  static String _generateRandomDigits(int count, Random random) {
    return List.generate(count, (_) => random.nextInt(10).toString()).join();
  }

  /// Get single random valid alphabet
  static String _getRandomAlphabet(Random random) {
    return _validAlphabets[random.nextInt(_validAlphabets.length)];
  }

  /// Generate multiple PANs for testing/bulk generation
  ///
  /// [count] Number of PANs to generate
  /// [entityType] Entity type for all PANs
  /// [random] Random generator
  ///
  /// Returns list of unique PANs
  static List<String> generateBulk({
    required int count,
    required PANEntityType entityType,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 100000) throw ArgumentError('Maximum 100,000 PANs per batch');

    final generated = <String>{};
    int attempts = 0;
    const maxAttempts = count * 10; // Prevent infinite loops

    while (generated.length < count && attempts < maxAttempts) {
      final pan = generate(entityType: entityType, random: random);
      generated.add(pan);
      attempts++;
    }

    return generated.toList();
  }

  /// Get all supported entity types
  static List<PANEntityType> getSupportedEntityTypes() {
    return PANEntityType.values;
  }

  /// Get random entity type
  static PANEntityType getRandomEntityType(Random random) {
    final types = PANEntityType.values;
    return types[random.nextInt(types.length)];
  }

  /// Generate PAN with specific characteristics for testing
  ///
  /// [pattern] Pattern like 'ABC**1234*' where * = random
  /// [entityType] Entity type
  /// [random] Random generator
  static String generateWithPattern({
    required String pattern,
    required PANEntityType entityType,
    required Random random,
  }) {
    if (pattern.length != 9) {
      throw ArgumentError('Pattern must be 9 characters (excluding entity type)');
    }

    String result = '';
    for (int i = 0; i < 9; i++) {
      if (pattern[i] == '*') {
        if (i < 5) {
          result += _getRandomAlphabet(random);
        } else {
          result += random.nextInt(10).toString();
        }
      } else {
        result += pattern[i];
      }
    }

    return result + entityType.code;
  }
}

/// Extension on String for additional PAN utilities
extension PANStringExtension on String {
  /// Check if this string is a valid PAN format
  bool get isValidPAN => PANGenerator.isValidFormat(this);

  /// Get entity type from this PAN
  PANEntityType? get panEntityType => PANGenerator.getEntityType(this);

  /// Format PAN with spaces for display
  String get formattedPAN {
    if (length != 10) return this;
    return '${substring(0, 5)} ${substring(5, 9)} ${substring(9)}';
  }
}

/// Extension to help with null-safety for firstOrNull
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}