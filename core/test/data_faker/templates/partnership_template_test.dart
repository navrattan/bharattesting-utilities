import 'package:test/test.dart';
import 'package:core/src/data_faker/templates/partnership_template.dart';
import 'package:core/src/data_faker/pan_generator.dart';
import 'package:core/src/data_faker/gstin_generator.dart';
import 'package:core/src/data_faker/tan_generator.dart';
import 'package:core/src/data_faker/ifsc_generator.dart';
import 'package:core/src/data_faker/upi_generator.dart';

void main() {
  group('PartnershipTemplate', () {
    group('generate', () {
      test('generates valid partnership record with all required fields', () {
        final record = PartnershipTemplate.generate(seed: 12345);

        expect(record['template_type'], equals('partnership'));
        expect(record['firm_type'], equals('partnership'));
        expect(record['pan'], isA<String>());
        expect(record['gstin'], isA<String>());
        expect(record['tan'], isA<String>());
        expect(record['ifsc'], isA<String>());
        expect(record['upi_id'], isA<String>());
        expect(record['pin_code'], isA<String>());
        expect(record['state'], isA<String>());
        expect(record['state_code'], isA<String>());
        expect(record['address'], isA<String>());
        expect(record['bank_code'], isA<String>());
        expect(record['number_of_partners'], isA<int>());
        expect(record['partners'], isA<List>());
        expect(record['generated_at'], isA<String>());
        expect(record['seed_used'], equals(12345));
      });

      test('generates PAN with individual-style prefix for partnership', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;

        expect(PANGenerator.isValid(pan), isTrue);
        expect(pan[0], equals('A')); // Partnership uses individual-style PAN
      });

      test('generates GSTIN containing the partnership PAN', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        final pan = record['pan'] as String;
        final gstin = record['gstin'] as String;

        expect(GSTINGenerator.isValid(gstin), isTrue);
        expect(gstin.substring(2, 12), equals(pan));
      });

      test('generates valid TAN for tax deduction', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        final tan = record['tan'] as String;

        expect(TANGenerator.isValid(tan), isTrue);
      });

      test('generates consistent IFSC and UPI from same bank', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        final ifsc = record['ifsc'] as String;
        final upi = record['upi_id'] as String;
        final bankCode = record['bank_code'] as String;

        expect(IFSCGenerator.isValid(ifsc), isTrue);
        expect(UPIGenerator.isValid(upi), isTrue);
        expect(ifsc.startsWith(bankCode), isTrue);
      });

      test('generates default 2 partners', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        final numberOfPartners = record['number_of_partners'] as int;
        final partners = record['partners'] as List;

        expect(numberOfPartners, equals(2));
        expect(partners.length, equals(2));

        // Check partner structure
        for (final partner in partners) {
          expect(partner, isA<Map<String, String>>());
          final partnerMap = partner as Map<String, String>;
          expect(partnerMap.containsKey('name'), isTrue);
          expect(partnerMap.containsKey('role'), isTrue);
          expect(partnerMap.containsKey('share_percentage'), isTrue);
        }
      });

      test('respects numberOfPartners parameter', () {
        final record = PartnershipTemplate.generate(
          seed: 12345,
          numberOfPartners: 3,
        );

        final numberOfPartners = record['number_of_partners'] as int;
        final partners = record['partners'] as List;

        expect(numberOfPartners, equals(3));
        expect(partners.length, equals(3));

        // Check managing partner
        final firstPartner = partners[0] as Map<String, String>;
        expect(firstPartner['role'], equals('Managing Partner'));
      });

      test('maintains state consistency across GSTIN and PIN', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        final gstin = record['gstin'] as String;
        final stateCode = record['state_code'] as String;

        expect(gstin.substring(0, 2), equals(stateCode));
      });

      test('respects preferredState parameter', () {
        final record = PartnershipTemplate.generate(
          seed: 12345,
          preferredState: 'West Bengal',
        );

        expect(record['state'], equals('West Bengal'));

        final gstin = record['gstin'] as String;
        expect(gstin.substring(0, 2), equals('19')); // West Bengal state code
      });

      test('generates same record with same seed', () {
        final record1 = PartnershipTemplate.generate(seed: 42);
        final record2 = PartnershipTemplate.generate(seed: 42);

        expect(record1['pan'], equals(record2['pan']));
        expect(record1['gstin'], equals(record2['gstin']));
        expect(record1['ifsc'], equals(record2['ifsc']));
        expect(record1['partners'], equals(record2['partners']));
      });
    });

    group('generateBulk', () {
      test('generates specified number of records', () {
        const count = 50;
        final records = PartnershipTemplate.generateBulk(count: count, baseSeed: 1000);

        expect(records.length, equals(count));

        for (final record in records) {
          expect(record['template_type'], equals('partnership'));
          expect(PartnershipTemplate.validate(record), isTrue);
        }
      });

      test('generates unique records in bulk', () {
        const count = 100;
        final records = PartnershipTemplate.generateBulk(count: count, baseSeed: 2000);

        final pans = records.map((r) => r['pan']).toSet();
        final gstins = records.map((r) => r['gstin']).toSet();
        final ifscs = records.map((r) => r['ifsc']).toSet();

        expect(pans.length, equals(count));
        expect(gstins.length, equals(count));
        expect(ifscs.length, equals(count));
      });

      test('generates 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = PartnershipTemplate.generateBulk(count: count, baseSeed: 5000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000)); // Under 3 seconds

        print('Generated $count partnership records in ${duration}ms');
      });
    });

    group('validate', () {
      test('validates correct partnership record', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        expect(PartnershipTemplate.validate(record), isTrue);
      });

      test('rejects record with GSTIN not containing PAN', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        record['gstin'] = '29XYZTE1234A1Z5'; // Different PAN

        expect(PartnershipTemplate.validate(record), isFalse);
      });

      test('rejects record with state code mismatch', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        record['state_code'] = '27'; // Maharashtra
        final gstin = record['gstin'] as String;
        record['gstin'] = '29${gstin.substring(2)}'; // Karnataka GSTIN

        expect(PartnershipTemplate.validate(record), isFalse);
      });

      test('rejects record with bank inconsistency', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        record['bank_code'] = 'SBI';
        record['ifsc'] = 'CANR0001234'; // Canara bank IFSC

        expect(PartnershipTemplate.validate(record), isFalse);
      });

      test('rejects record with empty partners list', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        record['partners'] = <Map<String, String>>[];

        expect(PartnershipTemplate.validate(record), isFalse);
      });

      test('rejects record missing required fields', () {
        final record = PartnershipTemplate.generate(seed: 12345);
        record.remove('tan');

        expect(PartnershipTemplate.validate(record), isFalse);
      });
    });

    group('utility methods', () {
      test('isPartnership correctly identifies partnership records', () {
        final partnershipRecord = PartnershipTemplate.generate(seed: 12345);
        expect(PartnershipTemplate.isPartnership(partnershipRecord), isTrue);

        final nonPartnershipRecord = {
          'template_type': 'company',
          'partners': [{'name': 'Test'}],
        };
        expect(PartnershipTemplate.isPartnership(nonPartnershipRecord), isFalse);
      });

      test('isPartnership rejects record with insufficient partners', () {
        final invalidRecord = {
          'template_type': 'partnership',
          'partners': [{'name': 'Only One'}], // Less than 2 partners
        };
        expect(PartnershipTemplate.isPartnership(invalidRecord), isFalse);
      });
    });

    group('partner management', () {
      test('calculates correct share percentages for 2 partners', () {
        final record = PartnershipTemplate.generate(seed: 12345, numberOfPartners: 2);
        final partners = record['partners'] as List<Map<String, String>>;

        expect(partners[0]['share_percentage'], equals('60.0'));
        expect(partners[1]['share_percentage'], equals('40.0'));
      });

      test('calculates correct share percentages for 3 partners', () {
        final record = PartnershipTemplate.generate(seed: 12345, numberOfPartners: 3);
        final partners = record['partners'] as List<Map<String, String>>;

        expect(partners[0]['share_percentage'], equals('50.0'));
        expect(partners[1]['share_percentage'], equals('25.0'));
        expect(partners[2]['share_percentage'], equals('25.0'));
      });

      test('assigns managing partner role correctly', () {
        final record = PartnershipTemplate.generate(seed: 12345, numberOfPartners: 4);
        final partners = record['partners'] as List<Map<String, String>>;

        expect(partners[0]['role'], equals('Managing Partner'));

        for (int i = 1; i < partners.length; i++) {
          expect(partners[i]['role'], equals('Partner'));
        }
      });
    });

    group('cross-field consistency', () {
      test('PAN is embedded in GSTIN correctly', () {
        for (int i = 0; i < 20; i++) {
          final record = PartnershipTemplate.generate(seed: i);
          final pan = record['pan'] as String;
          final gstin = record['gstin'] as String;

          expect(gstin.substring(2, 12), equals(pan));
        }
      });

      test('state codes are consistent across GSTIN and state_code', () {
        for (int i = 0; i < 20; i++) {
          final record = PartnershipTemplate.generate(seed: i);
          final gstin = record['gstin'] as String;
          final stateCode = record['state_code'] as String;

          expect(gstin.substring(0, 2), equals(stateCode));
        }
      });

      test('IFSC and UPI use same bank', () {
        for (int i = 0; i < 20; i++) {
          final record = PartnershipTemplate.generate(seed: i);
          final ifsc = record['ifsc'] as String;
          final bankCode = record['bank_code'] as String;

          expect(ifsc.substring(0, 4), equals(bankCode));
        }
      });

      test('generates regionally appropriate banks', () {
        final recordKA = PartnershipTemplate.generate(seed: 1, preferredState: 'Karnataka');
        final recordMH = PartnershipTemplate.generate(seed: 2, preferredState: 'Maharashtra');

        final bankKA = recordKA['bank_code'] as String;
        final bankMH = recordMH['bank_code'] as String;

        // Karnataka often uses Canara bank
        expect(['CANARA', 'SBI', 'VIJAYA', 'CORP'].contains(bankKA), isTrue);

        // Maharashtra often uses SBI, BOI, Union
        expect(['SBI', 'BOI', 'UNION', 'MAHA'].contains(bankMH), isTrue);
      });
    });
  });
}