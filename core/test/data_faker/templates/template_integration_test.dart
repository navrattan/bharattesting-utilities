import 'package:test/test.dart';
import 'package:core/src/data_faker/templates/individual_template.dart';
import 'package:core/src/data_faker/templates/company_template.dart';
import 'package:core/src/data_faker/templates/proprietorship_template.dart';
import 'package:core/src/data_faker/templates/partnership_template.dart';
import 'package:core/src/data_faker/templates/trust_template.dart';

void main() {
  group('Template Integration Tests', () {
    group('All Templates Cross-Field Consistency', () {
      test('all templates generate valid records with same seed', () {
        const testSeed = 42;

        final individual = IndividualTemplate.generate(seed: testSeed);
        final company = CompanyTemplate.generate(seed: testSeed);
        final proprietorship = ProprietorshipTemplate.generate(seed: testSeed);
        final partnership = PartnershipTemplate.generate(seed: testSeed);
        final trust = TrustTemplate.generate(seed: testSeed);

        // All should be valid
        expect(IndividualTemplate.validate(individual), isTrue);
        expect(CompanyTemplate.validate(company), isTrue);
        expect(ProprietorshipTemplate.validate(proprietorship), isTrue);
        expect(PartnershipTemplate.validate(partnership), isTrue);
        expect(TrustTemplate.validate(trust), isTrue);

        // All should have consistent template types
        expect(individual['template_type'], equals('individual'));
        expect(company['template_type'], equals('company'));
        expect(proprietorship['template_type'], equals('proprietorship'));
        expect(partnership['template_type'], equals('partnership'));
        expect(trust['template_type'], equals('trust'));
      });

      test('all templates respect preferredState parameter consistently', () {
        const testState = 'Karnataka';
        const testSeed = 123;

        final individual = IndividualTemplate.generate(
          seed: testSeed,
          preferredState: testState,
        );
        final company = CompanyTemplate.generate(
          seed: testSeed,
          preferredState: testState,
        );
        final proprietorship = ProprietorshipTemplate.generate(
          seed: testSeed,
          preferredState: testState,
        );
        final partnership = PartnershipTemplate.generate(
          seed: testSeed,
          preferredState: testState,
        );
        final trust = TrustTemplate.generate(
          seed: testSeed,
          preferredState: testState,
        );

        // All should be in Karnataka
        expect(individual['state'], equals(testState));
        expect(company['state'], equals(testState));
        expect(proprietorship['state'], equals(testState));
        expect(partnership['state'], equals(testState));
        expect(trust['state'], equals(testState));

        // All should have Karnataka state code (29) where applicable
        expect(company['state_code'], equals('29'));
        expect(proprietorship['state_code'], equals('29'));
        expect(partnership['state_code'], equals('29'));
        expect(trust['state_code'], equals('29'));
      });

      test('business templates have consistent GSTIN-PAN relationships', () {
        const testSeed = 456;

        final company = CompanyTemplate.generate(seed: testSeed);
        final proprietorship = ProprietorshipTemplate.generate(seed: testSeed);
        final partnership = PartnershipTemplate.generate(seed: testSeed);

        // All should have GSTIN containing their PAN
        final companyPAN = company['pan'] as String;
        final companyGSTIN = company['gstin'] as String;
        expect(companyGSTIN.substring(2, 12), equals(companyPAN));

        final proprietorshipPAN = proprietorship['pan'] as String;
        final proprietorshipGSTIN = proprietorship['gstin'] as String;
        expect(proprietorshipGSTIN.substring(2, 12), equals(proprietorshipPAN));

        final partnershipPAN = partnership['pan'] as String;
        final partnershipGSTIN = partnership['gstin'] as String;
        expect(partnershipGSTIN.substring(2, 12), equals(partnershipPAN));

        // Trust may or may not have GSTIN
        final trust = TrustTemplate.generate(seed: testSeed);
        final trustHasGST = trust['gst_registered'] as bool;
        if (trustHasGST) {
          final trustPAN = trust['pan'] as String;
          final trustGSTIN = trust['gstin'] as String;
          expect(trustGSTIN.substring(2, 12), equals(trustPAN));
        }
      });

      test('templates with banking details maintain bank consistency', () {
        const testSeed = 789;

        final company = CompanyTemplate.generate(seed: testSeed);
        final partnership = PartnershipTemplate.generate(seed: testSeed);
        final trust = TrustTemplate.generate(seed: testSeed);

        // Company bank consistency
        final companyIFSC = company['ifsc'] as String;
        final companyBankCode = company['bank_code'] as String;
        expect(companyIFSC.startsWith(companyBankCode), isTrue);

        // Partnership bank consistency
        final partnershipIFSC = partnership['ifsc'] as String;
        final partnershipBankCode = partnership['bank_code'] as String;
        expect(partnershipIFSC.startsWith(partnershipBankCode), isTrue);

        // Trust bank consistency
        final trustIFSC = trust['ifsc'] as String;
        final trustBankCode = trust['bank_code'] as String;
        expect(trustIFSC.startsWith(trustBankCode), isTrue);
      });
    });

    group('Performance Tests', () {
      test('individual template - 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = IndividualTemplate.generateBulk(count: count, baseSeed: 1000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000));

        print('Individual template: ${count} records in ${duration}ms');
      });

      test('company template - 10,000 records in under 3 seconds', () {
        const count = 10000;
        final stopwatch = Stopwatch()..start();

        final records = CompanyTemplate.generateBulk(count: count, baseSeed: 2000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(records.length, equals(count));
        expect(duration, lessThan(3000));

        print('Company template: ${count} records in ${duration}ms');
      });

      test('mixed templates - 2,000 each type in under 3 seconds', () {
        const count = 2000;
        final stopwatch = Stopwatch()..start();

        final individual = IndividualTemplate.generateBulk(count: count, baseSeed: 1000);
        final company = CompanyTemplate.generateBulk(count: count, baseSeed: 2000);
        final proprietorship = ProprietorshipTemplate.generateBulk(count: count, baseSeed: 3000);
        final partnership = PartnershipTemplate.generateBulk(count: count, baseSeed: 4000);
        final trust = TrustTemplate.generateBulk(count: count, baseSeed: 5000);

        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;

        expect(individual.length, equals(count));
        expect(company.length, equals(count));
        expect(proprietorship.length, equals(count));
        expect(partnership.length, equals(count));
        expect(trust.length, equals(count));

        final totalRecords = count * 5;
        expect(duration, lessThan(3000));

        print('Mixed templates: ${totalRecords} records in ${duration}ms');
      });
    });

    group('Data Quality Tests', () {
      test('no duplicate identifiers within same template type', () {
        const count = 1000;

        final individualRecords = IndividualTemplate.generateBulk(count: count, baseSeed: 1000);
        final pans = individualRecords.map((r) => r['pan']).toSet();
        final aadhars = individualRecords.map((r) => r['aadhaar']).toSet();

        expect(pans.length, equals(count)); // All unique PANs
        expect(aadhars.length, equals(count)); // All unique Aadhaar numbers
      });

      test('no duplicate identifiers across different template types', () {
        const count = 500;

        final individual = IndividualTemplate.generateBulk(count: count, baseSeed: 1000);
        final company = CompanyTemplate.generateBulk(count: count, baseSeed: 2000);
        final partnership = PartnershipTemplate.generateBulk(count: count, baseSeed: 3000);

        final allPANs = <String>{};
        allPANs.addAll(individual.map((r) => r['pan'] as String));
        allPANs.addAll(company.map((r) => r['pan'] as String));
        allPANs.addAll(partnership.map((r) => r['pan'] as String));

        // All PANs should be unique across templates
        expect(allPANs.length, equals(count * 3));
      });

      test('all generated records pass validation', () {
        const count = 100;

        final individual = IndividualTemplate.generateBulk(count: count, baseSeed: 1000);
        final company = CompanyTemplate.generateBulk(count: count, baseSeed: 2000);
        final proprietorship = ProprietorshipTemplate.generateBulk(count: count, baseSeed: 3000);
        final partnership = PartnershipTemplate.generateBulk(count: count, baseSeed: 4000);
        final trust = TrustTemplate.generateBulk(count: count, baseSeed: 5000);

        // All records should pass validation
        for (final record in individual) {
          expect(IndividualTemplate.validate(record), isTrue);
        }

        for (final record in company) {
          expect(CompanyTemplate.validate(record), isTrue);
        }

        for (final record in proprietorship) {
          expect(ProprietorshipTemplate.validate(record), isTrue);
        }

        for (final record in partnership) {
          expect(PartnershipTemplate.validate(record), isTrue);
        }

        for (final record in trust) {
          expect(TrustTemplate.validate(record), isTrue);
        }
      });
    });

    group('Template Type Distribution', () {
      test('different templates produce different entity characteristics', () {
        const testSeed = 12345;

        final individual = IndividualTemplate.generate(seed: testSeed);
        final company = CompanyTemplate.generate(seed: testSeed);
        final partnership = PartnershipTemplate.generate(seed: testSeed);

        // Individual should not have business identifiers
        expect(individual.containsKey('gstin'), isFalse);
        expect(individual.containsKey('cin'), isFalse);
        expect(individual.containsKey('tan'), isFalse);

        // Company should have all business identifiers
        expect(company.containsKey('gstin'), isTrue);
        expect(company.containsKey('cin'), isTrue);
        expect(company.containsKey('tan'), isTrue);

        // Partnership should have some business identifiers but not CIN
        expect(partnership.containsKey('gstin'), isTrue);
        expect(partnership.containsKey('cin'), isFalse);
        expect(partnership.containsKey('tan'), isTrue);
        expect(partnership.containsKey('partners'), isTrue);
      });
    });

    group('Reproducibility Tests', () {
      test('same seed produces identical results across multiple runs', () {
        const testSeed = 98765;

        // First run
        final run1Individual = IndividualTemplate.generate(seed: testSeed);
        final run1Company = CompanyTemplate.generate(seed: testSeed);

        // Second run
        final run2Individual = IndividualTemplate.generate(seed: testSeed);
        final run2Company = CompanyTemplate.generate(seed: testSeed);

        // Should be identical
        expect(run1Individual, equals(run2Individual));
        expect(run1Company, equals(run2Company));
      });

      test('bulk generation with same base seed is reproducible', () {
        const count = 100;
        const baseSeed = 54321;

        // First run
        final run1Records = IndividualTemplate.generateBulk(
          count: count,
          baseSeed: baseSeed,
        );

        // Second run
        final run2Records = IndividualTemplate.generateBulk(
          count: count,
          baseSeed: baseSeed,
        );

        // Should be identical
        expect(run1Records.length, equals(run2Records.length));
        for (int i = 0; i < count; i++) {
          expect(run1Records[i], equals(run2Records[i]));
        }
      });
    });
  });
}