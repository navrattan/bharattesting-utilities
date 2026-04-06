import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';
import 'package:bharattesting_core/src/data_faker/data/bank_codes.dart';
import 'package:bharattesting_core/src/data_faker/data/industry_codes.dart';

void main() {
  group('State Codes', () {
    test('has all 37 GSTIN state codes', () {
      expect(StateCodes.gstinStateCodes.length, equals(37));
      expect(StateCodes.gstinStateCodes.keys.toSet(), equals(Set.from(List.generate(37, (i) => i + 1))));
    });

    test('reverse mapping works correctly', () {
      for (final entry in StateCodes.gstinStateCodes.entries) {
        expect(StateCodes.getStateCode(entry.value), equals(entry.key));
        expect(StateCodes.getStateName(entry.key), equals(entry.value));
      }
    });

    test('validates state codes correctly', () {
      expect(StateCodes.isValidGSTINStateCode(1), isTrue);
      expect(StateCodes.isValidGSTINStateCode(36), isTrue);
      expect(StateCodes.isValidGSTINStateCode(37), isFalse); // Reserved
      expect(StateCodes.isValidGSTINStateCode(0), isFalse);
      expect(StateCodes.isValidGSTINStateCode(38), isFalse);
    });

    test('PIN code ranges are valid', () {
      for (final range in StateCodes.statePinRanges.values) {
        expect(range.length, equals(2));
        expect(range[0], lessThanOrEqualTo(range[1]));
        expect(range[0], greaterThan(100000));
        expect(range[1], lessThan(900000));
      }
    });

    test('gets state from PIN code', () {
      expect(StateCodes.getStateFromPin(110001), equals('Delhi'));
      expect(StateCodes.getStateFromPin(400001), equals('Maharashtra'));
      expect(StateCodes.getStateFromPin(560001), equals('Karnataka'));
      expect(StateCodes.getStateFromPin(999999), isNull);
    });

    test('generates random state code', () {
      final code = StateCodes.getRandomStateCode();
      expect(code, greaterThanOrEqualTo(1));
      expect(code, lessThanOrEqualTo(36));
      expect(code, isNot(equals(37))); // Should not return reserved code
    });

    test('generates PIN codes for states', () {
      final delhiPin = StateCodes.getRandomPinCode('Delhi');
      expect(delhiPin, greaterThanOrEqualTo(110001));
      expect(delhiPin, lessThanOrEqualTo(110097));

      final unknownPin = StateCodes.getRandomPinCode('Unknown State');
      expect(unknownPin, equals(110001)); // Default to Delhi
    });
  });

  group('Bank Codes', () {
    test('has valid IFSC prefixes', () {
      expect(BankCodes.bankIfscPrefixes.isNotEmpty, isTrue);

      for (final prefix in BankCodes.bankIfscPrefixes.values) {
        expect(prefix.length, equals(4));
        expect(RegExp(r'^[A-Z]{4}$').hasMatch(prefix), isTrue);
      }
    });

    test('reverse IFSC lookup works', () {
      for (final entry in BankCodes.bankIfscPrefixes.entries) {
        expect(BankCodes.getBankFromIfsc(entry.value), equals(entry.key));
        expect(BankCodes.getIfscPrefix(entry.key), equals(entry.value));
      }
    });

    test('generates valid IFSC codes', () {
      final ifsc = BankCodes.generateIfscCode('State Bank of India');
      expect(ifsc.length, equals(11));
      expect(ifsc, startsWith('SBIN'));
      expect(BankCodes.isValidIfscFormat(ifsc), isTrue);

      final unknownBankIfsc = BankCodes.generateIfscCode('Unknown Bank');
      expect(unknownBankIfsc, equals('SBIN0000001'));
    });

    test('validates IFSC format correctly', () {
      expect(BankCodes.isValidIfscFormat('SBIN0001234'), isTrue);
      expect(BankCodes.isValidIfscFormat('HDFC0001234'), isTrue);

      expect(BankCodes.isValidIfscFormat(''), isFalse);
      expect(BankCodes.isValidIfscFormat('SBIN001234'), isFalse); // Too short
      expect(BankCodes.isValidIfscFormat('SBIN00012345'), isFalse); // Too long
      expect(BankCodes.isValidIfscFormat('XXXX0001234'), isFalse); // Invalid prefix
    });

    test('has valid UPI handles', () {
      expect(BankCodes.upiHandles.isNotEmpty, isTrue);

      for (final handle in BankCodes.upiHandles) {
        expect(handle, startsWith('@'));
        expect(handle.length, greaterThan(1));
      }
    });

    test('validates UPI ID format', () {
      expect(BankCodes.isValidUpiIdFormat('user@paytm'), isTrue);
      expect(BankCodes.isValidUpiIdFormat('john123@googlepay'), isTrue);

      expect(BankCodes.isValidUpiIdFormat(''), isFalse);
      expect(BankCodes.isValidUpiIdFormat('userpaytm'), isFalse); // Missing @
      expect(BankCodes.isValidUpiIdFormat('user@@paytm'), isFalse); // Double @
      expect(BankCodes.isValidUpiIdFormat('user@unknown'), isFalse); // Invalid handle
    });

    test('generates UPI IDs correctly', () {
      final upiId1 = BankCodes.generateUpiId(name: 'John Doe');
      expect(upiId1, contains('@'));
      expect(upiId1, startsWith('johndoe'));

      final upiId2 = BankCodes.generateUpiId(
        name: 'Jane Smith',
        phoneNumber: '9876543210',
        bankName: 'State Bank of India',
      );
      expect(upiId2, contains('@'));
      expect(upiId2, startsWith('janesmith3210'));
      expect(BankCodes.isValidUpiIdFormat(upiId2), isTrue);
    });

    test('gets UPI handles for banks', () {
      final sbiHandles = BankCodes.getUpiHandles('State Bank of India');
      expect(sbiHandles, isNotEmpty);
      expect(sbiHandles, contains('@sbi'));

      final unknownBankHandles = BankCodes.getUpiHandles('Unknown Bank');
      expect(unknownBankHandles, equals(['@paytm']));
    });
  });

  group('Industry Codes', () {
    test('has valid NIC codes', () {
      expect(IndustryCodes.nicIndustryCodes.isNotEmpty, isTrue);

      for (final code in IndustryCodes.nicIndustryCodes.keys) {
        expect(code.length, equals(2));
        expect(RegExp(r'^\d{2}$').hasMatch(code), isTrue);
        expect(int.parse(code), greaterThan(0));
        expect(int.parse(code), lessThan(100));
      }
    });

    test('popular codes are subset of all codes', () {
      for (final code in IndustryCodes.popularIndustryCodes.keys) {
        expect(IndustryCodes.nicIndustryCodes.containsKey(code), isTrue);
      }
    });

    test('validates industry codes correctly', () {
      expect(IndustryCodes.isValidIndustryCode('62'), isTrue);
      expect(IndustryCodes.isValidIndustryCode('01'), isTrue);
      expect(IndustryCodes.isValidIndustryCode('1'), isTrue); // Should pad to '01'

      expect(IndustryCodes.isValidIndustryCode('00'), isFalse);
      expect(IndustryCodes.isValidIndustryCode('100'), isFalse);
      expect(IndustryCodes.isValidIndustryCode('abc'), isFalse);
    });

    test('gets industry descriptions', () {
      expect(
        IndustryCodes.getIndustryDescription('62'),
        equals('Computer programming, consultancy and related activities'),
      );
      expect(IndustryCodes.getIndustryDescription('1'), isNotNull); // Should pad to '01'
      expect(IndustryCodes.getIndustryDescription('999'), isNull);
    });

    test('generates random codes', () {
      final randomCode = IndustryCodes.getRandomIndustryCode();
      expect(IndustryCodes.isValidIndustryCode(randomCode), isTrue);

      final popularCode = IndustryCodes.getRandomPopularIndustryCode();
      expect(IndustryCodes.popularIndustryCodes.containsKey(popularCode), isTrue);
    });

    test('gets codes by section', () {
      final itCodes = IndustryCodes.getIndustryCodesBySection('IT');
      expect(itCodes, contains('62')); // Software
      expect(itCodes, contains('61')); // Telecommunications

      final manufacturingCodes = IndustryCodes.getIndustryCodesBySection('MANUFACTURING');
      expect(manufacturingCodes, contains('10')); // Food products
      expect(manufacturingCodes, contains('29')); // Motor vehicles

      final allCodes = IndustryCodes.getIndustryCodesBySection('UNKNOWN');
      expect(allCodes, equals(IndustryCodes.getAllIndustryCodes()));
    });

    test('categorizes business types correctly', () {
      expect(IndustryCodes.getBusinessCategory('62'), equals('Information & Communication'));
      expect(IndustryCodes.getBusinessCategory('10'), equals('Manufacturing'));
      expect(IndustryCodes.getBusinessCategory('64'), equals('Financial Services'));
      expect(IndustryCodes.getBusinessCategory('1'), equals('Agriculture & Forestry'));
    });

    test('all codes have valid categories', () {
      for (final code in IndustryCodes.getAllIndustryCodes()) {
        final category = IndustryCodes.getBusinessCategory(code);
        expect(category, isNotEmpty);
        expect(category, isNot(equals('Other'))); // All should have specific categories
      }
    });
  });
}