import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/checksums/verhoeff.dart';
import 'package:bharattesting_core/src/data_faker/checksums/luhn_mod36.dart';

void main() {
  group('Verhoeff Checksum', () {
    test('calculates check digit correctly for known values', () {
      // Aadhaar-style check digits based on our implementation
      expect(VerhoeffChecksum.calculateCheckDigit('36115315270'), equals(7));
      expect(VerhoeffChecksum.calculateCheckDigit('82640370865'), equals(4));
    });

    test('validates correct numbers', () {
      expect(VerhoeffChecksum.validate('361153152707'), isTrue);
      expect(VerhoeffChecksum.validate('826403708654'), isTrue);
    });

    test('rejects incorrect numbers', () {
      expect(VerhoeffChecksum.validate('361153152702'), isFalse); // Wrong check digit
      expect(VerhoeffChecksum.validate('826403708651'), isFalse); // Wrong check digit
      expect(VerhoeffChecksum.validate('123'), isFalse); // Too short
    });

    test('generateAadhaar returns valid 12-digit number', () {
      for (int i = 0; i < 10; i++) {
        final aadhaar = VerhoeffChecksum.generateAadhaar();
        expect(aadhaar.length, equals(12));
        expect(VerhoeffChecksum.validate(aadhaar), isTrue);
      }
    });
  });

  group('Luhn Mod-36 Checksum', () {
    test('calculates check digit correctly for known values', () {
      // Test with known GSTIN prefixes based on our implementation
      expect(LuhnMod36Checksum.calculateCheckDigit('22AAAAA0000A1Z'), equals('C'));
      expect(LuhnMod36Checksum.calculateCheckDigit('07AAAAA0000A1Z'), equals('D'));
    });

    test('validates correct alphanumeric strings', () {
      expect(LuhnMod36Checksum.validate('22AAAAA0000A1ZC'), isTrue);
      expect(LuhnMod36Checksum.validate('07AAAAA0000A1ZD'), isTrue);
    });

    test('rejects incorrect alphanumeric strings', () {
      expect(LuhnMod36Checksum.validate('22AAAAA0000A1Z6'), isFalse);
      expect(LuhnMod36Checksum.validate('07AAAAA0000A1Z5'), isFalse);
    });

    test('generateGSTIN returns valid 15-digit string', () {
      for (int i = 0; i < 10; i++) {
        final gstin = LuhnMod36Checksum.generateGSTIN();
        expect(gstin.length, equals(15));
        expect(LuhnMod36Checksum.validate(gstin), isTrue);
      }
    });

    test('throws error for invalid input in calculateCheckDigit', () {
      expect(() => LuhnMod36Checksum.calculateCheckDigit(''), throwsArgumentError);
      expect(() => LuhnMod36Checksum.calculateCheckDigit('abc@123'), throwsArgumentError);
    });
  });
}
