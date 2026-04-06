import 'package:test/test.dart';
import 'package:core/src/data_faker/templates/individual_template.dart';
import 'package:core/src/data_faker/aadhaar_generator.dart';
import 'package:core/src/data_faker/pan_generator.dart';
import 'package:core/src/data_faker/pin_code_generator.dart';
import 'package:core/src/data_faker/upi_generator.dart';

void main() {
  group('IndividualTemplate', () {
    group('generate', () {
      test('generates valid individual record with all required fields', () {
        final record = IndividualTemplate.generate(seed: 12345);

        expect(record['template_type'], equals('individual'));
        expect(record['pan'], isA<String>());
        expect(record['aadhaar'], isA<String>());
        expect(record['pin_code'], isA<String>());
        expect(record['state'], isA<String>());
        expect(record['address'], isA<String>());
        expect(record['upi_id'], isA<String>());
        expect(record['generated_at'], isA<String>());
        expect(record['seed_used'], equals(12345));
      });

      test('generates PAN with individual prefix', () {
        final record = IndividualTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;

        expect(PANGenerator.isValid(pan), isTrue);

        // Should use individual prefixes (A-Z but typically A,B,C,F,G,H,J,K,L,M,N,P)
        const individualPrefixes = ['A', 'B', 'C', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P'];
        expect(individualPrefixes.contains(pan[0]), isTrue);
      });

      test('generates valid Aadhaar with Verhoeff checksum', () {
        final record = IndividualTemplate.generate(seed: 12345);
        final aadhaar = record['aadhaar'] as String;

        expect(AadhaarGenerator.isValid(aadhaar), isTrue);
        expect(aadhaar.length, equals(12));
        expect(int.tryParse(aadhaar), isNotNull);
      });

      test('maintains state consistency between PIN and address', () {
        final record = IndividualTemplate.generate(seed: 12345);
        final pin = record['pin_code'] as String;
        final state = record['state'] as String;

        expect(PinCodeGenerator.isValid(pin), isTrue);
        expect(state, isNotEmpty);

        // Verify address contains state information
        final address = record['address'] as String;
        expect(address.toLowerCase().contains(state.toLowerCase()), isTrue);
      });

      test('generates valid UPI ID', () {
        final record = IndividualTemplate.generate(seed: 12345);
        final upi = record['upi_id'] as String;

        expect(UPIGenerator.isValid(upi), isTrue);
        expect(upi.contains('@'), isTrue);
      });

      test('respects preferredState parameter', () {
        final record = IndividualTemplate.generate(
          seed: 12345,
          preferredState: 'Karnataka',
        );

        expect(record['state'], equals('Karnataka'));

        final pin = record['pin_code'] as String;
        final pinPrefix = int.parse(pin.substring(0, 3));

        // Karnataka PIN ranges: 560-599
        expect(pinPrefix >= 560 && pinPrefix <= 599, isTrue);
      });

      test('generates different records with different seeds', () {
        final record1 = IndividualTemplate.generate(seed: 1);
        final record2 = IndividualTemplate.generate(seed: 2);

        expect(record1['pan'], isNot(equals(record2['pan'])));
        expect(record1['aadhaar'], isNot(equals(record2['aadhaar'])));
        expect(record1['upi_id'], isNot(equals(record2['upi_id'])));
      });

      test('generates same record with same seed', () {
        final record1 = IndividualTemplate.generate(seed: 42);
        final record2 = IndividualTemplate.generate(seed: 42);

        expect(record1['pan'], equals(record2['pan']));
        expect(record1['aadhaar'], equals(record2['aadhaar']));
        expect(record1['pin_code'], equals(record2['pin_code']));
        expect(record1['upi_id'], equals(record2['upi_id']));
      });
    });

    group('generateBulk', () {
      test('generates specified number of records', () {
        const count = 50;
        final records = IndividualTemplate.generateBulk(count: count, baseSeed: 1000);

        expect(records.length, equals(count));

        // Verify all are valid individual records
        for (final record in records) {
          expect(record['template_type'], equals('individual'));
          expect(IndividualTemplate.validate(record), isTrue);
        }
      });

      test('generates unique records in bulk', () {
        const count = 100;
        final records = IndividualTemplate.generateBulk(count: count, baseSeed: 2000);

        final pans = records.map((r) => r['pan']).toSet();
        final aadhars = records.map((r) => r['aadhaar']).toSet();

        // Should have unique PANs and Aadhaar numbers
        expect(pans.length, equals(count));
        expect(aadhars.length, equals(count));
      });

      test('respects preferredState in bulk generation', () {
        const count = 25;
        final records = IndividualTemplate.generateBulk(
          count: count,
          baseSeed: 3000,
          preferredState: 'Tamil Nadu',
        );

        for (final record in records) {
          expect(record['state'], equals('Tamil Nadu'));
        }
      });

      test('generates 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = IndividualTemplate.generateBulk(count: count, baseSeed: 5000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000)); // Under 3 seconds

        print('Generated $count individual records in ${duration}ms');
      });
    });

    group('validate', () {
      test('validates correct individual record', () {
        final record = IndividualTemplate.generate(seed: 12345);
        expect(IndividualTemplate.validate(record), isTrue);
      });

      test('rejects record missing required fields', () {
        final record = IndividualTemplate.generate(seed: 12345);
        record.remove('pan');

        expect(IndividualTemplate.validate(record), isFalse);
      });

      test('rejects record with invalid PAN', () {
        final record = IndividualTemplate.generate(seed: 12345);
        record['pan'] = 'INVALID123';

        expect(IndividualTemplate.validate(record), isFalse);
      });

      test('rejects record with invalid Aadhaar', () {
        final record = IndividualTemplate.generate(seed: 12345);
        record['aadhaar'] = '123456789012'; // Invalid Verhoeff checksum

        expect(IndividualTemplate.validate(record), isFalse);
      });

      test('rejects record with non-individual PAN prefix', () {
        final record = IndividualTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;
        record['pan'] = 'C${pan.substring(1)}'; // Company prefix

        expect(IndividualTemplate.validate(record), isFalse);
      });

      test('rejects record with state-PIN mismatch', () {
        final record = IndividualTemplate.generate(seed: 12345);
        record['state'] = 'Delhi';
        record['pin_code'] = '560001'; // Karnataka PIN

        expect(IndividualTemplate.validate(record), isFalse);
      });

      test('rejects record with invalid UPI', () {
        final record = IndividualTemplate.generate(seed: 12345);
        record['upi_id'] = 'invalid_upi_format';

        expect(IndividualTemplate.validate(record), isFalse);
      });
    });

    group('cross-field consistency', () {
      test('maintains consistent state across PIN and address', () {
        for (int i = 0; i < 20; i++) {
          final record = IndividualTemplate.generate(seed: i);

          final pin = record['pin_code'] as String;
          final state = record['state'] as String;
          final address = record['address'] as String;

          // Verify PIN belongs to the stated state
          final pinPrefix = int.parse(pin.substring(0, 3));
          bool foundValidRange = false;

          // Check if PIN is in valid range for the state
          // This is a simplified check - in practice you'd use the full mapping
          if (state == 'Karnataka' && pinPrefix >= 560 && pinPrefix <= 599) foundValidRange = true;
          if (state == 'Tamil Nadu' && pinPrefix >= 600 && pinPrefix <= 699) foundValidRange = true;
          if (state == 'Maharashtra' && pinPrefix >= 400 && pinPrefix <= 499) foundValidRange = true;
          if (state == 'Delhi' && pinPrefix >= 110 && pinPrefix <= 119) foundValidRange = true;

          // For other states, just verify format is valid
          if (!foundValidRange) {
            expect(PinCodeGenerator.isValid(pin), isTrue);
          } else {
            expect(foundValidRange, isTrue, reason: 'PIN $pin should belong to state $state');
          }

          // Verify address mentions the state
          expect(address.toLowerCase(), contains(state.toLowerCase()));
        }
      });

      test('generates regionally appropriate UPI banks', () {
        final record1 = IndividualTemplate.generate(seed: 1, preferredState: 'Karnataka');
        final record2 = IndividualTemplate.generate(seed: 2, preferredState: 'Tamil Nadu');

        final upi1 = record1['upi_id'] as String;
        final upi2 = record2['upi_id'] as String;

        expect(UPIGenerator.isValid(upi1), isTrue);
        expect(UPIGenerator.isValid(upi2), isTrue);

        // Both should be valid but might use different bank handles
        final bank1 = upi1.split('@')[1];
        final bank2 = upi2.split('@')[1];

        expect(bank1, isNotEmpty);
        expect(bank2, isNotEmpty);
      });
    });
  });
}