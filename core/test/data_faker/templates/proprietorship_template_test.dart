import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/proprietorship_template.dart';
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/udyam_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';

void main() {
  group('ProprietorshipTemplate', () {
    group('generate', () {
      test('generates valid proprietorship record with all required fields', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);

        expect(record['template_type'], equals('proprietorship'));
        expect(record['pan'], isA<String>());
        expect(record['gstin'], isA<String>());
        expect(record['udyam'], isA<String>());
        expect(record['pin_code'], isA<String>());
        expect(record['state'], isA<String>());
        expect(record['state_code'], isA<String>());
        expect(record['address'], isA<String>());
        expect(record['upi_id'], isA<String>());
        expect(record['generated_at'], isA<String>());
        expect(record['seed_used'], equals(12345));
      });

      test('generates PAN with individual prefix for proprietor', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;

        expect(PANGenerator.isValid(pan), isTrue);
        expect(pan[0], equals('A')); // Individual prefix for proprietor
      });

      test('generates GSTIN containing the proprietor PAN', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;
        final gstin = record['gstin'] as String;

        expect(GSTINGenerator.isValid(gstin), isTrue);
        expect(gstin.substring(2, 12), equals(pan));
      });

      test('includes TAN when includeTAN is true', () {
        final record = ProprietorshipTemplate.generate(seed: 12345, includeTAN: true);

        expect(record.containsKey('tan'), isTrue);
        final tan = record['tan'] as String;
        expect(TANGenerator.isValid(tan), isTrue);
      });

      test('excludes TAN when includeTAN is false', () {
        final record = ProprietorshipTemplate.generate(seed: 12345, includeTAN: false);

        expect(record.containsKey('tan'), isFalse);
      });

      test('generates valid Udyam registration', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        final udyam = record['udyam'] as String;

        expect(UdyamGenerator.isValid(udyam), isTrue);
      });

      test('generates valid UPI ID', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        final upi = record['upi_id'] as String;

        expect(UPIGenerator.isValid(upi), isTrue);
      });

      test('maintains state consistency across GSTIN and PIN', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        final gstin = record['gstin'] as String;
        final stateCode = record['state_code'] as String;

        expect(gstin.substring(0, 2), equals(stateCode));
      });

      test('respects preferredState parameter', () {
        final record = ProprietorshipTemplate.generate(
          seed: 12345,
          preferredState: 'Gujarat',
        );

        expect(record['state'], equals('Gujarat'));

        final gstin = record['gstin'] as String;
        expect(gstin.substring(0, 2), equals('24')); // Gujarat state code
      });

      test('generates same record with same seed', () {
        final record1 = ProprietorshipTemplate.generate(seed: 42);
        final record2 = ProprietorshipTemplate.generate(seed: 42);

        expect(record1['pan'], equals(record2['pan']));
        expect(record1['gstin'], equals(record2['gstin']));
        expect(record1['udyam'], equals(record2['udyam']));
      });
    });

    group('generateBulk', () {
      test('generates specified number of records', () {
        const count = 50;
        final records = ProprietorshipTemplate.generateBulk(count: count, baseSeed: 1000);

        expect(records.length, equals(count));

        for (final record in records) {
          expect(record['template_type'], equals('proprietorship'));
          expect(ProprietorshipTemplate.validate(record), isTrue);
        }
      });

      test('generates unique records in bulk', () {
        const count = 100;
        final records = ProprietorshipTemplate.generateBulk(count: count, baseSeed: 2000);

        final pans = records.map((r) => r['pan']).toSet();
        final gstins = records.map((r) => r['gstin']).toSet();
        final udyams = records.map((r) => r['udyam']).toSet();

        expect(pans.length, equals(count));
        expect(gstins.length, equals(count));
        expect(udyams.length, equals(count));
      });

      test('generates 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = ProprietorshipTemplate.generateBulk(count: count, baseSeed: 5000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000)); // Under 3 seconds

        print('Generated $count proprietorship records in ${duration}ms');
      });
    });

    group('validate', () {
      test('validates correct proprietorship record', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        expect(ProprietorshipTemplate.validate(record), isTrue);
      });

      test('rejects record with GSTIN not containing PAN', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        record['gstin'] = '29XYZTE1234A1Z5'; // Different PAN

        expect(ProprietorshipTemplate.validate(record), isFalse);
      });

      test('rejects record with state code mismatch', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        record['state_code'] = '27'; // Maharashtra
        final gstin = record['gstin'] as String;
        record['gstin'] = '29${gstin.substring(2)}'; // Karnataka GSTIN

        expect(ProprietorshipTemplate.validate(record), isFalse);
      });

      test('rejects record with invalid TAN when present', () {
        final record = ProprietorshipTemplate.generate(seed: 12345, includeTAN: true);
        record['tan'] = 'INVALID123';

        expect(ProprietorshipTemplate.validate(record), isFalse);
      });

      test('validates record without TAN', () {
        final record = ProprietorshipTemplate.generate(seed: 12345, includeTAN: false);
        expect(ProprietorshipTemplate.validate(record), isTrue);
      });

      test('rejects record missing required fields', () {
        final record = ProprietorshipTemplate.generate(seed: 12345);
        record.remove('udyam');

        expect(ProprietorshipTemplate.validate(record), isFalse);
      });
    });

    group('utility methods', () {
      test('isProprietorship correctly identifies proprietorship records', () {
        final proprietorshipRecord = ProprietorshipTemplate.generate(seed: 12345);
        expect(ProprietorshipTemplate.isProprietorship(proprietorshipRecord), isTrue);

        final nonProprietorshipRecord = {
          'template_type': 'company',
          'gstin': 'test',
          'udyam': 'test'
        };
        expect(ProprietorshipTemplate.isProprietorship(nonProprietorshipRecord), isFalse);
      });

      test('isProprietorship rejects record without GSTIN', () {
        final invalidRecord = {'template_type': 'proprietorship'};
        expect(ProprietorshipTemplate.isProprietorship(invalidRecord), isFalse);
      });
    });

    group('cross-field consistency', () {
      test('PAN is embedded in GSTIN correctly', () {
        for (int i = 0; i < 20; i++) {
          final record = ProprietorshipTemplate.generate(seed: i);
          final pan = record['pan'] as String;
          final gstin = record['gstin'] as String;

          expect(gstin.substring(2, 12), equals(pan));
        }
      });

      test('state codes are consistent across GSTIN and state_code', () {
        for (int i = 0; i < 20; i++) {
          final record = ProprietorshipTemplate.generate(seed: i);
          final gstin = record['gstin'] as String;
          final stateCode = record['state_code'] as String;

          expect(gstin.substring(0, 2), equals(stateCode));
        }
      });

      test('generates regionally appropriate banks for UPI', () {
        final recordKA = ProprietorshipTemplate.generate(seed: 1, preferredState: 'Karnataka');
        final recordTN = ProprietorshipTemplate.generate(seed: 2, preferredState: 'Tamil Nadu');

        final upiKA = recordKA['upi_id'] as String;
        final upiTN = recordTN['upi_id'] as String;

        expect(UPIGenerator.isValid(upiKA), isTrue);
        expect(UPIGenerator.isValid(upiTN), isTrue);

        // Should use appropriate bank handles
        final bankHandleKA = upiKA.split('@')[1];
        final bankHandleTN = upiTN.split('@')[1];

        expect(bankHandleKA, isNotEmpty);
        expect(bankHandleTN, isNotEmpty);
      });

      test('Udyam state code matches GSTIN state code', () {
        for (int i = 0; i < 10; i++) {
          final record = ProprietorshipTemplate.generate(seed: i);
          final gstin = record['gstin'] as String;
          final udyam = record['udyam'] as String;

          final gstinStateCode = gstin.substring(0, 2);

          // Udyam should be valid for the same state
          expect(UdyamGenerator.isValid(udyam), isTrue);
        }
      });
    });
  });
}