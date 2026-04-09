/// Luhn Mod-36 checksum algorithm implementation
///
/// Used for GSTIN (Goods and Services Tax Identification Number) validation in India.
library luhn_mod36;

import 'dart:math';

/// Luhn Mod-36 alphanumeric checksum implementation
class LuhnMod36Checksum {
  static const String _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Calculate the Luhn Mod-36 check digit for an alphanumeric string
  static String calculateCheckDigit(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }

    int sum = 0;
    for (int i = 0; i < input.length; i++) {
      final char = input[input.length - 1 - i].toUpperCase();
      final value = _chars.indexOf(char);
      if (value == -1) {
        throw ArgumentError('Invalid character in input: $char');
      }

      // Weight is 2 for characters immediately left of check digit, alternating
      final weight = (i % 2 == 0) ? 2 : 1;
      final product = value * weight;
      
      // Sum digits in base 36
      sum += (product ~/ 36) + (product % 36);
    }

    final checkValue = (36 - (sum % 36)) % 36;
    return _chars[checkValue];
  }

  /// Validate an alphanumeric string with its check digit
  static bool validate(String input) {
    if (input.length < 2) return false;
    
    final base = input.substring(0, input.length - 1);
    final check = input.substring(input.length - 1).toUpperCase();
    
    try {
      return calculateCheckDigit(base) == check;
    } catch (e) {
      return false;
    }
  }

  /// Alias for validate to maintain compatibility
  static bool validateGSTIN(String input) => validate(input);

  /// Generate a random valid GSTIN-style string
  static String generateGSTIN() {
    final random = Random();
    
    // State code (01-37)
    final state = (random.nextInt(37) + 1).toString().padLeft(2, '0');
    
    // PAN part (5 letters, 4 digits, 1 letter)
    final panLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final pan = List.generate(5, (_) => panLetters[random.nextInt(26)]).join() +
                List.generate(4, (_) => random.nextInt(10)).join() +
                panLetters[random.nextInt(26)];
    
    // Entity code (usually 1), Z (default), check digit
    final base = '${state}${pan}1Z';
    return base + calculateCheckDigit(base);
  }
}
