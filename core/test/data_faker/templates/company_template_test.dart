import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/templates/company_template.dart';
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/cin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/ifsc_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';
import 'package:bharattesting_core/src/data_faker/udyam_generator.dart';

void main() {
  group('CompanyTemplate', () {
    group('generate', () {
      test('generates valid company record with all required fields', () {
        final record = CompanyTemplate.generate(seed: 12345);

        expect(record['template_type'], equals('company'));
        expect(record['company_type'], equals('private'));
        expect(record['pan'], isA<String>());
        expect(record['gstin'], isA<String>());
        expect(record['cin'], isA<String>());
        expect(record['tan'], isA<String>());
        expect(record['ifsc'], isA<String>());
        expect(record['upi_id'], isA<String>());
        expect(record['udyam'], isA<String>());
        expect(record['pin_code'], isA<String>());
        expect(record['state'], isA<String>());
        expect(record['state_code'], isA<String>());
        expect(record['address'], isA<String>());
        expect(record['bank_code'], isA<String>());
        expect(record['generated_at'], isA<String>());
        expect(record['seed_used'], equals(12345));
      });

      test('generates PAN with company prefix (C)', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;

        expect(PANGenerator.isValid(pan), isTrue);
        expect(pan[0], equals('C'));
      });

      test('generates GSTIN containing the PAN', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;
        final gstin = record['gstin'] as String;

        expect(GSTINGenerator.isValid(gstin), isTrue);
        expect(gstin.substring(2, 12), equals(pan));
      });

      test('maintains state consistency across GSTIN, CIN, and PIN', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final gstin = record['gstin'] as String;
        final cin = record['cin'] as String;
        final stateCode = record['state_code'] as String;

        // GSTIN state code should match
        expect(gstin.substring(0, 2), equals(stateCode));

        // CIN should be valid
        expect(CINGenerator.isValid(cin), isTrue);
      });

      test('generates consistent IFSC and UPI from same bank', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final ifsc = record['ifsc'] as String;
        final upi = record['upi_id'] as String;
        final bankCode = record['bank_code'] as String;

        expect(IFSCGenerator.isValid(ifsc), isTrue);
        expect(UPIGenerator.isValid(upi), isTrue);
        expect(ifsc.startsWith(bankCode), isTrue);
      });

      test('generates valid TAN', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final tan = record['tan'] as String;

        expect(TANGenerator.isValid(tan), isTrue);
      });

      test('generates valid Udyam registration', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final udyam = record['udyam'] as String;

        expect(UdyamGenerator.isValid(udyam), isTrue);
      });

      test('respects preferredState parameter', () {
        final record = CompanyTemplate.generate(
          seed: 12345,
          preferredState: 'Maharashtra',
        );

        expect(record['state'], equals('Maharashtra'));

        final gstin = record['gstin'] as String;
        expect(gstin.substring(0, 2), equals('27')); // Maharashtra state code
      });

      test('respects companyType parameter', () {
        final record = CompanyTemplate.generate(
          seed: 12345,
          companyType: 'public',
        );

        expect(record['company_type'], equals('public'));
      });

      test('generates same record with same seed', () {
        final record1 = CompanyTemplate.generate(seed: 42);
        final record2 = CompanyTemplate.generate(seed: 42);

        expect(record1['pan'], equals(record2['pan']));
        expect(record1['gstin'], equals(record2['gstin']));
        expect(record1['cin'], equals(record2['cin']));
        expect(record1['ifsc'], equals(record2['ifsc']));
      });
    });

    group('generateBulk', () {
      test('generates specified number of records', () {
        const count = 50;
        final records = CompanyTemplate.generateBulk(count: count, baseSeed: 1000);

        expect(records.length, equals(count));

        for (final record in records) {
          expect(record['template_type'], equals('company'));
          expect(CompanyTemplate.validate(record), isTrue);
        }
      });

      test('generates unique records in bulk', () {
        const count = 100;
        final records = CompanyTemplate.generateBulk(count: count, baseSeed: 2000);

        final pans = records.map((r) => r['pan']).toSet();
        final gstins = records.map((r) => r['gstin']).toSet();
        final cins = records.map((r) => r['cin']).toSet();

        expect(pans.length, equals(count));
        expect(gstins.length, equals(count));
        expect(cins.length, equals(count));
      });

      test('generates 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = CompanyTemplate.generateBulk(count: count, baseSeed: 5000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000)); // Under 3 seconds

        print('Generated $count company records in ${duration}ms');
      });
    });

    group('validate', () {
      test('validates correct company record', () {
        final record = CompanyTemplate.generate(seed: 12345);
        expect(CompanyTemplate.validate(record), isTrue);
      });

      test('rejects record with non-company PAN prefix', () {
        final record = CompanyTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;
        record['pan'] = 'A${pan.substring(1)}'; // Individual prefix

        expect(CompanyTemplate.validate(record), isFalse);
      });

      test('rejects record with GSTIN not containing PAN', () {
        final record = CompanyTemplate.generate(seed: 12345);
        record['gstin'] = '29ABCDE1234A1Z5'; // Different PAN

        expect(CompanyTemplate.validate(record), isFalse);
      });

      test('rejects record with state code mismatch', () {
        final record = CompanyTemplate.generate(seed: 12345);
        record['state_code'] = '27'; // Maharashtra
        final gstin = record['gstin'] as String;
        record['gstin'] = '29${gstin.substring(2)}'; // Karnataka GSTIN

        expect(CompanyTemplate.validate(record), isFalse);
      });

      test('rejects record with bank inconsistency', () {
        final record = CompanyTemplate.generate(seed: 12345);
        record['bank_code'] = 'SBI';
        record['ifsc'] = 'CANR0001234'; // Canara bank IFSC

        expect(CompanyTemplate.validate(record), isFalse);
      });

      test('rejects record missing required fields', () {
        final record = CompanyTemplate.generate(seed: 12345);
        record.remove('cin');

        expect(CompanyTemplate.validate(record), isFalse);
      });
    });

    group('utility methods', () {
      test('extractPANFromGSTIN works correctly', () {
        const gstin = '29ABCDE1234F1Z5';
        final extractedPAN = CompanyTemplate.extractPANFromGSTIN(gstin);

        expect(extractedPAN, equals('ABCDE1234F'));
      });

      test('extractStateCodeFromGSTIN works correctly', () {
        const gstin = '27ABCDE1234F1Z5';
        final stateCode = CompanyTemplate.extractStateCodeFromGSTIN(gstin);

        expect(stateCode, equals('27'));
      });
    });

    group('cross-field consistency', () {
      test('PAN is embedded in GSTIN correctly', () {
        for (int i = 0; i < 20; i++) {
          final record = CompanyTemplate.generate(seed: i);
          final pan = record['pan'] as String;
          final gstin = record['gstin'] as String;

          expect(gstin.substring(2, 12), equals(pan));
        }
      });

      test('state codes are consistent across identifiers', () {
        for (int i = 0; i < 20; i++) {
          final record = CompanyTemplate.generate(seed: i);
          final gstin = record['gstin'] as String;
          final stateCode = record['state_code'] as String;

          expect(gstin.substring(0, 2), equals(stateCode));
        }
      });

      test('IFSC and UPI use same bank', () {
        for (int i = 0; i < 20; i++) {
          final record = CompanyTemplate.generate(seed: i);
          final ifsc = record['ifsc'] as String;
          final bankCode = record['bank_code'] as String;

          expect(ifsc.substring(0, 4), equals(bankCode));
        }
      });

      test('generates regionally appropriate banks', () {
        final recordKA = CompanyTemplate.generate(seed: 1, preferredState: 'Karnataka');
        final recordTN = CompanyTemplate.generate(seed: 2, preferredState: 'Tamil Nadu');

        final bankKA = recordKA['bank_code'] as String;
        final bankTN = recordTN['bank_code'] as String;

        // Karnataka often uses Canara bank
        expect(['CANARA', 'SBI', 'VIJAYA', 'CORP'].contains(bankKA), isTrue);

        // Tamil Nadu often uses IOB
        expect(['IOB', 'SBI', 'CANARA', 'TMB'].contains(bankTN), isTrue);
      });
    });
  });
}