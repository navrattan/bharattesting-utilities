/// Proprietorship template for generating consistent business identifiers
///
/// Generates: PAN (P), GSTIN (contains PAN), Udyam, TAN, UPI, PIN, Address
/// Cross-field rules:
/// - PAN starts with P for proprietorship
/// - GSTIN contains the PAN in positions 2-11
/// - All identifiers consistent with same state
/// - UPI linked to individual owner, not business

import 'dart:math';

import '../address_generator.dart';
import '../gstin_generator.dart';
import '../pan_generator.dart';
import '../pin_code_generator.dart';
import '../tan_generator.dart';
import '../udyam_generator.dart';
import '../upi_generator.dart';
import '../data/state_codes.dart';

/// Sole proprietorship business template
class ProprietorshipTemplate {
  /// Generate complete proprietorship record with cross-field consistency
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
    bool includeTAN = true,
  }) {
    final random = Random(seed);

    // 1. Generate PIN first to establish state context
    final pin = PinCodeGenerator.generate(
      random: random,
      state: preferredState,
    );

    // 2. Extract state info for consistency
    final stateInfo = _getStateInfoFromPin(pin);
    final stateName = stateInfo['name'];
    final stateCode = stateInfo['code'];

    // 3. Generate PAN with proprietorship prefix
    final pan = PANGenerator.generate(
      random: random,
      entityType: PANEntityType.individual, // Proprietor is individual
      prefixOverride: 'A', // Individual prefix for proprietor
    );

    // 4. Generate GSTIN containing the PAN (positions 2-11)
    final gstin = GSTINGenerator.generate(
      random: random,
      stateCode: stateCode,
      panNumber: pan,
    );

    // 5. Generate Udyam for MSME registration (common for proprietorships)
    final udyam = UdyamGenerator.generate(
      random: random,
      stateCode: stateCode,
    );

    // 6. Generate TAN if business has employees or deducts tax
    String? tan;
    if (includeTAN) {
      tan = TANGenerator.generate(random: random);
    }

    // 7. Generate address consistent with state
    final address = AddressGenerator.generate(
      random: random,
      pinCode: pin,
      state: stateName,
    );

    // 8. Generate UPI for business (but linked to individual)
    final upi = UPIGenerator.generate(
      random: random,
      preferredBank: _getRegionalBank(stateName, random),
    );

    final result = <String, dynamic>{
      'template_type': 'proprietorship',
      'pan': pan,
      'gstin': gstin,
      'udyam': udyam,
      'pin_code': pin,
      'state': stateName,
      'state_code': stateCode,
      'address': address,
      'upi_id': upi,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };

    if (tan != null) {
      result['tan'] = tan;
    }

    return result;
  }

  /// Generate multiple proprietorship records
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
    bool includeTAN = true,
  }) {
    final records = <Map<String, dynamic>>[];
    final baseRandom = Random(baseSeed);

    for (int i = 0; i < count; i++) {
      final recordSeed = baseSeed != null ? baseSeed + i : baseRandom.nextInt(1000000);
      records.add(generate(
        seed: recordSeed,
        preferredState: preferredState,
        includeTAN: includeTAN,
      ));
    }

    return records;
  }

  /// Extract state info from PIN code
  static Map<String, String> _getStateInfoFromPin(String pin) {
    for (final entry in StateCodes.pinToStateMapping.entries) {
      final ranges = entry.value;
      final pinInt = int.tryParse(pin.substring(0, 3));
      if (pinInt != null) {
        for (final range in ranges) {
          if (pinInt >= range['start'] && pinInt <= range['end']) {
            final stateName = entry.key;
            final stateCode = StateCodes.gstinStateCodes.entries
                .firstWhere((e) => e.value == stateName, orElse: () => const MapEntry('29', 'Karnataka'))
                .key;
            return {'name': stateName, 'code': stateCode};
          }
        }
      }
    }
    return {'name': 'Karnataka', 'code': '29'}; // Default fallback
  }

  /// Get preferred bank for region
  static String? _getRegionalBank(String state, Random random) {
    final regionalBanks = {
      'Karnataka': ['CANARA', 'SBI', 'VIJAYA'],
      'Tamil Nadu': ['IOB', 'SBI', 'CANARA'],
      'Maharashtra': ['SBI', 'BOI', 'UNION'],
      'West Bengal': ['SBI', 'ALLH', 'UCO'],
      'Gujarat': ['SBI', 'BOB', 'UNION'],
    };

    final banks = regionalBanks[state] ?? ['SBI', 'PNB', 'BOI'];
    return banks[random.nextInt(banks.length)];
  }

  /// Validate proprietorship record for consistency
  static bool validate(Map<String, dynamic> record) {
    try {
      // Check required fields
      final requiredFields = [
        'pan', 'gstin', 'udyam', 'pin_code', 'state', 'state_code', 'address', 'upi_id'
      ];

      for (final field in requiredFields) {
        if (!record.containsKey(field) || record[field] == null) {
          return false;
        }
      }

      // Validate PAN (proprietor PAN - individual)
      final pan = record['pan'] as String;
      if (!PANGenerator.isValid(pan)) {
        return false;
      }

      // Validate GSTIN contains PAN
      final gstin = record['gstin'] as String;
      if (!GSTINGenerator.isValid(gstin) || gstin.substring(2, 12) != pan) {
        return false;
      }

      // Validate state consistency
      final stateCode = record['state_code'] as String;
      if (gstin.substring(0, 2) != stateCode) {
        return false;
      }

      // Validate Udyam
      final udyam = record['udyam'] as String;
      if (!UdyamGenerator.isValid(udyam)) {
        return false;
      }

      // Validate PIN
      final pin = record['pin_code'] as String;
      if (!PinCodeGenerator.isValid(pin)) {
        return false;
      }

      // Validate UPI
      final upi = record['upi_id'] as String;
      if (!UPIGenerator.isValid(upi)) {
        return false;
      }

      // Validate TAN if present
      if (record.containsKey('tan')) {
        final tan = record['tan'] as String;
        if (!TANGenerator.isValid(tan)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if record represents a valid proprietorship
  static bool isProprietorship(Map<String, dynamic> record) {
    return record['template_type'] == 'proprietorship' &&
           record.containsKey('gstin') &&
           record.containsKey('udyam');
  }
}