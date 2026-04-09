import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/proprietorship_template.dart';

void main() {
  group('ProprietorshipTemplate', () {
    test('generate returns a valid proprietorship record', () {
      final record = ProprietorshipTemplate.generate(seed: 42);

      expect(record['template_type'], equals('proprietorship'));
      expect(record['business_name'], isA<String>());
      expect(record['owner_name'], isA<String>());
      expect(record['pan'], isA<String>());
      expect(record['gstin'], isA<String>());
      
      expect(ProprietorshipTemplate.validate(record), isTrue);
    });

    test('generateBulk returns multiple valid records', () {
      final count = 3;
      final records = ProprietorshipTemplate.generateBulk(count: count, baseSeed: 789);

      expect(records.length, equals(count));
      for (final record in records) {
        expect(ProprietorshipTemplate.validate(record), isTrue);
      }
    });

    test('validate correctly identifies valid and invalid records', () {
      final validRecord = ProprietorshipTemplate.generate();
      expect(ProprietorshipTemplate.validate(validRecord), isTrue);

      final invalidRecord = Map<String, dynamic>.from(validRecord);
      invalidRecord['template_type'] = 'individual';
      expect(ProprietorshipTemplate.validate(invalidRecord), isFalse);
    });
  });
}
