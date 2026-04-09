import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/partnership_template.dart';

void main() {
  group('PartnershipTemplate', () {
    test('generate returns a valid partnership record', () {
      final record = PartnershipTemplate.generate(seed: 42);

      expect(record['template_type'], equals('partnership'));
      expect(record['firm_name'], isA<String>());
      expect(record['pan'], isA<String>());
      expect(record['gstin'], isA<String>());
      expect(record['partners'], isA<List>());
      
      expect(PartnershipTemplate.validate(record), isTrue);
    });

    test('generateBulk returns multiple valid records', () {
      final count = 3;
      final records = PartnershipTemplate.generateBulk(count: count, baseSeed: 123);

      expect(records.length, equals(count));
      for (final record in records) {
        expect(PartnershipTemplate.validate(record), isTrue);
      }
    });

    test('validate correctly identifies valid and invalid records', () {
      final validRecord = PartnershipTemplate.generate();
      expect(PartnershipTemplate.validate(validRecord), isTrue);

      final invalidRecord = Map<String, dynamic>.from(validRecord);
      invalidRecord['template_type'] = 'individual';
      expect(PartnershipTemplate.validate(invalidRecord), isFalse);
    });
  });
}
