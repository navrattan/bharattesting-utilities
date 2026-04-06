/// Partnership template for generating consistent business identifiers
///
/// Generates: PAN (F), GSTIN (contains PAN), TAN, IFSC, UPI, PIN, Address
/// Cross-field rules:
/// - PAN starts with F for partnership firm
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

/// Partnership firm business template
class PartnershipTemplate {
  /// Generate complete partnership record with cross-field consistency
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
    int numberOfPartners = 2,
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

    // 3. Generate PAN with partnership prefix
    final pan = PANGenerator.generate(
      random: random,
      entityType: PANEntityType.firm,
      prefixOverride: 'A', // Partnership uses individual-style PAN
    );

    // 4. Generate GSTIN containing the PAN (positions 2-11)
    final gstin = GSTINGenerator.generate(
      random: random,
      stateCode: stateCode,
      panNumber: pan,
    );

    // 5. Generate TAN for tax deduction (partnerships often need this)
    final tan = TANGenerator.generate(random: random);

    // 6. Generate address consistent with state
    final address = AddressGenerator.generate(
      random: random,
      pinCode: pin,
      state: stateName,
    );

    // 7. Select consistent bank for IFSC and UPI
    final bankCode = _selectRegionalBank(stateName, random);

    final ifsc = IFSCGenerator.generate(
      random: random,
      bankCode: bankCode,
      state: stateName,
    );

    final upi = UPIGenerator.generate(
      random: random,
      preferredBank: bankCode,
    );

    // 8. Generate partner details (basic info)
    final partners = _generatePartnerInfo(numberOfPartners, random);

    return {
      'template_type': 'partnership',
      'firm_type': 'partnership',
      'pan': pan,
      'gstin': gstin,
      'tan': tan,
      'ifsc': ifsc,
      'upi_id': upi,
      'pin_code': pin,
      'state': stateName,
      'state_code': stateCode,
      'address': address,
      'bank_code': bankCode,
      'number_of_partners': numberOfPartners,
      'partners': partners,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };
  }

  /// Generate multiple partnership records
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
    int numberOfPartners = 2,
  }) {
    final records = <Map<String, dynamic>>[];
    final baseRandom = Random(baseSeed);

    for (int i = 0; i < count; i++) {
      final recordSeed = baseSeed != null ? baseSeed + i : baseRandom.nextInt(1000000);
      records.add(generate(
        seed: recordSeed,
        preferredState: preferredState,
        numberOfPartners: numberOfPartners,
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

  /// Select appropriate bank for the region
  static String _selectRegionalBank(String state, Random random) {
    final regionalBanks = {
      'Karnataka': ['CANARA', 'SBI', 'VIJAYA', 'CORP'],
      'Tamil Nadu': ['IOB', 'SBI', 'CANARA', 'TMB'],
      'Maharashtra': ['SBI', 'BOI', 'UNION', 'MAHA'],
      'West Bengal': ['SBI', 'ALLH', 'UCO', 'UTBI'],
      'Gujarat': ['SBI', 'BOB', 'UNION', 'PUNJ'],
    };

    final banks = regionalBanks[state] ?? ['SBI', 'PNB', 'BOI', 'CANARA'];
    return banks[random.nextInt(banks.length)];
  }

  /// Generate basic partner information
  static List<Map<String, String>> _generatePartnerInfo(int count, Random random) {
    const partnerNames = [
      'Partner 1', 'Partner 2', 'Partner 3', 'Partner 4', 'Partner 5'
    ];

    final partners = <Map<String, String>>[];
    for (int i = 0; i < count; i++) {
      partners.add({
        'name': i < partnerNames.length ? partnerNames[i] : 'Partner ${i + 1}',
        'role': i == 0 ? 'Managing Partner' : 'Partner',
        'share_percentage': _calculateShare(i, count),
      });
    }
    return partners;
  }

  /// Calculate partner share percentage
  static String _calculateShare(int index, int total) {
    if (total == 2) {
      return index == 0 ? '60.0' : '40.0';
    } else if (total == 3) {
      return index == 0 ? '50.0' : '25.0';
    } else {
      final share = (100 / total).toStringAsFixed(1);
      return share;
    }
  }

  /// Validate partnership record for consistency
  static bool validate(Map<String, dynamic> record) {
    try {
      // Check required fields
      final requiredFields = [
        'pan', 'gstin', 'tan', 'ifsc', 'upi_id',
        'pin_code', 'state', 'state_code', 'address', 'bank_code', 'partners'
      ];

      for (final field in requiredFields) {
        if (!record.containsKey(field) || record[field] == null) {
          return false;
        }
      }

      // Validate PAN
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

      // Validate partners array
      final partners = record['partners'] as List;
      if (partners.isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if record represents a valid partnership
  static bool isPartnership(Map<String, dynamic> record) {
    return record['template_type'] == 'partnership' &&
           record.containsKey('partners') &&
           (record['partners'] as List).length >= 2;
  }
}