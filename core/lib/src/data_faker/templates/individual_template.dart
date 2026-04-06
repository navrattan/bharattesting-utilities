/// Individual template for generating consistent personal identifiers
///
/// Generates: PAN (P), Aadhaar, PIN, Address, UPI
/// Cross-field rules:
/// - PAN starts with letter for individual (A-Z)
/// - Aadhaar valid Verhoeff checksum
/// - PIN and Address state-consistent
/// - UPI linked to realistic bank for location

import 'dart:math';

import '../aadhaar_generator.dart';
import '../address_generator.dart';
import '../pan_generator.dart';
import '../pin_code_generator.dart';
import '../upi_generator.dart';
import '../data/state_codes.dart';

/// Individual person data template
class IndividualTemplate {
  static const List<String> _individualPrefixes = [
    'A', 'B', 'C', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P'
  ];

  /// Generate complete individual record with cross-field consistency
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
  }) {
    final random = Random(seed);

    // 1. Generate PIN first to establish state context
    final pin = PinCodeGenerator.generate(
      random: random,
      state: preferredState,
    );

    // 2. Extract state from PIN for consistency
    final state = _getStateFromPin(pin);

    // 3. Generate address consistent with PIN/state
    final address = AddressGenerator.generate(
      random: random,
      pinCode: pin,
      state: state,
    );

    // 4. Generate PAN with individual prefix
    final pan = PANGenerator.generate(
      random: random,
      entityType: PANEntityType.individual,
      prefixOverride: _individualPrefixes[random.nextInt(_individualPrefixes.length)],
    );

    // 5. Generate Aadhaar with valid checksum
    final aadhaar = AadhaarGenerator.generate(random: random);

    // 6. Generate UPI with bank appropriate for region
    final upi = UPIGenerator.generate(
      random: random,
      preferredBank: _getRegionalBank(state, random),
    );

    return {
      'template_type': 'individual',
      'pan': pan,
      'aadhaar': aadhaar,
      'pin_code': pin,
      'state': state,
      'address': address,
      'upi_id': upi,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };
  }

  /// Generate multiple individual records with different seeds
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    final records = <Map<String, dynamic>>[];
    final baseRandom = Random(baseSeed);

    for (int i = 0; i < count; i++) {
      final recordSeed = baseSeed != null ? baseSeed + i : baseRandom.nextInt(1000000);
      records.add(generate(
        seed: recordSeed,
        preferredState: preferredState,
      ));
    }

    return records;
  }

  /// Extract state from PIN code using lookup
  static String _getStateFromPin(String pin) {
    for (final entry in StateCodes.pinToStateMapping.entries) {
      final ranges = entry.value;
      final pinInt = int.tryParse(pin.substring(0, 3));
      if (pinInt != null) {
        for (final range in ranges) {
          if (pinInt >= range['start'] && pinInt <= range['end']) {
            return entry.key;
          }
        }
      }
    }
    return 'Karnataka'; // Default fallback
  }

  /// Get bank appropriate for region/state
  static String? _getRegionalBank(String state, Random random) {
    // Prefer nationalized banks for most regions
    const nationalizedBanks = ['SBI', 'PNB', 'BOI', 'CANARA', 'UNION'];

    // Some regional preferences
    final regionalPreferences = {
      'Karnataka': ['SBI', 'CANARA', 'VIJAYA'],
      'Tamil Nadu': ['SBI', 'IOB', 'CANARA'],
      'Maharashtra': ['SBI', 'BOI', 'UNION'],
      'West Bengal': ['SBI', 'ALLH', 'UCO'],
      'Gujarat': ['SBI', 'BOB', 'UNION'],
    };

    final preferred = regionalPreferences[state] ?? nationalizedBanks;
    return preferred[random.nextInt(preferred.length)];
  }

  /// Validate individual record for consistency
  static bool validate(Map<String, dynamic> record) {
    try {
      // Check required fields
      final requiredFields = ['pan', 'aadhaar', 'pin_code', 'state', 'address', 'upi_id'];
      for (final field in requiredFields) {
        if (!record.containsKey(field) || record[field] == null) {
          return false;
        }
      }

      // Validate PAN format for individual
      final pan = record['pan'] as String;
      if (!PANGenerator.isValid(pan) || !_individualPrefixes.contains(pan[0])) {
        return false;
      }

      // Validate Aadhaar checksum
      final aadhaar = record['aadhaar'] as String;
      if (!AadhaarGenerator.isValid(aadhaar)) {
        return false;
      }

      // Validate PIN format
      final pin = record['pin_code'] as String;
      if (!PinCodeGenerator.isValid(pin)) {
        return false;
      }

      // Validate state-PIN consistency
      final state = record['state'] as String;
      final derivedState = _getStateFromPin(pin);
      if (state != derivedState) {
        return false;
      }

      // Validate UPI format
      final upi = record['upi_id'] as String;
      if (!UPIGenerator.isValid(upi)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}