#!/usr/bin/env dart

// Quick test script to verify data faker functionality locally
import 'core/lib/bharattesting_core.dart' as core;

void main() {
  print('🧪 Testing Indian Data Faker - Company Template');
  print('=' * 50);

  try {
    // Test Company Template Generation
    print('\n1. Testing Company Template Generation...');
    final companyRecords = core.CompanyTemplate.generateBulk(count: 3, baseSeed: 12345);

    print('✅ Generated ${companyRecords.length} company records');
    if (companyRecords.isNotEmpty) {
      final firstRecord = companyRecords.first;
      print('\n📋 First Record Fields:');
      firstRecord.forEach((key, value) {
        print('  $key: $value');
      });

      // Check for critical fields
      final hasCompanyName = firstRecord.containsKey('company_name');
      final hasName = firstRecord.containsKey('name');
      final hasPAN = firstRecord.containsKey('pan');
      final hasGSTIN = firstRecord.containsKey('gstin');

      print('\n🔍 Field Check:');
      print('  company_name: ${hasCompanyName ? '✅' : '❌'} ${hasCompanyName ? firstRecord['company_name'] : 'MISSING'}');
      print('  name: ${hasName ? '✅' : '❌'} ${hasName ? firstRecord['name'] : 'MISSING'}');
      print('  pan: ${hasPAN ? '✅' : '❌'} ${hasPAN ? firstRecord['pan'] : 'MISSING'}');
      print('  gstin: ${hasGSTIN ? '✅' : '❌'} ${hasGSTIN ? firstRecord['gstin'] : 'MISSING'}');
    }

    // Test field filtering (simulating what the UI does)
    print('\n2. Testing Field Filtering (UI Simulation)...');
    final selectedIdentifiers = ['name', 'pan', 'gstin', 'cin'];

    final filteredRecords = companyRecords.map((record) {
      final filtered = <String, dynamic>{};

      // Filter based on requested identifiers (matching the provider logic)
      for (final id in selectedIdentifiers) {
        if (record.containsKey(id)) {
          filtered[id] = record[id];
        }
      }

      // Handle both individual and company name fields (matching the fixed logic)
      if (record.containsKey('name')) {
        filtered['name'] = record['name'];
      } else if (record.containsKey('company_name')) {
        filtered['name'] = record['company_name'];
        filtered['company_name'] = record['company_name'];
      }

      // Fallback mechanism for empty records (matching the fixed logic)
      if (filtered.isEmpty && record.isNotEmpty) {
        final fallbackFields = ['name', 'company_name', 'pan', 'gstin', 'aadhaar'];
        for (final field in fallbackFields) {
          if (record.containsKey(field)) {
            filtered[field] = record[field];
          }
        }
      }

      return filtered;
    }).toList();

    print('✅ Filtered ${filteredRecords.length} records');
    if (filteredRecords.isNotEmpty) {
      final firstFiltered = filteredRecords.first;
      print('\n📋 First Filtered Record:');
      firstFiltered.forEach((key, value) {
        print('  $key: $value');
      });

      if (firstFiltered.isEmpty) {
        print('❌ CRITICAL ERROR: Filtered record is empty!');
        print('   This would cause the "View Preview" button to not appear');
      } else {
        print('✅ Filtered record contains data - "View Preview" should appear');
      }
    }

    print('\n3. Testing Individual Template for comparison...');
    final individualRecords = core.IndividualTemplate.generateBulk(count: 1, baseSeed: 12345);
    if (individualRecords.isNotEmpty) {
      print('✅ Individual template works - generated ${individualRecords.length} record(s)');
      final firstIndividual = individualRecords.first;
      print('   Individual record fields: ${firstIndividual.keys.join(', ')}');
    }

    print('\n🎯 CONCLUSION:');
    if (companyRecords.isNotEmpty && filteredRecords.isNotEmpty && filteredRecords.first.isNotEmpty) {
      print('✅ Company template generation should work properly');
      print('✅ "View Preview" button should appear after generation');
    } else {
      print('❌ There is still an issue with company template generation');
    }

  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
  }

  print('\n' + '=' * 50);
  print('🏁 Test completed');
}