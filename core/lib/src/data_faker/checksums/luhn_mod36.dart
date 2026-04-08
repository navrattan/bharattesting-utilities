/// Luhn Mod-36 checksum algorithm implementation
///
/// Used for GSTIN (Goods and Services Tax Identification Number) validation in India.
/// This is a variant of the Luhn algorithm that works with alphanumeric characters.
library luhn_mod36;

import 'dart:math';

/// Luhn Mod-36 checksum algorithm for GSTIN
class LuhnMod36Checksum {
  const LuhnMod36Checksum._();

  /// Character map for alphanumeric characters (0-9, A-Z)
  /// Used to convert characters to numeric values for calculation
  static const String _characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Get numeric value for a character
  /// 0-9 → 0-9, A-Z → 10-35
  static int _getCharValue(String char) {
    final index = _characters.indexOf(char.toUpperCase());
    if (index == -1) {
      throw ArgumentError('Invalid character: $char');
    }
    return index;
  }

  /// Get character for a numeric value
  /// 0-9 → 0-9, 10-35 → A-Z
  static String _getCharFromValue(int value) {
    if (value < 0 || value >= _characters.length) {
      throw ArgumentError('Invalid value: $value');
    }
    return _characters[value];
  }

  /// Calculate Luhn Mod-36 check digit for a string
  ///
  /// [input] should contain only alphanumeric characters (0-9, A-Z)
  /// Returns the check character
  ///
  /// Example:
  /// ```dart
  /// final checkChar = LuhnMod36Checksum.calculateCheckDigit('22AAAAA0000A1Z');
  /// // Returns appropriate check character
  /// ```
  static String calculateCheckDigit(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    // Validate input contains only alphanumeric characters
    if (!RegExp(r'^[0-9A-Za-z]+$').hasMatch(input)) {
      throw ArgumentError('Input must contain only alphanumeric characters');
    }

    int sum = 0;
    bool shouldDouble = true; // GSTIN standard: double the first character from right, then every second

    // Process characters from right to left
    for (int i = input.length - 1; i >= 0; i--) {
      int value = _getCharValue(input[i]);

      if (shouldDouble) {
        // Double the value for alternate positions
        value *= 2;

        // If result is >= 36, subtract 35 or add digits in base 36
        if (value >= 36) {
          value = (value ~/ 36) + (value % 36);
        }
      }

      sum += value;
      shouldDouble = !shouldDouble;
    }

    // Calculate check digit
    final checkValue = (36 - (sum % 36)) % 36;
    return _getCharFromValue(checkValue);
  }

  /// Validate a string with its Luhn Mod-36 check digit
  ///
  /// [inputWithCheckDigit] should be the complete string including check digit
  /// Returns true if valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// final isValid = LuhnMod36Checksum.validate('22AAAAA0000A1ZA');
  /// ```
  static bool validate(String inputWithCheckDigit) {
    if (inputWithCheckDigit.isEmpty) {
      return false;
    }

    // Validate input contains only alphanumeric characters
    if (!RegExp(r'^[0-9A-Za-z]+$').hasMatch(inputWithCheckDigit)) {
      return false;
    }

    if (inputWithCheckDigit.length < 2) {
      return false;
    }

    // Extract the input part (all except last character)
    final inputPart = inputWithCheckDigit.substring(0, inputWithCheckDigit.length - 1);
    final providedCheckDigit = inputWithCheckDigit[inputWithCheckDigit.length - 1].toUpperCase();

    try {
      final calculatedCheckDigit = calculateCheckDigit(inputPart);
      return calculatedCheckDigit == providedCheckDigit;
    } catch (e) {
      return false;
    }
  }

  /// Generate a complete string with Luhn Mod-36 check digit
  ///
  /// [baseInput] should contain only alphanumeric characters
  /// Returns the complete string with check digit appended
  ///
  /// Example:
  /// ```dart
  /// final complete = LuhnMod36Checksum.generateWithCheckDigit('22AAAAA0000A1Z');
  /// // Returns '22AAAAA0000A1ZA' (with calculated check digit)
  /// ```
  static String generateWithCheckDigit(String baseInput) {
    final checkDigit = calculateCheckDigit(baseInput);
    return '$baseInput$checkDigit';
  }

  /// Validate GSTIN format and checksum
  ///
  /// GSTIN format: 15 characters
  /// - Positions 1-2: State code (01-37)
  /// - Positions 3-12: PAN of business entity
  /// - Position 13: Entity code (A-Z, 0-9)
  /// - Position 14: Default 'Z'
  /// - Position 15: Check digit (calculated using Luhn Mod-36)
  ///
  /// Example:
  /// ```dart
  /// final isValid = LuhnMod36Checksum.validateGSTIN('22AAAAA0000A1ZA');
  /// ```
  static bool validateGSTIN(String gstin) {
    if (gstin.length != 15) {
      return false;
    }

    // Basic format validation
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][0-9A-Z]Z[0-9A-Z]$').hasMatch(gstin)) {
      return false;
    }

    // State code validation (01-37, but some codes are reserved)
    final stateCode = int.tryParse(gstin.substring(0, 2));
    if (stateCode == null || stateCode < 1 || stateCode > 37) {
      return false;
    }

    // Validate using Luhn Mod-36 checksum
    return validate(gstin);
  }

  /// Generate a valid GSTIN with proper format
  ///
  /// [stateCode] State code (01-37)
  /// [panPrefix] First 5 characters of PAN (A-Z)
  /// [panSuffix] Last 4 characters of PAN (0-9)
  /// [panLastChar] Last character of PAN (A-Z)
  /// [entityCode] Entity code (A-Z, 0-9, default 'A' for individual)
  /// [random] Random number generator for PAN number part
  ///
  /// Returns a valid 15-character GSTIN
  static String generateGSTIN({
    required int stateCode,
    String? panPrefix,
    String? panSuffix,
    String? panLastChar,
    String entityCode = 'A',
    required Random random,
  }) {
    // Validate state code
    if (stateCode < 1 || stateCode > 37) {
      throw ArgumentError('State code must be between 01 and 37');
    }

    // Generate PAN components if not provided
    panPrefix ??= _generateRandomString(5, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', random);
    panSuffix ??= _generateRandomString(4, '0123456789', random);
    panLastChar ??= _generateRandomString(1, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', random);

    // Build GSTIN without check digit
    final stateCodeStr = stateCode.toString().padLeft(2, '0');
    final gstinWithoutCheck = '$stateCodeStr$panPrefix$panSuffix$panLastChar${entityCode}Z';

    // Calculate and append check digit
    return generateWithCheckDigit(gstinWithoutCheck);
  }

  /// Generate random string from character set
  static String _generateRandomString(int length, String chars, Random random) {
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }
}