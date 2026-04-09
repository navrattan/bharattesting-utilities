import 'dart:math';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/individual_template.dart';
import 'package:bharattesting_core/src/data_faker/aadhaar_generator.dart';
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';

void main() {
  group('IndividualTemplate', () {
    test('generate returns a valid individual record', () {
      final record = IndividualTemplate.generate(seed: 42);

      expect(record['template_type'], equals('individual'));
      expect(record['name'], isA<String>());
      expect(record['pan'], isA<String>());
      expect(record['aadhaar'], isA<String>());
      expect(record['pin_code'], isA<String>());
      expect(record['state'], isA<String>());
      
      expect(IndividualTemplate.validate(record), isTrue);
    });

    test('generateBulk returns multiple valid records', () {
      final count = 5;
      final records = IndividualTemplate.generateBulk(count: count, baseSeed: 100);

      expect(records.length, equals(count));
      for (final record in records) {
        expect(IndividualTemplate.validate(record), isTrue);
      }
    });

    test('generate with preferredState uses that state', () {
      const state = 'Karnataka';
      final record = IndividualTemplate.generate(preferredState: state);

      expect(record['state'], equals(state));
      // PIN should match state
      expect(IndividualTemplate.validate(record), isTrue);
    });

    test('validate correctly identifies valid and invalid records', () {
      final validRecord = IndividualTemplate.generate();
      expect(IndividualTemplate.validate(validRecord), isTrue);

      final invalidRecord = Map<String, dynamic>.from(validRecord);
      invalidRecord['template_type'] = 'company';
      expect(IndividualTemplate.validate(invalidRecord), isFalse);

      final wrongPanRecord = Map<String, dynamic>.from(validRecord);
      wrongPanRecord['pan'] = 'INVALID123';
      expect(IndividualTemplate.validate(wrongPanRecord), isFalse);
    });
  });
}
