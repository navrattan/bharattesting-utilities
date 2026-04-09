import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/company_template.dart';

void main() {
  group('CompanyTemplate', () {
    test('generate returns a valid company record', () {
      final record = CompanyTemplate.generate(seed: 42);

      expect(record['template_type'], equals('company'));
      expect(record['company_name'], contains('Pvt Ltd'));
      expect(record['pan'], isA<String>());
      expect(record['gstin'], isA<String>());
      expect(record['cin'], isA<String>());
      expect(record['tan'], isA<String>());
      
      expect(CompanyTemplate.validate(record), isTrue);
    });

    test('generateBulk returns multiple valid records', () {
      final count = 3;
      final records = CompanyTemplate.generateBulk(count: count, baseSeed: 500);

      expect(records.length, equals(count));
      for (final record in records) {
        expect(CompanyTemplate.validate(record), isTrue);
      }
    });

    test('generate with preferredState uses that state', () {
      const state = 'Maharashtra';
      final record = CompanyTemplate.generate(preferredState: state);

      expect(record['state'], equals(state));
      expect(CompanyTemplate.validate(record), isTrue);
    });

    test('validate correctly identifies valid and invalid records', () {
      final validRecord = CompanyTemplate.generate();
      expect(CompanyTemplate.validate(validRecord), isTrue);

      final invalidRecord = Map<String, dynamic>.from(validRecord);
      invalidRecord['template_type'] = 'individual';
      expect(CompanyTemplate.validate(invalidRecord), isFalse);

      final mismatchedRecord = Map<String, dynamic>.from(validRecord);
      mismatchedRecord['state_code'] = '01';
      // If original was not 01, this should fail because GSTIN starts with state code
      if (validRecord['state_code'] != '01') {
        expect(CompanyTemplate.validate(mismatchedRecord), isFalse);
      }
    });
  });
}
