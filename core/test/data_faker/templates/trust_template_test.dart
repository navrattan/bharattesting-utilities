import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/trust_template.dart';

void main() {
  group('TrustTemplate', () {
    test('generate returns a valid trust record', () {
      final record = TrustTemplate.generate(seed: 42);

      expect(record['template_type'], equals('trust'));
      expect(record['trust_name'], isA<String>());
      expect(record['pan'], isA<String>());
      expect(record['gstin'], isA<String>());
      
      expect(TrustTemplate.validate(record), isTrue);
    });

    test('generateBulk returns multiple valid records', () {
      final count = 3;
      final records = TrustTemplate.generateBulk(count: count, baseSeed: 456);

      expect(records.length, equals(count));
      for (final record in records) {
        expect(TrustTemplate.validate(record), isTrue);
      }
    });

    test('validate correctly identifies valid and invalid records', () {
      final validRecord = TrustTemplate.generate();
      expect(TrustTemplate.validate(validRecord), isTrue);

      final invalidRecord = Map<String, dynamic>.from(validRecord);
      invalidRecord['template_type'] = 'individual';
      expect(TrustTemplate.validate(invalidRecord), isFalse);
    });
  });
}
