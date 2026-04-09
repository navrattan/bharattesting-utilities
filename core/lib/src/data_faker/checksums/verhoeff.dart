/// Verhoeff checksum algorithm implementation
///
/// Used for Aadhaar number validation in India.
library verhoeff;

import 'dart:math';

/// Verhoeff checksum implementation
class VerhoeffChecksum {
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
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  ];

  static const List<List<int>> _permutationTable = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
  ];

  static const List<int> _inverseTable = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

  /// Calculate the Verhoeff check digit for a numeric string
  static int calculateCheckDigit(String number) {
    int check = 0;
    final digits = number.split('').map(int.parse).toList();

    for (int i = 0; i < digits.length; i++) {
      final digit = digits[digits.length - 1 - i];
      check = _multiplicationTable[check][_permutationTable[(i + 1) % 8][digit]];
    }

    return _inverseTable[check];
  }

  /// Validate a numeric string with a Verhoeff check digit
  static bool validate(String number) {
    int check = 0;
    final digits = number.split('').map(int.parse).toList();

    for (int i = 0; i < digits.length; i++) {
      final digit = digits[digits.length - 1 - i];
      check = _multiplicationTable[check][_permutationTable[i % 8][digit]];
    }

    return check == 0;
  }

  /// Generate a numeric string with a Verhoeff check digit
  static String generateWithCheckDigit(String baseNumber) {
    final checkDigit = calculateCheckDigit(baseNumber);
    return '$baseNumber$checkDigit';
  }

  /// Generate a random valid Aadhaar-formatted number (12 digits)
  static String generateAadhaar() {
    final random = Random();
    final firstDigit = 2 + random.nextInt(8); // Aadhaar usually starts with 2-9
    final remaining = List.generate(10, (_) => random.nextInt(10)).join();
    final base = '$firstDigit$remaining';
    return generateWithCheckDigit(base);
  }

  /// Alias for generateAadhaar to maintain compatibility
  static String generateAadhaarNumber([Random? random]) => generateAadhaar();
}
