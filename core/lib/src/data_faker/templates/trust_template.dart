/// Trust template for generating consistent identifiers for trusts/societies
///
/// Generates: PAN (T), GSTIN (contains PAN), TAN, IFSC, UPI, PIN, Address
/// Cross-field rules:
/// - PAN starts with A for trust (treated as association)
/// - GSTIN contains the PAN in positions 2-11
/// - IFSC and UPI from same bank
/// - All identifiers consistent with same state

import 'dart:math';

import '../address_generator.dart';
import '../gstin_generator.dart';
import '../ifsc_generator.dart';
import '../pan_generator.dart';
import '../pin_code_generator.dart';
import '../tan_generator.dart';
import '../upi_generator.dart';
import '../data/state_codes.dart';

/// Trust/society/association template
class TrustTemplate {
  /// Types of trusts supported
  static const List<String> trustTypes = [
    'Charitable Trust',
    'Religious Trust',
    'Educational Trust',
    'Public Charitable Trust',
    'Private Trust',
    'Society',
    'Association',
  ];

  /// Generate complete trust record with cross-field consistency
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
    String? trustType,
  }) {
    final random = Random(seed);

    // 1. Select trust type if not specified
    final selectedTrustType = trustType ??
        trustTypes[random.nextInt(trustTypes.length)];

    // 2. Generate PIN first to establish state context
    final pin = PinCodeGenerator.generate(
      random: random,
      state: preferredState,
    );

    // 3. Extract state info for consistency
    final stateInfo = _getStateInfoFromPin(pin);
    final stateName = stateInfo['name'];
    final stateCode = stateInfo['code'];

    // 4. Generate PAN for trust (association type)
    final pan = PANGenerator.generate(
      random: random,
      entityType: PANEntityType.association,
      prefixOverride: 'A', // Association/Trust prefix
    );

    // 5. Generate GSTIN containing the PAN (if trust is GST registered)
    final hasGST = _shouldHaveGST(selectedTrustType, random);
    String? gstin;
    if (hasGST) {
      gstin = GSTINGenerator.generate(
        random: random,
        stateCode: stateCode,
        panNumber: pan,
      );
    }

    // 6. Generate TAN for tax deduction (most trusts need this)
    final tan = TANGenerator.generate(random: random);

    // 7. Generate address consistent with state
    final address = AddressGenerator.generate(
      random: random,
      pinCode: pin,
      state: stateName,
    );

    // 8. Select consistent bank for IFSC and UPI
    final bankCode = _selectAppropriateBank(selectedTrustType, stateName, random);

    final ifsc = IFSCGenerator.generate(
      random: random,
      bankCode: bankCode,
      state: stateName,
    );

    final upi = UPIGenerator.generate(
      random: random,
      preferredBank: bankCode,
    );

    // 9. Generate trust-specific details
    final registration = _generateRegistrationInfo(selectedTrustType, stateCode, random);

    final result = <String, dynamic>{
      'template_type': 'trust',
      'trust_type': selectedTrustType,
      'pan': pan,
      'tan': tan,
      'ifsc': ifsc,
      'upi_id': upi,
      'pin_code': pin,
      'state': stateName,
      'state_code': stateCode,
      'address': address,
      'bank_code': bankCode,
      'registration': registration,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };

    if (gstin != null) {
      result['gstin'] = gstin;
      result['gst_registered'] = true;
    } else {
      result['gst_registered'] = false;
    }

    return result;
  }

  /// Generate multiple trust records
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
    String? trustType,
  }) {
    final records = <Map<String, dynamic>>[];
    final baseRandom = Random(baseSeed);

    for (int i = 0; i < count; i++) {
      final recordSeed = baseSeed != null ? baseSeed + i : baseRandom.nextInt(1000000);
      records.add(generate(
        seed: recordSeed,
        preferredState: preferredState,
        trustType: trustType,
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

  /// Determine if trust should have GST registration
  static bool _shouldHaveGST(String trustType, Random random) {
    // Educational and charitable trusts less likely to have GST
    if (trustType.contains('Educational') || trustType.contains('Charitable')) {
      return random.nextDouble() < 0.3; // 30% chance
    }
    // Other trusts more likely
    return random.nextDouble() < 0.7; // 70% chance
  }

  /// Select appropriate bank based on trust type and region
  static String _selectAppropriateBank(String trustType, String state, Random random) {
    // Trusts often use nationalized banks
    List<String> preferredBanks;

    if (trustType.contains('Educational') || trustType.contains('Charitable')) {
      // Educational/charitable trusts prefer SBI, PNB
      preferredBanks = ['SBI', 'PNB', 'BOI', 'CANARA'];
    } else {
      // Other trusts can use regional banks too
      final regionalBanks = {
        'Karnataka': ['CANARA', 'SBI', 'VIJAYA'],
        'Tamil Nadu': ['IOB', 'SBI', 'CANARA'],
        'Maharashtra': ['SBI', 'BOI', 'UNION'],
        'West Bengal': ['SBI', 'ALLH', 'UCO'],
        'Gujarat': ['SBI', 'BOB', 'UNION'],
      };
      preferredBanks = regionalBanks[state] ?? ['SBI', 'PNB', 'BOI'];
    }

    return preferredBanks[random.nextInt(preferredBanks.length)];
  }

  /// Generate registration information for trust
  static Map<String, dynamic> _generateRegistrationInfo(String trustType, String stateCode, Random random) {
    final registrationYear = 1980 + random.nextInt(44); // 1980-2024
    final registrationNumber = random.nextInt(99999) + 1;

    String registrationPrefix;
    String registrationAuthority;

    if (trustType.contains('Society')) {
      registrationPrefix = 'SOC';
      registrationAuthority = 'Registrar of Societies';
    } else if (trustType.contains('Trust')) {
      registrationPrefix = 'TR';
      registrationAuthority = 'Registrar of Trusts';
    } else {
      registrationPrefix = 'ASSN';
      registrationAuthority = 'Registrar of Associations';
    }

    return {
      'registration_number': '$registrationPrefix$stateCode$registrationYear$registrationNumber',
      'registration_year': registrationYear,
      'registration_authority': registrationAuthority,
      'registration_state': stateCode,
    };
  }

  /// Validate trust record for consistency
  static bool validate(Map<String, dynamic> record) {
    try {
      // Check required fields
      final requiredFields = [
        'pan', 'tan', 'ifsc', 'upi_id',
        'pin_code', 'state', 'state_code', 'address', 'bank_code',
        'trust_type', 'registration'
      ];

      for (final field in requiredFields) {
        if (!record.containsKey(field) || record[field] == null) {
          return false;
        }
      }

      // Validate PAN (should start with A for association)
      final pan = record['pan'] as String;
      if (!PANGenerator.isValid(pan) || pan[0] != 'A') {
        return false;
      }

      // Validate GSTIN if present
      if (record.containsKey('gstin') && record['gstin'] != null) {
        final gstin = record['gstin'] as String;
        if (!GSTINGenerator.isValid(gstin) || gstin.substring(2, 12) != pan) {
          return false;
        }

        // Validate state consistency
        final stateCode = record['state_code'] as String;
        if (gstin.substring(0, 2) != stateCode) {
          return false;
        }
      }

      // Validate TAN
      final tan = record['tan'] as String;
      if (!TANGenerator.isValid(tan)) {
        return false;
      }

      // Validate IFSC
      final ifsc = record['ifsc'] as String;
      if (!IFSCGenerator.isValid(ifsc)) {
        return false;
      }

      // Validate UPI
      final upi = record['upi_id'] as String;
      if (!UPIGenerator.isValid(upi)) {
        return false;
      }

      // Validate bank consistency
      final bankCode = record['bank_code'] as String;
      if (!ifsc.startsWith(bankCode)) {
        return false;
      }

      // Validate trust type
      final trustType = record['trust_type'] as String;
      if (!trustTypes.contains(trustType)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if record represents a valid trust
  static bool isTrust(Map<String, dynamic> record) {
    return record['template_type'] == 'trust' &&
           trustTypes.contains(record['trust_type']);
  }
}