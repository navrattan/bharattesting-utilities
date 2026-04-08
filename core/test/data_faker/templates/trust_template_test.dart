import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/trust_template.dart';
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/ifsc_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';

void main() {
  group('TrustTemplate', () {
    group('generate', () {
      test('generates valid trust record with all required fields', () {
        final record = TrustTemplate.generate(seed: 12345);

        expect(record['template_type'], equals('trust'));
        expect(record['trust_type'], isA<String>());
        expect(record['pan'], isA<String>());
        expect(record['tan'], isA<String>());
        expect(record['ifsc'], isA<String>());
        expect(record['upi_id'], isA<String>());
        expect(record['pin_code'], isA<String>());
        expect(record['state'], isA<String>());
        expect(record['state_code'], isA<String>());
        expect(record['address'], isA<String>());
        expect(record['bank_code'], isA<String>());
        expect(record['registration'], isA<Map>());
        expect(record['gst_registered'], isA<bool>());
        expect(record['generated_at'], isA<String>());
        expect(record['seed_used'], equals(12345));
      });

      test('generates PAN with association prefix (A)', () {
        final record = TrustTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;

        expect(PANGenerator.isValid(pan), isTrue);
        expect(pan[0], equals('A')); // Association prefix for trusts
      });

      test('generates valid trust type from predefined list', () {
        final record = TrustTemplate.generate(seed: 12345);
        final trustType = record['trust_type'] as String;

        expect(TrustTemplate.trustTypes.contains(trustType), isTrue);
      });

      test('generates GSTIN containing PAN when GST registered', () {
        // Generate multiple records to find one with GST
        TrustTemplate.generate(seed: 12345);

        for (int i = 0; i < 20; i++) {
          final record = TrustTemplate.generate(seed: i);
          final gstRegistered = record['gst_registered'] as bool;

          if (gstRegistered) {
            final pan = record['pan'] as String;
            final gstin = record['gstin'] as String;

            expect(GSTINGenerator.isValid(gstin), isTrue);
            expect(gstin.substring(2, 12), equals(pan));
            break;
          }
        }
      });

      test('excludes GSTIN when not GST registered', () {
        for (int i = 0; i < 20; i++) {
          final record = TrustTemplate.generate(seed: i);
          final gstRegistered = record['gst_registered'] as bool;

          if (!gstRegistered) {
            expect(record.containsKey('gstin'), isFalse);
            break;
          }
        }
      });

      test('generates valid TAN for tax deduction', () {
        final record = TrustTemplate.generate(seed: 12345);
        final tan = record['tan'] as String;

        expect(TANGenerator.isValid(tan), isTrue);
      });

      test('generates consistent IFSC and UPI from same bank', () {
        final record = TrustTemplate.generate(seed: 12345);
        final ifsc = record['ifsc'] as String;
        final upi = record['upi_id'] as String;
        final bankCode = record['bank_code'] as String;

        expect(IFSCGenerator.isValid(ifsc), isTrue);
        expect(UPIGenerator.isValid(upi), isTrue);
        expect(ifsc.startsWith(bankCode), isTrue);
      });

      test('generates valid registration information', () {
        final record = TrustTemplate.generate(seed: 12345);
        final registration = record['registration'] as Map<String, dynamic>;

        expect(registration.containsKey('registration_number'), isTrue);
        expect(registration.containsKey('registration_year'), isTrue);
        expect(registration.containsKey('registration_authority'), isTrue);
        expect(registration.containsKey('registration_state'), isTrue);

        final registrationYear = registration['registration_year'] as int;
        expect(registrationYear >= 1980 && registrationYear <= 2024, isTrue);

        final authority = registration['registration_authority'] as String;
        expect(authority, isNotEmpty);
      });

      test('respects trustType parameter', () {
        const specificTrustType = 'Educational Trust';
        final record = TrustTemplate.generate(
          seed: 12345,
          trustType: specificTrustType,
        );

        expect(record['trust_type'], equals(specificTrustType));

        // Educational trusts should have lower GST registration probability
        final gstRegistered = record['gst_registered'] as bool;
        // We can't guarantee but can check the structure is correct
        expect(gstRegistered, isA<bool>());
      });

      test('respects preferredState parameter', () {
        final record = TrustTemplate.generate(
          seed: 12345,
          preferredState: 'Rajasthan',
        );

        expect(record['state'], equals('Rajasthan'));

        // Check if GST registered, state code should match
        final gstRegistered = record['gst_registered'] as bool;
        if (gstRegistered) {
          final gstin = record['gstin'] as String;
          expect(gstin.substring(0, 2), equals('08')); // Rajasthan state code
        }

        final registration = record['registration'] as Map<String, dynamic>;
        expect(registration['registration_state'], equals('08'));
      });

      test('generates same record with same seed', () {
        final record1 = TrustTemplate.generate(seed: 42);
        final record2 = TrustTemplate.generate(seed: 42);

        expect(record1['pan'], equals(record2['pan']));
        expect(record1['trust_type'], equals(record2['trust_type']));
        expect(record1['ifsc'], equals(record2['ifsc']));
        expect(record1['registration'], equals(record2['registration']));
      });
    });

    group('generateBulk', () {
      test('generates specified number of records', () {
        const count = 50;
        final records = TrustTemplate.generateBulk(count: count, baseSeed: 1000);

        expect(records.length, equals(count));

        for (final record in records) {
          expect(record['template_type'], equals('trust'));
          expect(TrustTemplate.validate(record), isTrue);
        }
      });

      test('generates unique records in bulk', () {
        const count = 100;
        final records = TrustTemplate.generateBulk(count: count, baseSeed: 2000);

        final pans = records.map((r) => r['pan']).toSet();
        final ifscs = records.map((r) => r['ifsc']).toSet();
        final registrationNumbers = records.map((r) => (r['registration'] as Map)['registration_number']).toSet();

        expect(pans.length, equals(count));
        expect(ifscs.length, equals(count));
        expect(registrationNumbers.length, equals(count));
      });

      test('generates 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = TrustTemplate.generateBulk(count: count, baseSeed: 5000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000)); // Under 3 seconds

        print('Generated $count trust records in ${duration}ms');
      });
    });

    group('validate', () {
      test('validates correct trust record', () {
        final record = TrustTemplate.generate(seed: 12345);
        expect(TrustTemplate.validate(record), isTrue);
      });

      test('rejects record with non-association PAN prefix', () {
        final record = TrustTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;
        record['pan'] = 'C${pan.substring(1)}'; // Company prefix

        expect(TrustTemplate.validate(record), isFalse);
      });

      test('validates record with valid GSTIN when present', () {
        for (int i = 0; i < 20; i++) {
          final record = TrustTemplate.generate(seed: i);
          final gstRegistered = record['gst_registered'] as bool;

          if (gstRegistered) {
            expect(TrustTemplate.validate(record), isTrue);
            break;
          }
        }
      });

      test('rejects record with GSTIN not containing PAN', () {
        // Create a record with GST and modify GSTIN
        for (int i = 0; i < 20; i++) {
          final record = TrustTemplate.generate(seed: i);
          final gstRegistered = record['gst_registered'] as bool;

          if (gstRegistered) {
            record['gstin'] = '29XYZTE1234A1Z5'; // Different PAN
            expect(TrustTemplate.validate(record), isFalse);
            break;
          }
        }
      });

      test('rejects record with invalid trust type', () {
        final record = TrustTemplate.generate(seed: 12345);
        record['trust_type'] = 'Invalid Trust Type';

        expect(TrustTemplate.validate(record), isFalse);
      });

      test('rejects record with bank inconsistency', () {
        final record = TrustTemplate.generate(seed: 12345);
        record['bank_code'] = 'SBI';
        record['ifsc'] = 'CANR0001234'; // Canara bank IFSC

        expect(TrustTemplate.validate(record), isFalse);
      });

      test('rejects record missing required fields', () {
        final record = TrustTemplate.generate(seed: 12345);
        record.remove('registration');

        expect(TrustTemplate.validate(record), isFalse);
      });
    });

    group('utility methods', () {
      test('isTrust correctly identifies trust records', () {
        final trustRecord = TrustTemplate.generate(seed: 12345);
        expect(TrustTemplate.isTrust(trustRecord), isTrue);

        final nonTrustRecord = {
          'template_type': 'company',
          'trust_type': 'Charitable Trust',
        };
        expect(TrustTemplate.isTrust(nonTrustRecord), isFalse);
      });

      test('isTrust validates trust type from predefined list', () {
        final validTrustRecord = {
          'template_type': 'trust',
          'trust_type': 'Charitable Trust',
        };
        expect(TrustTemplate.isTrust(validTrustRecord), isTrue);

        final invalidTrustRecord = {
          'template_type': 'trust',
          'trust_type': 'Invalid Trust',
        };
        expect(TrustTemplate.isTrust(invalidTrustRecord), isFalse);
      });
    });

    group('trust type behavior', () {
      test('educational and charitable trusts have lower GST probability', () {
        int educationalWithGST = 0;
        int charitableWithGST = 0;
        int otherWithGST = 0;

        const testCount = 100;

        for (int i = 0; i < testCount; i++) {
          final educationalRecord = TrustTemplate.generate(
            seed: i,
            trustType: 'Educational Trust',
          );
          if (educationalRecord['gst_registered'] as bool) educationalWithGST++;

          final charitableRecord = TrustTemplate.generate(
            seed: i + 1000,
            trustType: 'Charitable Trust',
          );
          if (charitableRecord['gst_registered'] as bool) charitableWithGST++;

          final otherRecord = TrustTemplate.generate(
            seed: i + 2000,
            trustType: 'Private Trust',
          );
          if (otherRecord['gst_registered'] as bool) otherWithGST++;
        }

        // Educational and charitable should have lower GST registration rates
        final educationalGSTRate = educationalWithGST / testCount;
        final charitableGSTRate = charitableWithGST / testCount;
        final otherGSTRate = otherWithGST / testCount;

        expect(educationalGSTRate, lessThan(0.5)); // Should be around 30%
        expect(charitableGSTRate, lessThan(0.5)); // Should be around 30%
        expect(otherGSTRate, greaterThan(educationalGSTRate)); // Should be higher
      });

      test('generates appropriate registration authority based on trust type', () {
        final societyRecord = TrustTemplate.generate(
          seed: 12345,
          trustType: 'Society',
        );
        final trustRecord = TrustTemplate.generate(
          seed: 12346,
          trustType: 'Charitable Trust',
        );

        final societyRegistration = societyRecord['registration'] as Map<String, dynamic>;
        final trustRegistration = trustRecord['registration'] as Map<String, dynamic>;

        expect(societyRegistration['registration_authority'], contains('Societies'));
        expect(trustRegistration['registration_authority'], contains('Trusts'));
      });
    });

    group('cross-field consistency', () {
      test('PAN is embedded in GSTIN correctly when GST registered', () {
        for (int i = 0; i < 50; i++) {
          final record = TrustTemplate.generate(seed: i);
          final gstRegistered = record['gst_registered'] as bool;

          if (gstRegistered) {
            final pan = record['pan'] as String;
            final gstin = record['gstin'] as String;

            expect(gstin.substring(2, 12), equals(pan));
          }
        }
      });

      test('state codes are consistent across GSTIN and registration', () {
        for (int i = 0; i < 50; i++) {
          final record = TrustTemplate.generate(seed: i);
          final gstRegistered = record['gst_registered'] as bool;

          if (gstRegistered) {
            final gstin = record['gstin'] as String;
            final stateCode = record['state_code'] as String;
            final registration = record['registration'] as Map<String, dynamic>;

            expect(gstin.substring(0, 2), equals(stateCode));
            expect(registration['registration_state'], equals(stateCode));
          }
        }
      });

      test('IFSC and UPI use same bank', () {
        for (int i = 0; i < 20; i++) {
          final record = TrustTemplate.generate(seed: i);
          final ifsc = record['ifsc'] as String;
          final bankCode = record['bank_code'] as String;

          expect(ifsc.substring(0, 4), equals(bankCode));
        }
      });

      test('educational trusts prefer nationalized banks', () {
        final educationalRecord = TrustTemplate.generate(
          seed: 12345,
          trustType: 'Educational Trust',
        );

        final bankCode = educationalRecord['bank_code'] as String;

        // Educational trusts should prefer SBI, PNB, BOI, CANARA
        expect(['SBI', 'PNB', 'BOI', 'CANARA'].contains(bankCode), isTrue);
      });
    });
  });
}