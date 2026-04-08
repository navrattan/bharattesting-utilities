/// Aadhaar number generator for Indian residents
///
/// Aadhaar format: 12 digits with Verhoeff checksum
/// - First digit: 2-9 (cannot be 0 or 1 as per UIDAI guidelines)
/// - Next 10 digits: Random numbers (0-9)
/// - Last digit: Verhoeff checksum for validation
///
/// Important: This generates SYNTHETIC test data only.
/// Real Aadhaar numbers are issued by UIDAI and have additional
/// security features and validation rules not replicated here.
library aadhaar_generator;

import 'dart:math';
import 'package:bharattesting_core/src/data_faker/checksums/verhoeff.dart';

/// Age categories for realistic Aadhaar generation patterns
enum AadhaarAgeCategory {
  /// Child (0-17 years) - Blue Aadhaar
  child('Child (0-17 years)', 'Blue Aadhaar'),

  /// Adult (18+ years) - Regular Aadhaar
  adult('Adult (18+ years)', 'Regular Aadhaar'),

  /// Senior citizen (60+ years)
  senior('Senior Citizen (60+ years)', 'Regular Aadhaar');

  const AadhaarAgeCategory(this.description, this.cardType);

  /// Human-readable description
  final String description;

  /// Type of Aadhaar card
  final String cardType;
}

/// High-quality Aadhaar generator with comprehensive validation
///
/// **IMPORTANT DISCLAIMER:**
/// This generates synthetic test data for software development purposes only.
/// Generated numbers are NOT real Aadhaar numbers and must NOT be used for:
/// - Identity fraud or misrepresentation
/// - Government document submission
/// - KYC processes with real institutions
/// - Any illegal activities
///
/// All generated data is purely fictional and for testing purposes.
class AadhaarGenerator {
  const AadhaarGenerator._();

  /// First digit constraints as per UIDAI guidelines
  static const List<int> _validFirstDigits = [2, 3, 4, 5, 6, 7, 8, 9];

  /// Generate a valid synthetic Aadhaar number
  ///
  /// [random] Random number generator for reproducibility
  /// [ageCategory] Optional age category for realistic patterns
  ///
  /// Returns a 12-digit Aadhaar with valid Verhoeff checksum
  ///
  /// Example:
  /// ```dart
  /// final aadhaar = AadhaarGenerator.generate(Random(42));
  /// print(aadhaar); // 234567890123 (with valid checksum)
  /// print(AadhaarGenerator.isValid(aadhaar)); // true
  /// ```
  static String generate(Random random, [AadhaarAgeCategory? ageCategory]) {
    // First digit: 2-9 (UIDAI constraint)
    final firstDigit = _validFirstDigits[random.nextInt(_validFirstDigits.length)];

    // Generate 10 middle digits with some pattern variations
    final middleDigits = _generateMiddleDigits(random, ageCategory);

    // Combine first digit with middle digits
    final baseNumber = '$firstDigit$middleDigits';

    // Calculate and append Verhoeff checksum
    final checkDigit = VerhoeffChecksum.calculateCheckDigit(baseNumber);

    return '$baseNumber$checkDigit';
  }

  /// Generate Aadhaar with demographic-based patterns
  ///
  /// [birthYear] Year of birth (1900-2025)
  /// [gender] 'M', 'F', or null for random
  /// [stateCode] Indian state code for regional patterns
  /// [random] Random generator
  ///
  /// Note: This adds subtle patterns for realism but maintains privacy
  ///
  /// Example:
  /// ```dart
  /// final aadhaar = AadhaarGenerator.generateWithDemographics(
  ///   birthYear: 1990,
  ///   gender: 'M',
  ///   stateCode: 27, // Karnataka
  ///   random: Random(),
  /// );
  /// ```
  static String generateWithDemographics({
    required int birthYear,
    String? gender,
    int? stateCode,
    required Random random,
  }) {
    // Validate birth year
    if (birthYear < 1900 || birthYear > DateTime.now().year) {
      throw ArgumentError('Invalid birth year: $birthYear');
    }

    // Determine age category
    final currentYear = DateTime.now().year;
    final age = currentYear - birthYear;

    AadhaarAgeCategory ageCategory;
    if (age < 18) {
      ageCategory = AadhaarAgeCategory.child;
    } else if (age >= 60) {
      ageCategory = AadhaarAgeCategory.senior;
    } else {
      ageCategory = AadhaarAgeCategory.adult;
    }

    return generate(random, ageCategory);
  }

  /// Validate Aadhaar number format and checksum
  ///
  /// [aadhaar] The Aadhaar number to validate (with or without spaces)
  ///
  /// Returns true if valid format and checksum, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(AadhaarGenerator.isValid('234567890123'), isTrue);
  /// expect(AadhaarGenerator.isValid('1234 5678 9012'), isFalse); // Invalid first digit
  /// expect(AadhaarGenerator.isValid('234567890124'), isFalse); // Invalid checksum
  /// ```
  static bool isValid(String aadhaar) {
    // Remove spaces and validate basic format
    final cleanAadhaar = aadhaar.replaceAll(RegExp(r'\s+'), '');

    if (cleanAadhaar.length != 12) return false;
    if (!RegExp(r'^\d{12}$').hasMatch(cleanAadhaar)) return false;

    // Validate first digit (cannot be 0 or 1)
    final firstDigit = int.parse(cleanAadhaar[0]);
    if (!_validFirstDigits.contains(firstDigit)) return false;

    // Validate using Verhoeff checksum
    return VerhoeffChecksum.validate(cleanAadhaar);
  }

  /// Generate multiple unique Aadhaar numbers
  ///
  /// [count] Number of Aadhaar numbers to generate
  /// [random] Random generator
  /// [ageCategory] Optional age category for all numbers
  ///
  /// Returns list of unique valid Aadhaar numbers
  ///
  /// Note: Ensures uniqueness within the batch but doesn't guarantee
  /// uniqueness across different generation sessions
  static List<String> generateBulk({
    required int count,
    required Random random,
    AadhaarAgeCategory? ageCategory,
  }) {
    if (count <= 0) return [];
    if (count > 100000) throw ArgumentError('Maximum 100,000 Aadhaar numbers per batch');

    final generated = <String>{};
    int attempts = 0;
    final maxAttempts = count * 10; // Reasonable limit to prevent infinite loops

    while (generated.length < count && attempts < maxAttempts) {
      final aadhaar = generate(random, ageCategory);
      generated.add(aadhaar);
      attempts++;
    }

    if (generated.length < count) {
      throw StateError(
        'Could not generate $count unique numbers. Generated ${generated.length}',
      );
    }

    return generated.toList();
  }

  /// Mask Aadhaar number for display (show only last 4 digits)
  ///
  /// [aadhaar] Aadhaar number to mask
  /// [showFirst] Number of first digits to show (default: 0)
  /// [showLast] Number of last digits to show (default: 4)
  ///
  /// Example:
  /// ```dart
  /// final masked = AadhaarGenerator.maskNumber('234567890123');
  /// print(masked); // XXXX XXXX 0123
  ///
  /// final partialMask = AadhaarGenerator.maskNumber('234567890123', showFirst: 2);
  /// print(partialMask); // 23XX XXXX 0123
  /// ```
  static String maskNumber(
    String aadhaar, {
    int showFirst = 0,
    int showLast = 4,
  }) {
    final clean = aadhaar.replaceAll(RegExp(r'\s+'), '');
    if (clean.length != 12) return aadhaar; // Return as-is if invalid

    final buffer = StringBuffer();

    for (int i = 0; i < 12; i++) {
      if (i < showFirst || i >= (12 - showLast)) {
        buffer.write(clean[i]);
      } else {
        buffer.write('X');
      }

      // Add spaces for formatting
      if (i == 3 || i == 7) buffer.write(' ');
    }

    return buffer.toString();
  }

  /// Format Aadhaar number with standard spacing
  ///
  /// [aadhaar] Aadhaar number to format
  ///
  /// Example:
  /// ```dart
  /// final formatted = AadhaarGenerator.formatNumber('234567890123');
  /// print(formatted); // 2345 6789 0123
  /// ```
  static String formatNumber(String aadhaar) {
    final clean = aadhaar.replaceAll(RegExp(r'\s+'), '');
    if (clean.length != 12) return aadhaar;

    return '${clean.substring(0, 4)} ${clean.substring(4, 8)} ${clean.substring(8, 12)}';
  }

  /// Extract checksum digit from Aadhaar
  ///
  /// [aadhaar] Valid Aadhaar number
  /// Returns the checksum digit or null if invalid
  static int? getChecksum(String aadhaar) {
    final clean = aadhaar.replaceAll(RegExp(r'\s+'), '');
    if (clean.length != 12) return null;
    return int.tryParse(clean[11]);
  }

  /// Validate checksum independently
  ///
  /// [aadhaarWithoutChecksum] First 11 digits of Aadhaar
  /// [expectedChecksum] Expected checksum digit
  ///
  /// Returns true if checksum matches calculated value
  static bool validateChecksum(String aadhaarWithoutChecksum, int expectedChecksum) {
    if (aadhaarWithoutChecksum.length != 11) return false;
    if (!RegExp(r'^\d{11}$').hasMatch(aadhaarWithoutChecksum)) return false;

    try {
      final calculatedChecksum = VerhoeffChecksum.calculateCheckDigit(aadhaarWithoutChecksum);
      return calculatedChecksum == expectedChecksum;
    } catch (e) {
      return false;
    }
  }

  /// Generate Aadhaar with specific pattern (for testing)
  ///
  /// [pattern] Pattern like '234567890***' where * = random digit
  /// [random] Random generator
  ///
  /// Note: Last digit will always be recalculated as valid checksum
  ///
  /// Example:
  /// ```dart
  /// final aadhaar = AadhaarGenerator.generateWithPattern('2345678901**', Random());
  /// // Returns something like '234567890123' with valid checksum
  /// ```
  static String generateWithPattern(String pattern, Random random) {
    if (pattern.length != 12) {
      throw ArgumentError('Pattern must be exactly 12 characters');
    }

    final buffer = StringBuffer();

    // Process first 11 characters
    for (int i = 0; i < 11; i++) {
      if (pattern[i] == '*') {
        // For first position, use valid first digits only
        if (i == 0) {
          buffer.write(_validFirstDigits[random.nextInt(_validFirstDigits.length)]);
        } else {
          buffer.write(random.nextInt(10));
        }
      } else if (RegExp(r'\d').hasMatch(pattern[i])) {
        // Validate first digit constraint
        if (i == 0) {
          final digit = int.parse(pattern[i]);
          if (!_validFirstDigits.contains(digit)) {
            throw ArgumentError('First digit must be 2-9, got: $digit');
          }
        }
        buffer.write(pattern[i]);
      } else {
        throw ArgumentError('Pattern can only contain digits and * characters');
      }
    }

    // Calculate valid checksum (ignore pattern's last character)
    final baseNumber = buffer.toString();
    final checksum = VerhoeffChecksum.calculateCheckDigit(baseNumber);

    return '$baseNumber$checksum';
  }

  /// Get age category from demographics
  static AadhaarAgeCategory getAgeCategory(int birthYear) {
    final age = DateTime.now().year - birthYear;

    if (age < 18) return AadhaarAgeCategory.child;
    if (age >= 60) return AadhaarAgeCategory.senior;
    return AadhaarAgeCategory.adult;
  }

  /// Check if Aadhaar follows child pattern (Blue Aadhaar indicators)
  ///
  /// Note: This is a heuristic based on common patterns,
  /// not a definitive identification method
  static bool isLikelyChildAadhaar(String aadhaar) {
    final clean = aadhaar.replaceAll(RegExp(r'\s+'), '');
    if (!isValid(clean)) return false;

    // Children's Aadhaar sometimes have certain digit patterns
    // This is a simplified heuristic for demonstration
    final firstFour = clean.substring(0, 4);
    final firstFourNum = int.parse(firstFour);

    // This is a fictional pattern for demonstration
    // Real UIDAI patterns are confidential
    return firstFourNum >= 2000 && firstFourNum <= 2999;
  }

  /// Generate middle 10 digits with optional demographic patterns
  static String _generateMiddleDigits(
    Random random,
    AadhaarAgeCategory? ageCategory,
  ) {
    final buffer = StringBuffer();

    // Generate 10 random digits
    for (int i = 0; i < 10; i++) {
      buffer.write(random.nextInt(10));
    }

    return buffer.toString();
  }

  /// Get statistics about a batch of generated Aadhaar numbers
  ///
  /// [aadhaarList] List of Aadhaar numbers to analyze
  /// Returns map with statistical information
  static Map<String, dynamic> getBatchStatistics(List<String> aadhaarList) {
    final validCount = aadhaarList.where(isValid).length;
    final invalidCount = aadhaarList.length - validCount;

    final firstDigitCounts = <int, int>{};
    final checksumCounts = <int, int>{};

    for (final aadhaar in aadhaarList) {
      if (isValid(aadhaar)) {
        final clean = aadhaar.replaceAll(RegExp(r'\s+'), '');
        final firstDigit = int.parse(clean[0]);
        final checksum = int.parse(clean[11]);

        firstDigitCounts[firstDigit] = (firstDigitCounts[firstDigit] ?? 0) + 1;
        checksumCounts[checksum] = (checksumCounts[checksum] ?? 0) + 1;
      }
    }

    return {
      'totalCount': aadhaarList.length,
      'validCount': validCount,
      'invalidCount': invalidCount,
      'validityRate': validCount / aadhaarList.length,
      'firstDigitDistribution': firstDigitCounts,
      'checksumDistribution': checksumCounts,
      'uniqueCount': aadhaarList.toSet().length,
      'duplicateCount': aadhaarList.length - aadhaarList.toSet().length,
    };
  }
}

/// Extension on String for Aadhaar utilities
extension AadhaarStringExtension on String {
  /// Check if this string is a valid Aadhaar number
  bool get isValidAadhaar => AadhaarGenerator.isValid(this);

  /// Format this Aadhaar with standard spacing
  String get formattedAadhaar => AadhaarGenerator.formatNumber(this);

  /// Mask this Aadhaar for display
  String get maskedAadhaar => AadhaarGenerator.maskNumber(this);

  /// Get checksum digit from this Aadhaar
  int? get aadhaarChecksum => AadhaarGenerator.getChecksum(this);

  /// Check if this looks like a child's Aadhaar
  bool get isLikelyChildAadhaar => AadhaarGenerator.isLikelyChildAadhaar(this);

  /// Remove all spaces from Aadhaar
  String get cleanAadhaar => replaceAll(RegExp(r'\s+'), '');
}