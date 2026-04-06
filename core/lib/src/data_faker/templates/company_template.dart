/// Company template for generating consistent business identifiers
///
/// Generates: PAN (C), GSTIN (contains PAN), CIN, TAN, IFSC, UPI, Udyam, PIN, Address
/// Cross-field rules:
/// - PAN starts with C for company
/// - GSTIN contains the PAN in positions 2-11
/// - CIN state code matches PIN/Address state
/// - IFSC and UPI from same bank
/// - All addresses in same state

import 'dart:math';

import '../address_generator.dart';
import '../cin_generator.dart';
import '../gstin_generator.dart';
import '../ifsc_generator.dart';
import '../pan_generator.dart';
import '../pin_code_generator.dart';
import '../tan_generator.dart';
import '../udyam_generator.dart';
import '../upi_generator.dart';
import '../data/state_codes.dart';
import '../data/bank_codes.dart';

/// Private limited company data template
class CompanyTemplate {
  /// Generate complete company record with cross-field consistency
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
    String? companyType = 'private',
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

    // 3. Generate PAN with company prefix
    final pan = PANGenerator.generate(
      random: random,
      entityType: PANEntityType.company,
      prefixOverride: 'C', // Company
    );

    // 4. Generate GSTIN containing the PAN (positions 2-11)
    final gstin = GSTINGenerator.generate(
      random: random,
      stateCode: stateCode,
      panNumber: pan,
    );

    // 5. Generate CIN with matching state code
    final cin = CINGenerator.generate(
      random: random,
      companyType: _mapCompanyTypeToCIN(companyType!),
      stateCode: stateCode,
    );

    // 6. Generate TAN for tax deduction
    final tan = TANGenerator.generate(random: random);

    // 7. Generate address consistent with state
    final address = AddressGenerator.generate(
      random: random,
      pinCode: pin,
      state: stateName,
    );

    // 8. Select consistent bank for IFSC and UPI
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

    // 9. Generate Udyam for MSME registration
    final udyam = UdyamGenerator.generate(
      random: random,
      stateCode: stateCode,
    );

    return {
      'template_type': 'company',
      'company_type': companyType,
      'pan': pan,
      'gstin': gstin,
      'cin': cin,
      'tan': tan,
      'ifsc': ifsc,
      'upi_id': upi,
      'udyam': udyam,
      'pin_code': pin,
      'state': stateName,
      'state_code': stateCode,
      'address': address,
      'bank_code': bankCode,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };
  }

  /// Generate multiple company records with different seeds
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
    String? companyType = 'private',
  }) {
    final records = <Map<String, dynamic>>[];
    final baseRandom = Random(baseSeed);

    for (int i = 0; i < count; i++) {
      final recordSeed = baseSeed != null ? baseSeed + i : baseRandom.nextInt(1000000);
      records.add(generate(
        seed: recordSeed,
        preferredState: preferredState,
        companyType: companyType,
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

  /// Map company type string to CIN company type
  static CINCompanyType _mapCompanyTypeToCIN(String type) {
    switch (type.toLowerCase()) {
      case 'private':
      case 'pvt':
      case 'private_limited':
        return CINCompanyType.privateCompany;
      case 'public':
      case 'public_limited':
        return CINCompanyType.publicCompany;
      case 'limited':
      case 'ltd':
        return CINCompanyType.limitedCompany;
      default:
        return CINCompanyType.privateCompany;
    }
  }

  /// Select appropriate bank for the region
  static String _selectRegionalBank(String state, Random random) {
    // Regional bank preferences
    final regionalBanks = {
      'Karnataka': ['CANARA', 'SBI', 'VIJAYA', 'CORP'],
      'Tamil Nadu': ['IOB', 'SBI', 'CANARA', 'TMB'],
      'Maharashtra': ['SBI', 'BOI', 'UNION', 'MAHA'],
      'West Bengal': ['SBI', 'ALLH', 'UCO', 'UTBI'],
      'Gujarat': ['SBI', 'BOB', 'UNION', 'PUNJ'],
      'Rajasthan': ['SBI', 'PNB', 'BOB', 'PUNJ'],
      'Punjab': ['PNB', 'SBI', 'PUNJ', 'UTBI'],
      'Haryana': ['PNB', 'SBI', 'PUNJ', 'UCO'],
      'Delhi': ['SBI', 'PNB', 'HDFC', 'ICIC'],
      'Uttar Pradesh': ['SBI', 'PNB', 'ALLH', 'CNRB'],
    };

    final availableBanks = regionalBanks[state] ?? ['SBI', 'PNB', 'BOI', 'CANARA'];
    return availableBanks[random.nextInt(availableBanks.length)];
  }

  /// Validate company record for cross-field consistency
  static bool validate(Map<String, dynamic> record) {
    try {
      // Check required fields
      final requiredFields = [
        'pan', 'gstin', 'cin', 'tan', 'ifsc', 'upi_id', 'udyam',
        'pin_code', 'state', 'state_code', 'address', 'bank_code'
      ];

      for (final field in requiredFields) {
        if (!record.containsKey(field) || record[field] == null) {
          return false;
        }
      }

      // Validate PAN starts with C
      final pan = record['pan'] as String;
      if (!PANGenerator.isValid(pan) || pan[0] != 'C') {
        return false;
      }

      // Validate GSTIN contains PAN
      final gstin = record['gstin'] as String;
      if (!GSTINGenerator.isValid(gstin) || gstin.substring(2, 12) != pan) {
        return false;
      }

      // Validate state consistency across PIN, GSTIN, CIN
      final stateCode = record['state_code'] as String;
      if (gstin.substring(0, 2) != stateCode) {
        return false;
      }

      final cin = record['cin'] as String;
      if (!CINGenerator.isValid(cin)) {
        return false;
      }

      // Validate TAN format
      final tan = record['tan'] as String;
      if (!TANGenerator.isValid(tan)) {
        return false;
      }

      // Validate IFSC format
      final ifsc = record['ifsc'] as String;
      if (!IFSCGenerator.isValid(ifsc)) {
        return false;
      }

      // Validate UPI format
      final upi = record['upi_id'] as String;
      if (!UPIGenerator.isValid(upi)) {
        return false;
      }

      // Validate Udyam format
      final udyam = record['udyam'] as String;
      if (!UdyamGenerator.isValid(udyam)) {
        return false;
      }

      // Validate bank consistency between IFSC and UPI
      final bankCode = record['bank_code'] as String;
      if (!ifsc.startsWith(bankCode)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extract PAN from GSTIN for verification
  static String extractPANFromGSTIN(String gstin) {
    if (gstin.length >= 12) {
      return gstin.substring(2, 12);
    }
    return '';
  }

  /// Extract state code from GSTIN
  static String extractStateCodeFromGSTIN(String gstin) {
    if (gstin.length >= 2) {
      return gstin.substring(0, 2);
    }
    return '';
  }
}