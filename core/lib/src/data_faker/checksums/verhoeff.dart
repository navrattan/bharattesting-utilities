/// Verhoeff checksum algorithm implementation
///
/// Used for Aadhaar number validation in India.
/// This is a check digit algorithm that detects all single-digit errors
/// and most transposition errors.
library verhoeff;

import 'dart:math';

/// Verhoeff checksum algorithm for Aadhaar numbers
class VerhoeffChecksum {
  const VerhoeffChecksum._();

  /// Multiplication table for Verhoeff algorithm
  static const List<List<int>> _multiplicationTable = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  ];

  /// Permutation table for Verhoeff algorithm
  static const List<List<int>> _permutationTable = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
  ];

  /// Inverse table for Verhoeff algorithm
  static const List<int> _inverseTable = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

  /// Calculate Verhoeff check digit for a number string
  ///
  /// [number] should contain only digits (0-9)
  /// Returns the check digit (0-9)
  ///
  /// Example:
  /// ```dart
  /// final checkDigit = VerhoeffChecksum.calculateCheckDigit('123456789012');
  /// // Returns appropriate check digit
  /// ```
  static int calculateCheckDigit(String number) {
    if (number.isEmpty) {
      throw ArgumentError('Number cannot be empty');
    }

    // Validate input contains only digits
    if (!RegExp(r'^\d+$').hasMatch(number)) {
      throw ArgumentError('Number must contain only digits');
    }

    int check = 0;
    final digits = number.split('').map(int.parse).toList();

    // Process digits from right to left
    for (int i = 0; i < digits.length; i++) {
      final position = i + 1; // Position starts from 1
      final digit = digits[digits.length - 1 - i]; // Right to left

      // Apply permutation based on position
      final permutedDigit = _permutationTable[position % 8][digit];

      // Apply multiplication
      check = _multiplicationTable[check][permutedDigit];
    }

    // Return inverse of check
    return _inverseTable[check];
  }

  /// Validate a number with its Verhoeff check digit
  ///
  /// [numberWithCheckDigit] should be the complete number including check digit
  /// Returns true if valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// final isValid = VerhoeffChecksum.validate('1234567890123'); // 13 digits
  /// ```
  static bool validate(String numberWithCheckDigit) {
    if (numberWithCheckDigit.isEmpty) {
      return false;
    }

    // Validate input contains only digits
    if (!RegExp(r'^\d+$').hasMatch(numberWithCheckDigit)) {
      return false;
    }

    if (numberWithCheckDigit.length < 2) {
      return false;
    }

    // Extract the number part (all except last digit)
    final numberPart = numberWithCheckDigit.substring(0, numberWithCheckDigit.length - 1);
    final providedCheckDigit = int.parse(numberWithCheckDigit[numberWithCheckDigit.length - 1]);

    try {
      final calculatedCheckDigit = calculateCheckDigit(numberPart);
      return calculatedCheckDigit == providedCheckDigit;
    } catch (e) {
      return false;
    }
  }

  /// Generate a complete number with Verhoeff check digit
  ///
  /// [baseNumber] should contain only digits
  /// Returns the complete number with check digit appended
  ///
  /// Example:
  /// ```dart
  /// final completeNumber = VerhoeffChecksum.generateWithCheckDigit('123456789012');
  /// // Returns '1234567890123' (with calculated check digit)
  /// ```
  static String generateWithCheckDigit(String baseNumber) {
    final checkDigit = calculateCheckDigit(baseNumber);
    return '$baseNumber$checkDigit';
  }

  /// Generate a valid Aadhaar-like number (12 digits + check digit)
  ///
  /// [random] Random number generator instance
  /// Returns a 12-digit number with valid Verhoeff check digit
  ///
  /// Note: This generates synthetic test data only. Real Aadhaar numbers
  /// have additional structure and validation rules.
  static String generateAadhaarNumber(Random random) {
    // Generate 12 random digits
    // First digit should not be 0 or 1 (UIDAI rule)
    final firstDigit = 2 + random.nextInt(8); // 2-9
    final remainingDigits = List.generate(11, (_) => random.nextInt(10));

    final baseNumber = '$firstDigit${remainingDigits.join()}';
    return generateWithCheckDigit(baseNumber);
  }
}