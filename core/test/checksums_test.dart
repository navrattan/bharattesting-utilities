import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/checksums/verhoeff.dart';
import 'package:bharattesting_core/src/data_faker/checksums/luhn_mod36.dart';

void main() {
  group('Verhoeff Checksum', () {
    test('calculates check digit correctly for known values', () {
      // Known test cases for Verhoeff algorithm
      expect(VerhoeffChecksum.calculateCheckDigit('123456789012'), equals(0));
      expect(VerhoeffChecksum.calculateCheckDigit('236407'), equals(1));
      expect(VerhoeffChecksum.calculateCheckDigit('8473643'), equals(2));
      expect(VerhoeffChecksum.calculateCheckDigit('12345678901'), equals(4));
    });

    test('validates correct numbers', () {
      expect(VerhoeffChecksum.validate('1234567890120'), isTrue);
      expect(VerhoeffChecksum.validate('2364071'), isTrue);
      expect(VerhoeffChecksum.validate('84736432'), isTrue);
      expect(VerhoeffChecksum.validate('123456789014'), isTrue);
    });

    test('rejects incorrect numbers', () {
      expect(VerhoeffChecksum.validate('1234567890121'), isFalse);
      expect(VerhoeffChecksum.validate('2364072'), isFalse);
      expect(VerhoeffChecksum.validate('84736431'), isFalse);
      expect(VerhoeffChecksum.validate('123456789015'), isFalse);
    });

    test('rejects empty or invalid input', () {
      expect(VerhoeffChecksum.validate(''), isFalse);
      expect(VerhoeffChecksum.validate('abc123'), isFalse);
      expect(VerhoeffChecksum.validate('123.456'), isFalse);
      expect(VerhoeffChecksum.validate('1'), isFalse);
    });

    test('generates complete number with check digit', () {
      final result = VerhoeffChecksum.generateWithCheckDigit('123456789012');
      expect(result, equals('1234567890120'));
      expect(VerhoeffChecksum.validate(result), isTrue);
    });

    test('generates valid Aadhaar numbers', () {
      final random = Random(42); // Fixed seed for reproducible tests

      for (int i = 0; i < 10; i++) {
        final aadhaar = VerhoeffChecksum.generateAadhaarNumber(random);

        // Should be 13 digits
        expect(aadhaar.length, equals(13));

        // Should be all digits
        expect(RegExp(r'^\d{13}$').hasMatch(aadhaar), isTrue);

        // First digit should not be 0 or 1
        final firstDigit = int.parse(aadhaar[0]);
        expect(firstDigit, greaterThanOrEqualTo(2));

        // Should pass Verhoeff validation
        expect(VerhoeffChecksum.validate(aadhaar), isTrue);
      }
    });

    test('seed reproducibility', () {
      final random1 = Random(123);
      final random2 = Random(123);

      final aadhaar1 = VerhoeffChecksum.generateAadhaarNumber(random1);
      final aadhaar2 = VerhoeffChecksum.generateAadhaarNumber(random2);

      expect(aadhaar1, equals(aadhaar2));
    });

    test('throws ArgumentError for invalid input in calculateCheckDigit', () {
      expect(() => VerhoeffChecksum.calculateCheckDigit(''), throwsArgumentError);
      expect(() => VerhoeffChecksum.calculateCheckDigit('abc'), throwsArgumentError);
      expect(() => VerhoeffChecksum.calculateCheckDigit('123.456'), throwsArgumentError);
    });
  });

  group('Luhn Mod-36 Checksum', () {
    test('calculates check digit correctly for known values', () {
      // Test with numeric values
      expect(LuhnMod36Checksum.calculateCheckDigit('123456789012345'), equals('B'));
      expect(LuhnMod36Checksum.calculateCheckDigit('1234567890'), equals('E'));

      // Test with alphanumeric values
      expect(LuhnMod36Checksum.calculateCheckDigit('22AAAAA0000A1Z'), equals('5'));
    });

    test('validates correct alphanumeric strings', () {
      expect(LuhnMod36Checksum.validate('123456789012345B'), isTrue);
      expect(LuhnMod36Checksum.validate('1234567890E'), isTrue);
      expect(LuhnMod36Checksum.validate('22AAAAA0000A1Z5'), isTrue);
    });

    test('rejects incorrect alphanumeric strings', () {
      expect(LuhnMod36Checksum.validate('123456789012345C'), isFalse);
      expect(LuhnMod36Checksum.validate('1234567890F'), isFalse);
      expect(LuhnMod36Checksum.validate('22AAAAA0000A1Z6'), isFalse);
    });

    test('rejects empty or invalid input', () {
      expect(LuhnMod36Checksum.validate(''), isFalse);
      expect(LuhnMod36Checksum.validate('abc@123'), isFalse);
      expect(LuhnMod36Checksum.validate('123.456'), isFalse);
      expect(LuhnMod36Checksum.validate('1'), isFalse);
    });

    test('generates complete string with check digit', () {
      final result = LuhnMod36Checksum.generateWithCheckDigit('22AAAAA0000A1Z');
      expect(result, equals('22AAAAA0000A1Z5'));
      expect(LuhnMod36Checksum.validate(result), isTrue);
    });

    test('validates GSTIN format', () {
      // Generate valid GSTIN
      final random = Random(42);
      final gstin = LuhnMod36Checksum.generateGSTIN(
        stateCode: 22, // Gujarat
        random: random,
      );

      expect(gstin.length, equals(15));
      expect(LuhnMod36Checksum.validateGSTIN(gstin), isTrue);

      // Test invalid format
      expect(LuhnMod36Checksum.validateGSTIN('invalid'), isFalse);
      expect(LuhnMod36Checksum.validateGSTIN('22AAAAA0000A1Z'), isFalse); // Too short
      expect(LuhnMod36Checksum.validateGSTIN('00AAAAA0000A1Z5'), isFalse); // Invalid state code
    });

    test('generates valid GSTIN with custom parameters', () {
      final random = Random(42);
      final gstin = LuhnMod36Checksum.generateGSTIN(
        stateCode: 9, // Uttar Pradesh
        panPrefix: 'ABCDE',
        panSuffix: '1234',
        panLastChar: 'F',
        entityCode: 'B',
        random: random,
      );

      expect(gstin, startsWith('09ABCDE1234FB'));
      expect(gstin.length, equals(15));
      expect(LuhnMod36Checksum.validateGSTIN(gstin), isTrue);
    });

    test('GSTIN seed reproducibility', () {
      final random1 = Random(456);
      final random2 = Random(456);

      final gstin1 = LuhnMod36Checksum.generateGSTIN(
        stateCode: 27, // Maharashtra
        random: random1,
      );
      final gstin2 = LuhnMod36Checksum.generateGSTIN(
        stateCode: 27,
        random: random2,
      );

      expect(gstin1, equals(gstin2));
    });

    test('throws ArgumentError for invalid state code', () {
      final random = Random();

      expect(
        () => LuhnMod36Checksum.generateGSTIN(stateCode: 0, random: random),
        throwsArgumentError,
      );
      expect(
        () => LuhnMod36Checksum.generateGSTIN(stateCode: 38, random: random),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for invalid input in calculateCheckDigit', () {
      expect(() => LuhnMod36Checksum.calculateCheckDigit(''), throwsArgumentError);
      expect(() => LuhnMod36Checksum.calculateCheckDigit('abc@123'), throwsArgumentError);
    });
  });
}